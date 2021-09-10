//
//  LoginViewController.swift
//  Created by Mac on 18/05/2021.
//  Gamingram
//
//

import UIKit
import JGProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase


protocol SetFBCredentialsDelegate {
    func setFBCredentials(email: String, pictureUrl: String)
}


class LoginViewController: UIViewController {
    let textFields = ["Username or email", "Password"]
    var iconClick = true
    var imageicon = UIImageView()
    var contentView = UIView()
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var recoverButton: UIButton!
    @IBOutlet weak var loginTableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    private var email: UITextField?
    private var password: UITextField?
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    @IBOutlet weak var orlabel: UILabel!
    
    let spinner = JGProgressHUD(style: .extraLight)

    var userName: String?

    
    var fbcredentialsDelegate: SetFBCredentialsDelegate?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.checkedUserLoggedIn() {
            
            guard let userEmail = Auth.auth().currentUser?.email else {
                return
            }
            DatabaseManager.shared.fetchUser(with: userEmail) { result in
                switch result {
                case .success(let userData):
                    print(userData)
                   
                    let userName = userData["username"] ?? "Username"
                    let privateAccount = userData["private_account"] ?? true
                    let coverImageUrl = userData["coverImage"] ?? UIImage(named: "Asset 1")!
                    let profileImageUrl = userData["profileImage"] ?? UIImage(named: "defaultProfile")!
                    
                    let loggedInUser = [
                        "user_email": userEmail,
                        "username": userName,
                        "coverImage": coverImageUrl,
                        "profileImage": profileImageUrl,
                        "private_account": privateAccount
                    ]
                    print(loggedInUser)
                   
                    UserDefaults.standard.setValue(loggedInUser, forKey: TemploggedInUser)
                    
                   
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            let vc = self.storyboard?.instantiateViewController(identifier: "MainTabBarController")
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else {
     
            navigationController?.popViewController(animated: true)
        }
        
        loadTableView()
        loadButton()
        loadPassHideImage()
        loadGestures()
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func checkedUserLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }else {
            return false
        }
    }
        
  private  func loadTableView()  {
        loginTableView.delegate = self
        loginTableView.dataSource = self
        loginTableView.backgroundColor = .clear
        loginTableView.isScrollEnabled = false
        loginTableView.separatorStyle = .none
        loginTableView.allowsSelection = false
        orLabel.font = UIFont(name: "Cyberpunk", size: 17)
    }
    
   
    
    
    private func loadButton() {
        
        loginButton.layer.cornerRadius = 5
        loginButton.titleLabel?.font = UIFont(name: "Cyberpunk", size: 25)
        
    }

    private func loadPassHideImage(){
        imageicon.image = UIImage(named: "closeeye")
         contentView = UIView()
        contentView.addSubview(imageicon)
        contentView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageicon.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
    }
    
    private func loadGestures(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecongnizer: UITapGestureRecognizer) {
        
        if iconClick {
            iconClick = false
            imageicon.image = UIImage(named: "closeeye")
        }else {
            iconClick = true
            imageicon.image = UIImage(named: "openeye")
        }
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let nav = storyboard?.instantiateViewController(identifier: "SignupViewController") as? SignupViewController
        navigationController?.pushViewController(nav!, animated: true)
    }
    
  
    
    @IBAction func loginTapped(_ sender: UIButton) {
        login(email: email?.text!, password: password?.text!)

    }
    
    
    func login(email: String?, password: String?){
        guard let email = email, let password = password,!email.isEmpty, !password.isEmpty  else {
            alertUserLoginError()
            return
        }
        self.spinner.show(in: view)
        AuthManager.shared.userLogin(email: email, password: password) { result in
            switch result {
            case .failure(.UserDoesNotExist):
                self.spinner.dismiss()
                self.alertUserLoginError(message: "User does not exist. Please signup first.")
            case .success(let result):
                self.spinner.dismiss()
                print("logged in")
               
                guard let userEmail = result.user.email else {
                    return
                }
                
                DatabaseManager.shared.fetchUser(with: userEmail) { result in
                    switch result {
                    case .success(let userData):
                        print(userData)
                       
                        let userName = userData["username"] ?? "Username"
                        let privateAccount = userData["private_account"] ?? true
                        let coverImageUrl = userData["coverImage"] ?? UIImage(named: "Asset 1")!
                        let profileImageUrl = userData["profileImage"] ?? UIImage(named: "defaultProfile")!
                        
                        let loggedInUser = [
                            "user_email": userEmail,
                            "username": userName,
                            "coverImage": coverImageUrl,
                            "profileImage": profileImageUrl,
                            "private_account": privateAccount
                        ]
                        print(loggedInUser)
                       
                        UserDefaults.standard.setValue(loggedInUser, forKey: TemploggedInUser)
                        let vc = self.storyboard?.instantiateViewController(identifier: "MainTabBarController")

                        self.navigationController?.pushViewController(vc!, animated: true)
                       
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
               
                
                
            
            case .failure(.SomethingWentWrong):
                self.spinner.dismiss()
                self.alertUserLoginError(message: "Something went wrong!")
            }
    }
        
        
        
   
    }
    
    func alertUserLoginError( message:String = "Please enter the required Fields to Login.")  {
        let alert = UIAlertController(title: "Whoops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: .none))
        alert.setBackgroundColor(color: UIColor(named: "yellow")!)
        alert.view.tintColor = .black
        

        
    }
    
    
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTableViewCell") as? LoginTableViewCell
        cell?.loginTextFields.placeholder = textFields[indexPath.row]
        cell?.loginTextFields.delegate = self
        if textFields[indexPath.row] == "Password"{
            cell?.loginTextFields.tag = 2
           
        }
        else if textFields[indexPath.row] == "Username or email" {
            cell?.loginTextFields.tag = 1
        }
        
        return cell!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        
        if textField.tag == 2{
            textField.isSecureTextEntry = iconClick
            textField.rightView = contentView
            textField.rightViewMode = .always
            textField.returnKeyType = .done
            password = textField
        }
        else if textField.tag == 1 {
            textField.keyboardType = .emailAddress
            email = textField
        }
        

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        return true
    }
    
}
