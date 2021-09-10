//
//  HeaderTableViewCell.swift
//  Gamingram
//
//  Created by Mac on 23/06/2021.
//

import UIKit
import SDWebImage

class HeaderTableViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
            super.awakeFromNib()
    
          loadLoggedInUserData()
        coverImageView.layer.borderWidth = 2
        coverImageView.layer.borderColor = UIColor.white.cgColor
        coverImageView.layer.cornerRadius = 10
        coverImageView.isUserInteractionEnabled = true
        coverImageView.isHighlighted = true
        
//        profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.backgroundColor = .darkGray
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.isHighlighted = true
       
        
        }
    
    
    
   
    func loadLoggedInUserData() {
        guard let userData = UserDefaults.standard.dictionary(forKey: TemploggedInUser) else {
            return
        }
       
        usernameLabel.text = userData[username] as? String
        
       
        
        
    }
   

    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    
    

}
