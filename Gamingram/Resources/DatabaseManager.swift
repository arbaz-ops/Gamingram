//
//  DatabaseManager.swift
//  Gamingram
//
//  Created by Mac on 20/05/2021.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let userDB = Firestore.firestore().collection("users")
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

extension DatabaseManager {
    public func insertUser(username: String, email: String, completion: @escaping (Bool) -> Void) {
        
        userDB.document(email).setData([
            "username": username,
            "private_account": false,
            
        ]) { error in
            guard error == nil else {
                completion(false)
                print(error!.localizedDescription)
                return
            }
            
            completion(true)
            self.userDB.document(email).collection("\(email)_followers").document("followers").setData([
                "followers": []
            ])
            self.userDB.document(email).collection("\(email)_following").document("following").setData([
                "following": []
            ])
            self.userDB.document(email).collection("\(email)_posts").document("posts").setData([
                "posts": []
            ])
        }
        
    }
    
    public func userExists(email: String, completion: @escaping (Bool) -> Void) {
        userDB.document(email).getDocument { querySnap, error in
            guard let document = querySnap, error == nil else {
                completion(false)
                print(error!.localizedDescription)
                return
            }
            if document.exists {
                completion(true)
            }else {
                completion(false)
            }
            
        }
    }
    public func usernameExists(username: String, completion: @escaping (Result<[QueryDocumentSnapshot], Error>) -> Void) {
        userDB.whereField("username", isEqualTo: username).getDocuments { querySnap, error in
            guard let documents = querySnap?.documents, error == nil else {
                print(error!.localizedDescription)
                completion(.failure(error!))
                return
            }
            completion(.success(documents))
        }
    }
    
    public func fetchUser(with email: String, completion: @escaping (Result<[String: Any], DatabaseError>) -> Void)
    {
        userDB.document(email).getDocument { querySnap, error in
            guard let document = querySnap, error == nil else {
                print(error!.localizedDescription)
                completion(.failure(.NotFound))
                return
            }
            guard let data = document.data() else {
                return
            }
           
            completion(.success(data))
        }
        
    }
    
    public func storeImageDownloadURL(email: String,imageURL: String,key: String ,completion: @escaping (Bool) -> Void){
        userDB.document(email).setData(["\(key)": imageURL], merge: true) { error in
            
            guard error == nil else {
                print(error?.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
   
}

enum DatabaseError: Error {
    case NotFound
}
