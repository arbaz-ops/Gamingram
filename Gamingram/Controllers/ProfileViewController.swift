//
//  ProfileViewController.swift
//  Gamingram
//
//  Created by Mac on 17/06/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!

    var userName: String?
    var userEmail: String?
    var profileImageUrl: String?
    var coverImageUrl: String?
    var privateAccount: Bool?
     
    @IBOutlet weak var usernamLabel: UILabel!
    let imagePicker = UIImagePickerController()
    let spinner = JGProgressHUD(style: .extraLight)

    var coverImageSelected: Bool?
    var profileImageSelected: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadTableView()
        loadNib()
        loadLoggedInUserData()
        self.imagePicker.delegate = self

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.spinner.show(in: view,animated: true)
        DispatchQueue.main.async {
            self.loadLoggedInUserData()
            self.profileTableView.reloadData()
            self.spinner.dismiss()
        }
    }
    
    
    //MARK: - Load Nibs and views
    
   private func loadNib()  {
        let headerNib = UINib(nibName: "HeaderTableViewCell", bundle: nil)
        profileTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderTableViewCell")
        let postNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        profileTableView.register(postNib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    
    
    
   private func loadTableView()  {
        profileTableView.backgroundColor = UIColor(named: "softblack")
        profileTableView.separatorStyle = .none
        profileTableView.showsVerticalScrollIndicator = false
        profileTableView.showsHorizontalScrollIndicator = false
        profileTableView.tableHeaderView?.isUserInteractionEnabled = false
        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
    
    //MARK: - loadLoggedInUserData

    func loadLoggedInUserData() {
        guard let userData = UserDefaults.standard.dictionary(forKey: TemploggedInUser) else {
            return
        }
        self.usernamLabel.text = userData[username] as? String
        self.userName = userData[username] as? String
        self.userEmail = userData[user_email] as? String
        self.profileImageUrl = userData[profileImage] as? String
        self.coverImageUrl = userData[coverImage] as? String
        
        self.profileTableView.reloadData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            self.navigationController?.popViewController(animated: true)
        }catch let error {
            print(error.localizedDescription)
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell
        guard let cellHeight = cell?.frame.height else {
            return 0
        }
        print(cell?.postDescription.text?.count)
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell
        cell?.profileImageView.sd_setImage(with: URL(string: self.profileImageUrl!), placeholderImage: UIImage(named: "defaultProfile"), options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, error, cache, url) in
            if error == nil {
                
                cell!.profileImageView.image = image
                
            }
          })
        cell?.userName.text = self.userName
        cell?.location.text = "Rawalpindi"
        cell?.postDescription.text = "sjakdhsjkahdjshakjdhsjahksdjksahkdkshkashdskahdjhsdkjhakjhskjdhskjahjshakncsnjknasnkjdnsjnasdnkanjkdsnjankdsnjkanjkdnsjknjksnakjndjksandjksnjkansjndajsnjkdnaknskjnajdnskanjdnakjnsjkankdsjnkdnsakjndkjsnakjnsajnsjkandaksnjdkankjdnsjkandjksankjdnsjkandjsanjdksnadnsiuheuwqeyrwueyiridhscindsinfdsmkofdksmlsmkmdksldmlcmldmslcmsdlkmcldmslmcdklsmklcdml"
        cell?.postImageView.image = UIImage(named: "defaultProfile")

        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell
        headerCell?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let profileImagesGesture = UITapGestureRecognizer(target: self, action: #selector(showProfileImageOptions))
        headerCell?.profileImageView.addGestureRecognizer(profileImagesGesture)
        let coverImagesGesture = UITapGestureRecognizer(target: self, action: #selector(showCoverImageOptions))
        headerCell?.coverImageView.addGestureRecognizer(coverImagesGesture)
        
        guard let userData = UserDefaults.standard.dictionary(forKey: TemploggedInUser) else {
            return nil
        }
        
        let username = userData["username"] as? String
        
        headerCell?.usernameLabel.text = username
        DispatchQueue.main.async {
            
        headerCell!.profileImageView.sd_setImage(with: URL(string: self.profileImageUrl!), placeholderImage: UIImage(named: "defaultProfile"), options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, error, cache, url) in
            if error == nil {
                
                headerCell!.profileImageView.image = image
                
            }
          })
        headerCell!.coverImageView.sd_setImage(with: URL(string: self.coverImageUrl!), placeholderImage: UIImage(named: "defaultProfile"), options: SDWebImageOptions.refreshCached, progress: nil, completed: { (image, error, cache, url) in
            if error == nil {
                
                headerCell?.coverImageView.contentMode = .scaleAspectFill
                headerCell!.coverImageView.image = image
                
            }
          })
        }
        return headerCell!
    }
    
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderTableViewCell") as? HeaderTableViewCell
        return headerCell!.frame.height
    }
    
    
    //MARK: - @objc func showProfileImageOptions()
    
    @objc func showProfileImageOptions() {
        let alert = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)
        
      
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            print("camera tapped")
        }
        alert.addAction(cameraAction)
        
        let selectAction = UIAlertAction(title: "Select From Gallery", style: .default) { _ in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.profileImageSelected = true
            self.coverImageSelected = false

            self.present(self.imagePicker, animated: true)
        }
        
        alert.addAction(selectAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.profileImageSelected = false
        }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        alert.setBackgroundColor(color: .darkGray)
        alert.view.tintColor = UIColor(named: "yellow")
        self.present(alert, animated: true)
        
    }
    
    //MARK: - @objc func showCoverImageOptions()
    
    @objc func showCoverImageOptions() {
        let alert = UIAlertController(title: "Choose", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            print("camera tapped")
        }))
        alert.addAction(UIAlertAction(title: "Select From Gallery", style: .default, handler: { _ in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.coverImageSelected = true
            self.profileImageSelected = false
            
            self.present(self.imagePicker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "View Profile Picture", style: .default, handler: { _ in
            
        }))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.coverImageSelected = false
        }
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        
       
        alert.setBackgroundColor(color: .darkGray)
        alert.view.tintColor = UIColor(named: "yellow")
        self.present(alert, animated: true)
        
    }
    
    //MARK: - function imagePickerController
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let email = self.userEmail else {
                return
            }
     
            if self.coverImageSelected! {
                let fileName = "\(email)_coverImage.png"
                guard let imageData = pickedImage.pngData() else {
                    return
                }
                self.spinner.show(in: self.view)
                StorageManager.shared.uploadUserImages(withData: imageData, fileName: fileName) { result in
                    
                    switch result {
                    case .success(let downloadUrl):
                        print(downloadUrl)
                        DatabaseManager.shared.storeImageDownloadURL(email: email, imageURL: downloadUrl, key: "coverImage") { success in
                            if success {
                                print("download image url is saved")
                                guard var userData = UserDefaults.standard.dictionary(forKey: TemploggedInUser) else {
                                    return
                                }
                                userData.updateValue(downloadUrl, forKey: "coverImage")
                                UserDefaults.standard.synchronize()

                               
                                self.coverImageUrl = downloadUrl
                                self.profileTableView.reloadData()
                                self.spinner.dismiss()
                                
                            }else {
                                print("could not save download url")
                            }
                        }
                       
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.spinner.dismiss()

                    }
                }
                
                
            } else if self.profileImageSelected! {
                let fileName = "\(email)_profileImage.png"
                guard let imageData = pickedImage.pngData() else {
                    return
                }
                self.spinner.show(in: self.view)
                StorageManager.shared.uploadUserImages(withData: imageData, fileName: fileName) { result in
                    switch result {
                    case .success(let downloadUrl):
                        print(downloadUrl)
                        DatabaseManager.shared.storeImageDownloadURL(email: email, imageURL: downloadUrl, key: "profileImage") { success in
                            if success {
                                print("download image url is saved")
                                guard var userData = UserDefaults.standard.dictionary(forKey: TemploggedInUser) else {
                                    return
                                }
                                userData.updateValue(downloadUrl, forKey: "profileImage")
                                
                                UserDefaults.standard.synchronize()
                                self.profileImageUrl = downloadUrl
                                self.profileTableView.reloadData()
                                self.spinner.dismiss()
                                
                            }else {
                                print("could not save download url")
                            }
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.spinner.dismiss()

                    }
                }
            }
            
            
        }

        dismiss(animated: true, completion: nil)
    }
    
    
    
}


