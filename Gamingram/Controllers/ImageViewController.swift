//
//  ImageViewController.swift
//  Gamingram
//
//  Created by Mac on 06/07/2021.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {
    
    var imageData: String?
    @IBOutlet weak var anyImageView: UIImageView!
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        anyImageView?.sd_setImage(with: URL(string: self.imageData!), placeholderImage: nil, options: .refreshCached) { (image, error, cache, url) in
            if error == nil {
                self.anyImageView.image = image
            }
        }
       
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
