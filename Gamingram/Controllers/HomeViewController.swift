//
//  HomeViewController.swift
//  Gamingram
//
//  Created by Mac on 09/06/2021.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var gamingramLabel: UILabel!
    @IBOutlet weak var homeDividerView: UIView!
    @IBOutlet weak var homeTopView: UIView!
    @IBOutlet weak var postsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        postsTableView.backgroundColor = .black
        gamingramLabel.font = UIFont(name: "Cyberpunk", size: 30)
        
        if checkedUserLoggedIn() {
           
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    private func checkedUserLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }else {
            return false
        }
    }
    
   

}
