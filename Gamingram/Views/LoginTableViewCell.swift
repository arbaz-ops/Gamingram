//
//  LoginTableViewCell.swift
//  Gamingram
//
//  Created by Mac on 18/05/2021.
//

import UIKit

class LoginTableViewCell: UITableViewCell {

    @IBOutlet weak var loginTextFields: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        let whitePlaceholderText = NSAttributedString(string: "My Placeholder",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        loginTextFields.attributedPlaceholder = whitePlaceholderText
        loginTextFields.textColor = UIColor(named: "yellow")
        loginTextFields.autocorrectionType = .no
        loginTextFields.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
