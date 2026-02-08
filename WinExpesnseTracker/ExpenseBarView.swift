import UIKit

class ExpenseBarView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Spending by Category"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Theme.cardBackgroundColor
        layer.cornerRadius = Theme.cornerRadius
        
        addSubview(titleLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with expenses: [Expense]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Group by category
        var categoryTotals: [ExpenseCategory: Double] = [:]
        for expense in expenses {
            categoryTotals[expense.category, default: 0] += expense.amount
        }
        
        let total = expenses.reduce(0) { $0 + $1.amount }
        let maxTotal = total > 0 ? total : 1.0 // Avoid division by zero
        
        for (category, amount) in categoryTotals {
            let row = createCategoryRow(category: category, amount: amount, total: maxTotal)
            stackView.addArrangedSubview(row)
        }
        
        if expenses.isEmpty {
            let label = UILabel()
            label.text = "No expenses yet."
            label.textColor = Theme.secondaryTextColor
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
    }
    
    private func createCategoryRow(category: ExpenseCategory, amount: Double, total: Double) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLabel = UILabel()
        iconLabel.text = category.icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = category.rawValue
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = Theme.textColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = String(format: "₹%.0f", amount)
        amountLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        amountLabel.textColor = Theme.textColor
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundBar = UIView()
        backgroundBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        backgroundBar.layer.cornerRadius = 4
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        
        let progressBar = UIView()
        progressBar.backgroundColor = Theme.accentColor
        progressBar.layer.cornerRadius = 4
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconLabel)
        container.addSubview(nameLabel)
        container.addSubview(amountLabel)
        container.addSubview(backgroundBar)
        backgroundBar.addSubview(progressBar)
        
        let percentage = CGFloat(amount / total)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 50),
            
            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconLabel.topAnchor.constraint(equalTo: container.topAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: iconLabel.centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: iconLabel.centerYAnchor),
            
            backgroundBar.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            backgroundBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            backgroundBar.heightAnchor.constraint(equalToConstant: 8),
            
            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            progressBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: percentage)
        ])
        
        // Animation
        progressBar.transform = CGAffineTransform(scaleX: 0, y: 1)
        // Anchor point adjustment is tricky with auto layout, so we'll use a simple transform animation
        // However, scaleX:0 scales from the center by default.
        // Better approach for auto layout animation:
        
        // Reset transform
        progressBar.transform = .identity
        
        // We will animate the layout pass or use a temporary zero width constraint?
        // Let's use a simple alpha fade-in + transform for now, keeping it robust.
        
        progressBar.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            progressBar.alpha = 1
        }, completion: nil)
        
        return container
    }
}
