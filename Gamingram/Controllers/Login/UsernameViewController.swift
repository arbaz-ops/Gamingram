//
//  UsernameViewController.swift
//  Gamingram
//
//  Created by Mac on 25/05/2021.
//

import UIKit



class UsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    var email: String?
    var pictureUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterButton.layer.cornerRadius = 5
        enterButton.titleLabel?.font = UIFont(name: "Cyberpunk", size: 25)
        usernameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        let whitePlaceholderText = NSAttributedString(string: "Username",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.9)])
        usernameTextField.attributedPlaceholder = whitePlaceholderText
        // Do any additional setup after loading the view.
        usernameTextField.textColor = UIColor(named: "yellow")
        let lvc = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController
        lvc?.fbcredentialsDelegate = self

    }
    
    @IBAction func enterTapped(_ sender: UIButton) {
            
        
    }
    
    

}

extension UsernameViewController: SetFBCredentialsDelegate {
    func setFBCredentials(email: String, pictureUrl: String) {
        
        self.email = email
        self.pictureUrl = pictureUrl
        
    }
    
    
}
