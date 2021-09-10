//
//  PostViewModel.swift
//  Gamingram
//
//  Created by Mac on 24/06/2021.
//

import Foundation

class PostViewModel: NSObject {
    var posts: [Posts] = [] {
        didSet {
            print("changed")
        }
    }
    
}
