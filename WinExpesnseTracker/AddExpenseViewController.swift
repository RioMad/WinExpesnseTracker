import UIKit

class AddExpenseViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Expense"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "₹0.00"
        tf.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        tf.textColor = .white 
        tf.keyboardType = .decimalPad
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "What is this for?"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = Theme.cardBackgroundColor
        tf.textColor = Theme.textColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Replaced Picker with CollectionView
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let categories = ExpenseCategory.allCases
    private var selectedCategory: ExpenseCategory = .food
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Expense", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.accentColor
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onExpenseAdded: (() -> Void)?
    var expenseToEdit: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor
        
        // titleLabel.textColor = .white // Removed
        amountTextField.textColor = Theme.accentColor
        
        // Custom Placeholder Color
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "₹0.00",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        nameTextField.textColor = .white
        nameTextField.backgroundColor = Theme.cardBackgroundColor
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "What is this for?",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        // view.addSubview(titleLabel) // Removed
        view.addSubview(amountTextField)
        view.addSubview(nameTextField)
        view.addSubview(categoryCollectionView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // titleLabel constraints removed
            
            amountTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30), // Reduced top margin
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 20), // Reduced spacing
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryCollectionView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 110), // Reduced height
            
            saveButton.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 30), // Spacing adjusted
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 55),
            saveButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        saveButton.addTarget(self, action: #selector(saveExpense), for: .touchUpInside)
    }
    
    @objc private func saveExpense() {
        print("Save Expense Tapped")
        guard let amountText = amountTextField.text?.replacingOccurrences(of: "₹", with: "").trimmingCharacters(in: .whitespacesAndNewlines),
              !amountText.isEmpty,
              let amount = Double(amountText) else {
            showAlert(message: "Please enter a valid amount.")
            return
        }
        
        guard let title = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            showAlert(message: "Please enter a description.")
            return
        }
        
        print("Saving Expense: \(title) - \(amount)")
        
        if let expense = expenseToEdit {
            var updatedExpense = expense
            updatedExpense.title = title
            updatedExpense.amount = amount
            updatedExpense.category = selectedCategory
            ExpenseService.shared.updateExpense(updatedExpense)
        } else {
            let newExpense = Expense(title: title, amount: amount, date: Date(), category: selectedCategory)
            ExpenseService.shared.saveExpense(newExpense)
        }
        
        onExpenseAdded?()
        dismiss(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let category = categories[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100) // Updated for horizontal items
    }
    
    private func populateData() {
        guard let expense = expenseToEdit else {
            // Default selection if new
            selectedCategory = .food
            categoryCollectionView.reloadData()
            return
        }
        amountTextField.text = "₹" + String(format: "%.0f", expense.amount)
        nameTextField.text = expense.title
        selectedCategory = expense.category
        categoryCollectionView.reloadData()
        
        saveButton.setTitle("Update Expense", for: .normal)
    }
}

// MARK: - Custom Cell
class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.cardBackgroundColor
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = Theme.accentColor
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(containerView)
        addSubview(nameLabel)
        
        containerView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
            iconImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with category: ExpenseCategory, isSelected: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        iconImageView.image = UIImage(systemName: category.systemIconName, withConfiguration: config)
        nameLabel.text = category.rawValue
        
        if isSelected {
            containerView.backgroundColor = Theme.accentColor.withAlphaComponent(0.2)
            containerView.layer.borderWidth = 2
            containerView.layer.borderColor = Theme.accentColor.cgColor
            iconImageView.tintColor = Theme.accentColor
        } else {
            containerView.backgroundColor = Theme.cardBackgroundColor
            containerView.layer.borderWidth = 0
            iconImageView.tintColor = .gray
        }
    }
}
