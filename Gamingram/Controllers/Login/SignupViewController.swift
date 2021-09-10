//
//  SignupViewController.swift
//  Gamingram
//
//  Created by Mac on 19/05/2021.
//

import UIKit
import JGProgressHUD
import FirebaseFirestore



class SignupViewController: UIViewController {
    
   private var email: UITextField?
   private var username: UITextField?
   private var password: UITextField?
    private var confirmPassword: UITextField?

    let spinner = JGProgressHUD(style: .extraLight)
    
    @IBOutlet weak var signupButton: UIButton!
    let textfield = ["Email", "Username", "Password", "Confirm Password"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
       
    }
    
    private func loadDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        signupButton.titleLabel?.font = UIFont(name: "Cyberpunk", size: 25)
        signupButton.layer.cornerRadius = 5

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }

    @IBAction func signupTapped(_ sender: UIButton) {
        signup(email: email?.text!, password: password?.text!,confirmPassword: confirmPassword?.text!,username: username?.text!)
    }
    
    func signup(email: String?, password: String?, confirmPassword: String? ,username: String?){
        guard let email = email, let password = password, let username = username, let confirmPassword = confirmPassword ,!email.isEmpty, !password.isEmpty, !username.isEmpty,!confirmPassword.isEmpty  else {
            alertUserSignUpError()
            return
        }
        if password.count >= 6 {
            if password == confirmPassword {
                self.spinner.show(in: view)
                AuthManager.shared.userSignup(email: email, password: password, username: username) { result in
                    
                    switch result{
                    case .success(let result):
                        guard let userEmail = result.user.email else {
                            return
                        }
                        let profileImage = UIImage(named: "defaultProfile")
                        
                        guard let profileImageData = profileImage?.pngData() else {
                            return
                        }
                        let profileImageName = "\(userEmail)_profileImage.png"
                        StorageManager.shared.uploadUserImages(withData: profileImageData, fileName: profileImageName) { imgResult in
                            switch imgResult {
                            case .success(let downloadUrl):
                                print(downloadUrl)
                                DatabaseManager.shared.storeImageDownloadURL(email: userEmail, imageURL: downloadUrl, key: "profileImage") { success in
                                    if success {
                                        print("Profile image url stored successfully")
                                        let coverImage = UIImage(named: "Asset 1")
                                        guard let coverImageData = coverImage?.pngData() else {
                                            return
                                        }
                                        let coverImageName = "\(userEmail)_coverImage.png"
                                        StorageManager.shared.uploadUserImages(withData: coverImageData, fileName: coverImageName) { res in
                                            switch res {
                                            case .success(let downloadUrl):
                                                
                                                DatabaseManager.shared.storeImageDownloadURL(email: userEmail, imageURL: downloadUrl, key: "coverImage") { success in
                                                    if success {
                                                        print("Cover Image url stored successfully")
                                                        DatabaseManager.shared.fetchUser(with: userEmail) { result in
                                                            
                                                            switch result {
                                                            case .success(let userData):
                                                                print("thisabs")
                                                                let userName = userData["username"] ?? "Username"
                                                                let privateAccount = userData["private_account"] ?? true
                                                                let coverImageUrl = userData["coverImage"] ?? UIImage(named: "Asset 1")!
                                                                let profileImageUrl = userData["profileImage"] ?? UIImage(named: "defaultProfile")!
                                                                

                                                                let loggedInUser = [
                                                                    "user_email": userEmail,
                                                                    "username": userName,
                                                                    "profileImage": profileImageUrl,
                                                                    "coverImage": coverImageUrl,
                                                                    "private_account": privateAccount
                                                                ] as [String : Any]
                                                                self.spinner.dismiss()
                                                                
                                                                UserDefaults.standard.setValue(loggedInUser, forKey: TemploggedInUser)
                                                        
                                                                
                                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
                                                                self.navigationController?.pushViewController(vc!, animated: true)
                                                               
                                                            case .failure(let error):
                                                                print(error.localizedDescription)
                                                            }
                                                        }
                                                    }else {
                                                        print("failed to store cover Image")
                                                    }
                                                }
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                    else {
                                        print("Failed to store Profile Image")
                                    }
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        
                        //
                        
                      
                        
                        
                    case .failure(.UsernameAlreadyTaken):
                        self.spinner.dismiss()
                        self.alertUserSignUpError(message: "This username is already taken.")
                    case .failure(.ThisEmailAlreadyInUse):
                        self.spinner.dismiss()
                        self.alertUserSignUpError(message: "This email is already taken.")
                    case .failure(.SomethingWentWrong):
                        self.spinner.dismiss()
                        self.alertUserSignUpError(message: "Something went wrong!")
                    }
                }
            }
            else {
            alertUserSignUpError(message: "Password does not match.")
            }
        }
        else {
            alertUserSignUpError(message: "Password must be or equal to 6 characters.")
        }
        
        
    }
    
    func alertUserSignUpError( message:String = "Please enter the required Fields to signup .")  {
        let alert = UIAlertController(title: "Whoops!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: .none))
        present(alert, animated: true)
    }
    

}

extension SignupViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textfield.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignupTableViewCell") as? SignupTableViewCell
        cell?.signupTextField.placeholder = textfield[indexPath.row]
        cell?.signupTextField.delegate = self
        if textfield[indexPath.row] == "Email" {
            cell?.signupTextField.tag = 0
            

        }
        else if textfield[indexPath.row] == "Username" {
            cell?.signupTextField.tag = 1
            

        }
        else if textfield[indexPath.row] == "Password" {
            cell?.signupTextField.tag = 2
            

        }
        else if textfield[indexPath.row] == "Confirm Password" {
            cell?.signupTextField.tag = 3
        }
        return cell!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            textField.keyboardType = .emailAddress
            email = textField
        }
        if textField.tag == 1 {
            textField.keyboardType = .emailAddress
            username = textField
        }

        if textField.tag == 2 {
            textField.isSecureTextEntry = true
            password = textField
            
        }
        if textField.tag == 3 {
            textField.isSecureTextEntry = true
            textField.returnKeyType = .done
            confirmPassword = textField
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
