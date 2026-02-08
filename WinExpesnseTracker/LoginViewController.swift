import UIKit

class LoginViewController: UIViewController {

    // MARK: - UI Components
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "💰"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expense Tracker"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = Theme.textColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Track your expenses anytime, anywhere."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = Theme.secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mobileTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Mobile Number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.backgroundColor = Theme.cardBackgroundColor
        tf.textColor = Theme.textColor
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let otpTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter 6-digit OTP"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.backgroundColor = Theme.cardBackgroundColor
        tf.textColor = Theme.textColor
        tf.isHidden = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get OTP", for: .normal)
        button.backgroundColor = Theme.accentColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Google Sign-In (Keeping it as an alternative)
    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let googleIconLabel: UILabel = {
        let label = UILabel()
        label.text = "G"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let googleTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in with Google"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var isOtpSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.backgroundColor
        Theme.applyGradient(to: view)
        
        view.addSubview(logoLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(mobileTextField)
        view.addSubview(otpTextField)
        view.addSubview(actionButton)
        view.addSubview(googleSignInButton)
        
        googleSignInButton.addSubview(googleIconLabel)
        googleSignInButton.addSubview(googleTextLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            mobileTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            mobileTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mobileTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            mobileTextField.heightAnchor.constraint(equalToConstant: 50),
            
            otpTextField.topAnchor.constraint(equalTo: mobileTextField.bottomAnchor, constant: 20),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            otpTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            otpTextField.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 30), // Constraint relative to OTP field
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleSignInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            googleSignInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleSignInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleIconLabel.leadingAnchor.constraint(equalTo: googleSignInButton.leadingAnchor, constant: 20),
            googleIconLabel.centerYAnchor.constraint(equalTo: googleSignInButton.centerYAnchor),
            
            googleTextLabel.centerXAnchor.constraint(equalTo: googleSignInButton.centerXAnchor, constant: 10),
            googleTextLabel.centerYAnchor.constraint(equalTo: googleSignInButton.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
    }
    
    @objc private func handleAction() {
        if !isOtpSent {
            // Send OTP Flow
            guard let mobile = mobileTextField.text, !mobile.isEmpty else {
                showAlert(message: "Please enter a valid mobile number.")
                return
            }
            
            // Mock API Call
            isOtpSent = true
            otpTextField.isHidden = false
            mobileTextField.isEnabled = false
            actionButton.setTitle("Verify OTP", for: .normal)
            showAlert(message: "OTP sent to \(mobile). Use 123456.")
            
        } else {
            // Verify OTP Flow
            guard let otp = otpTextField.text, otp == "123456" else {
                showAlert(message: "Invalid OTP. Please enter 123456.")
                return
            }
            
            // Collect Name
            showNameCollectionPopup()
        }
    }
    
    private func showNameCollectionPopup() {
        let alert = UIAlertController(title: "Welcome!", message: "Please enter your name to continue.", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Your Name"
            tf.autocapitalizationType = .words
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                self?.completeLogin(with: name)
            } else {
                self?.showAlert(message: "Name is required.")
            }
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    private func completeLogin(with name: String) {
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(name, forKey: "userName")
        navigateToDashboard()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleGoogleSignIn() {
        // Mock Google Sign-In
        print("Google Sign In Tapped")
        // For Google, we might ask for name if not provided, but for now mock it
        completeLogin(with: "Google User")
    }
    
    private func navigateToDashboard() {
        guard let windowScene = view.window?.windowScene else { return }
        if let sceneDelegate = windowScene.delegate as? SceneDelegate {
            let dashboardVC = DashboardViewController()
            sceneDelegate.setRootViewController(dashboardVC, animated: true)
        }
    }
}
