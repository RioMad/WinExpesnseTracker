import UIKit

class DashboardViewController: UIViewController, CategoryFilterDelegate {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Dashboard"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        button.setImage(UIImage(systemName: "person.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = Theme.accentColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let totalBalanceCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.cardBackgroundColor
        view.layer.cornerRadius = Theme.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalBalanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Spent"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Theme.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalBalanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "₹0.00"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // Helper to create small stat cards
    private func createStatCard(title: String, amount: String) -> UIView {
        let view = UIView()
        view.backgroundColor = Theme.cardBackgroundColor
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tLabel = UILabel()
        tLabel.text = title
        tLabel.font = UIFont.systemFont(ofSize: 12)
        tLabel.textColor = Theme.secondaryTextColor
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let aLabel = UILabel()
        aLabel.text = amount
        aLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        aLabel.textColor = Theme.textColor
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tLabel)
        view.addSubview(aLabel)
        
        NSLayoutConstraint.activate([
            tLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            aLabel.topAnchor.constraint(equalTo: tLabel.bottomAnchor, constant: 5),
            aLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            aLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        return view
    }
    
    private let categoryFilterView: CategoryFilterView = {
        let view = CategoryFilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expenseBarView: ExpenseBarView = {
        let view = ExpenseBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recentTransactionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Transactions"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transactionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let addExpenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Theme.accentColor
        button.layer.cornerRadius = 30
        button.layer.shadowColor = Theme.accentColor.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor
        
        view.addSubview(scrollView)
        view.addSubview(addExpenseButton)
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
        view.addSubview(addExpenseButton)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(profileButton)
        contentView.addSubview(totalBalanceCard)
        contentView.addSubview(statsStackView)
        contentView.addSubview(categoryFilterView)
        contentView.addSubview(expenseBarView)
        contentView.addSubview(recentTransactionsLabel)
        contentView.addSubview(transactionsStackView)
        
        totalBalanceCard.addSubview(totalBalanceTitleLabel)
        totalBalanceCard.addSubview(totalBalanceAmountLabel)
        
        categoryFilterView.delegate = self
        
        Theme.applyGradient(to: totalBalanceCard)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.padding),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            
            profileButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            
            totalBalanceCard.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Theme.padding),
            totalBalanceCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            totalBalanceCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            totalBalanceCard.heightAnchor.constraint(equalToConstant: 120),
            
            totalBalanceTitleLabel.topAnchor.constraint(equalTo: totalBalanceCard.topAnchor, constant: 20),
            totalBalanceTitleLabel.leadingAnchor.constraint(equalTo: totalBalanceCard.leadingAnchor, constant: 20),
            
            totalBalanceAmountLabel.topAnchor.constraint(equalTo: totalBalanceTitleLabel.bottomAnchor, constant: 8),
            totalBalanceAmountLabel.leadingAnchor.constraint(equalTo: totalBalanceCard.leadingAnchor, constant: 20),
            
            statsStackView.topAnchor.constraint(equalTo: totalBalanceCard.bottomAnchor, constant: 15),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            statsStackView.heightAnchor.constraint(equalToConstant: 60),
            
            categoryFilterView.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 20),
            categoryFilterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryFilterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryFilterView.heightAnchor.constraint(equalToConstant: 40),
             
            expenseBarView.topAnchor.constraint(equalTo: categoryFilterView.bottomAnchor, constant: 20),
            expenseBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            expenseBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            // ExpenseBarView height will be determined by its content stack view
            
            recentTransactionsLabel.topAnchor.constraint(equalTo: expenseBarView.bottomAnchor, constant: 30),
            recentTransactionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            
            transactionsStackView.topAnchor.constraint(equalTo: recentTransactionsLabel.bottomAnchor, constant: 15),
            transactionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.padding),
            transactionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.padding),
            transactionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80), // Padding for FAB
            
            addExpenseButton.widthAnchor.constraint(equalToConstant: 60),
            addExpenseButton.heightAnchor.constraint(equalToConstant: 60),
            addExpenseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addExpenseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        addExpenseButton.addTarget(self, action: #selector(didTapAddExpense), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
    }
    
    @objc private func didTapProfile() {
        let profileVC = ProfileViewController()
        if let sheet = profileVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(profileVC, animated: true)
    }
    
    // MARK: - Actions
    @objc private func didTapAddExpense() {
        let addVC = AddExpenseViewController()
        addVC.onExpenseAdded = { [weak self] in
            self?.loadData()
        }
        if let sheet = addVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(addVC, animated: true)
    }
    
    // MARK: - Data
    private func loadData() {
        let expenses = ExpenseService.shared.loadExpenses()
        let total = expenses.reduce(0) { $0 + $1.amount }
        totalBalanceAmountLabel.text = String(format: "₹%.2f", total)
        
        // Personalization
        if let name = UserDefaults.standard.string(forKey: "userName") {
            headerLabel.text = "Hello, \(name)"
        } else {
            headerLabel.text = "Dashboard"
        }
        
        // Update stats (Mock logic for "This Month" vs "Total" for now, or just split evenly)
        // For real stats, we'd filter by date.
        // Let's just update the stackview
        updateStats(expenses: expenses)
        
        applyFilter(to: expenses)
    }
    
    private var currentCategoryFilter: ExpenseCategory? = nil
    
    func didSelectCategory(_ category: ExpenseCategory?) {
        currentCategoryFilter = category
        loadData() // Reloads everything
    }
    
    private func applyFilter(to expenses: [Expense]) {
        let filteredExpenses: [Expense]
        if let category = currentCategoryFilter {
             filteredExpenses = expenses.filter { $0.category == category }
        } else {
            filteredExpenses = expenses
        }
        
        expenseBarView.configure(with: filteredExpenses)
        updateTransactionsList(expenses: filteredExpenses)
    }
    
    private func updateStats(expenses: [Expense]) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Mock stats for "Daily Average" and "Max Purchase"
        let count = Double(expenses.count)
        let total = expenses.reduce(0) { $0 + $1.amount }
        let avg = count > 0 ? total / count : 0
        let max = expenses.map { $0.amount }.max() ?? 0
        
        let avgView = createStatCard(title: "Avg. Expense", amount: String(format: "₹%.0f", avg))
        let maxView = createStatCard(title: "Max Expense", amount: String(format: "₹%.0f", max))
        
        statsStackView.addArrangedSubview(avgView)
        statsStackView.addArrangedSubview(maxView)
    }
    
    private func updateTransactionsList(expenses: [Expense]) {
        transactionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let recent = expenses.prefix(5)
        
        for expense in recent {
            let row = createTransactionRow(expense: expense)
            transactionsStackView.addArrangedSubview(row)
        }
    }
    
    private func createTransactionRow(expense: Expense) -> UIView {
        let container = TransactionRowView()
        container.backgroundColor = Theme.cardBackgroundColor
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Interaction
        container.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTransaction(_:)))
        container.addGestureRecognizer(tap)
        
        // Tag with ID using accessibilityIdentifier for simplicity, or we check array index
        // A better way is to subclass UIButton or use a custom view with a closure, but let's use the valid tag approach for standard views
        // Since we rebuild the list, we can just assign the expense to the view layer or match by index?
        // Let's create a custom 'TransactionRow' if needed, OR just match by index since this method is called in a loop.
        // Wait, didTapTransaction needs to know WHICH expense.
        // We will subclass UIView for the row to hold the expense.
        
        (container as? TransactionRowView)?.expense = expense
        
        let iconLabel = UILabel()
        iconLabel.text = expense.category.icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = expense.title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Theme.textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: expense.date)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = Theme.secondaryTextColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = String(format: "-₹%.2f", expense.amount)
        amountLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        amountLabel.textColor = Theme.textColor
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconLabel)
        container.addSubview(titleLabel)
        container.addSubview(dateLabel)
        container.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
            iconLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            amountLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            amountLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    @objc private func didTapTransaction(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view as? TransactionRowView, let expense = row.expense else { return }
        
        let alert = UIAlertController(title: "Manage Transaction", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let editVC = AddExpenseViewController()
            editVC.expenseToEdit = expense
            editVC.onExpenseAdded = { [weak self] in
                self?.loadData()
            }
            if let sheet = editVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            self.present(editVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            ExpenseService.shared.deleteExpense(id: expense.id)
            self.loadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

class TransactionRowView: UIView {
    var expense: Expense?
}
