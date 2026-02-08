import UIKit

protocol CategoryFilterDelegate: AnyObject {
    func didSelectCategory(_ category: ExpenseCategory?)
}

class CategoryFilterView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: CategoryFilterDelegate?
    
    private let categories: [ExpenseCategory?] = [nil] + ExpenseCategory.allCases.map { $0 }
    private var selectedCategory: ExpenseCategory? = nil
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(FilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let category = categories[indexPath.item]
        let isSelected = category == selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        collectionView.reloadData()
        delegate?.didSelectCategory(selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let text = category?.rawValue ?? "All"
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 30
        return CGSize(width: width, height: 36)
    }
}

class FilterCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 18
        contentView.layer.borderWidth = 1
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: ExpenseCategory?, isSelected: Bool) {
        if let category = category {
            label.text = category.rawValue
        } else {
            label.text = "All"
        }
        
        if isSelected {
            contentView.backgroundColor = Theme.accentColor
            contentView.layer.borderColor = Theme.accentColor.cgColor
            label.textColor = .white
        } else {
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = Theme.secondaryTextColor.cgColor
            label.textColor = Theme.secondaryTextColor
        }
    }
}
