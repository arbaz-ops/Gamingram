//
//  AlertController.swift
//  Gamingram
//
//  Created by Mac on 28/06/2021.
//

import Foundation
import UIKit

extension UIAlertController {
    func setBackgroundColor(color: UIColor)  {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
}
