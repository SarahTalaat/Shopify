//
//  CustomTextField.swift
//  Shopify
//
//  Created by Sara Talat on 01/06/2024.
//
import UIKit

class CustomTextField: UITextField {
    
    
    // Corner radius property
    var cornerRadius: CGFloat = 10
    
    // Property to set the vertical offset of the placeholder
    var placeholderVerticalOffset: CGFloat = 0
    
    // Property to set the left padding
    var leftPadding: CGFloat = 10
    
    // Override this method to change the position of the text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        // Adjust the text rect to include left padding
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }

    // Override this method to change the position of the editing text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        // Adjust the editing rect to include left padding
        return bounds.insetBy(dx: leftPadding, dy: 0)
    }

    // Override this method to change the position of the placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        // Adjust the placeholder rect with the vertical offset and left padding
        let placeholderY = bounds.origin.y + placeholderVerticalOffset
        return CGRect(x: bounds.origin.x + leftPadding, y: placeholderY, width: bounds.size.width - leftPadding, height: bounds.size.height)
    }
    
    // Override this method to draw the placeholder
    override func drawPlaceholder(in rect: CGRect) {
        guard let placeholder = placeholder else { return }
        
        // Calculate the placeholder's frame with a vertical offset and left padding
        let placeholderRect = CGRect(x: rect.origin.x + leftPadding,
                                     y: rect.origin.y + placeholderVerticalOffset,
                                     width: rect.size.width - leftPadding,
                                     height: rect.size.height)
        
        // Draw the placeholder text with grey color
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize),
            .foregroundColor: UIColor.gray,  // Set the placeholder color to grey
            .paragraphStyle: paragraphStyle
        ]
        
        (placeholder as NSString).draw(in: placeholderRect, withAttributes: attributes)
    }
    
    
    // Customize the appearance of the text field
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the corner radius to make the text field rounded
        layer.cornerRadius = cornerRadius
        
        // Optionally, set a border color and width
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        
        // Ensure the text field clips to its bounds
        clipsToBounds = true
    }
    
    static func buttonRoundedCorner(button:UIButton){
        // Make sure the button's corners are rounded
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
    }
    
    static func buttonShadow(button: UIButton){
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
    }
    
    
    static func customTextFieldUI (customTextField : CustomTextField , label: String) {
        // Set the placeholder text
        customTextField.placeholder = label
        // Set the vertical offset for the placeholder
        customTextField.placeholderVerticalOffset = 5 // Adjust this value as needed
        customTextField.leftPadding = 5
        customTextField.layer.cornerRadius = 5
        customTextField.clipsToBounds = true
    }
    
    static func buttonImageColor(button: UIButton){
        // Set the image rendering mode to alwaysTemplate to use tintColor
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .red
    }
}
