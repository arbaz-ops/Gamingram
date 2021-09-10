//
//  SignupTableViewCell.swift
//  Gamingram
//
//  Created by Mac on 19/05/2021.
//

import UIKit

class SignupTableViewCell: UITableViewCell {

    @IBOutlet weak var signupTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        let whitePlaceholderText = NSAttributedString(string: "My Placeholder",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        signupTextField.attributedPlaceholder = whitePlaceholderText
        signupTextField.textColor = UIColor(named: "yellow")
        signupTextField.autocorrectionType = .no
        signupTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
