//
//  StorageManager.swift
//  Gamingram
//
//  Created by Mac on 21/06/2021.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage()
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}


extension StorageManager {
    public func uploadUserImages(withData imageData: Data,fileName: String, completion: @escaping (Result<String, StorageError>) -> Void) {
        storage.reference().child("userImages/\(fileName)").putData(imageData, metadata: nil) { metaData, error in
            guard  error == nil else {
                print("Failed to upload image")
                
                completion(.failure(.failedToUpload))
                return
            }
            self.storage.reference().child("userImages/\(fileName)").downloadURL { url, err in
                guard let urlString = url?.absoluteString, err == nil else {
                    completion(.failure(.failedToDownload))
                    return
                }
               
                completion(.success(urlString))
            }
        }
    }
}


enum StorageError: Error {
    case failedToUpload, failedToDownload
}
