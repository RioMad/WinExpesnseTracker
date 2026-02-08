import UIKit

struct Theme {
    static let backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.14, alpha: 1.00) // Dark background
    static let cardBackgroundColor = UIColor(red: 0.16, green: 0.16, blue: 0.22, alpha: 1.00) // Slightly lighter for cards
    static let accentColor = UIColor(red: 0.44, green: 0.38, blue: 0.94, alpha: 1.00) // Vibrant Purple
    static let secondaryAccent = UIColor(red: 0.96, green: 0.26, blue: 0.56, alpha: 1.00) // Vibrant Pink
    static let textColor = UIColor.white
    static let secondaryTextColor = UIColor.lightGray
    
    // Gradients
    static func applyGradient(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.25, green: 0.25, blue: 0.35, alpha: 1.00).cgColor,
            UIColor(red: 0.10, green: 0.10, blue: 0.14, alpha: 1.00).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        // Remove old gradients if present
        view.layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func primaryGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [accentColor.cgColor, secondaryAccent.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    
    // Layout Constants
    static let cornerRadius: CGFloat = 20.0
    static let padding: CGFloat = 20.0
}
