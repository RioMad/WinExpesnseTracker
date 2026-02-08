import UIKit

class ProfileViewController: UIViewController {

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = Theme.accentColor
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe" // Placeholder
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Theme.textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "john.doe@example.com" // Placeholder
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Theme.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = Theme.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aboutContentLabel: UILabel = {
        let label = UILabel()
        label.text = "WinExpenseTracker is designed to help you manage your finances with ease and style. Track every penny and stay on top of your budget."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = Theme.secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            label.text = "Version \(version) (\(build))"
        } else {
            label.text = "Version 1.0.0"
        }
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = Theme.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadProfileData()
    }
    
    private func loadProfileData() {
        if let name = UserDefaults.standard.string(forKey: "userName") {
            nameLabel.text = name
        }
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(aboutTitleLabel)
        view.addSubview(aboutContentLabel)
        view.addSubview(versionLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40), // More padding for sheet presentation
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            aboutTitleLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            aboutTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            aboutContentLabel.topAnchor.constraint(equalTo: aboutTitleLabel.bottomAnchor, constant: 10),
            aboutContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            aboutContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoutButton.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: -20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    @objc private func didTapLogout() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.setRootViewController(LoginViewController())
            }
        }))
        present(alert, animated: true)
    }
}
