//
//  AuthManager.swift
//  Gamingram
//
//  Created by Mac on 19/05/2021.
//

import Foundation
import FirebaseAuth



final class AuthManager {
    
    static let shared = AuthManager()
    
    
}

extension AuthManager {
    public func userSignup(email: String, password: String, username: String, completion: @escaping (Result<AuthDataResult, SignupError>) -> Void) {
       
        DatabaseManager.shared.userExists(email: email) { exists in
            if exists {
                completion(.failure(.ThisEmailAlreadyInUse))
            }else {
                DatabaseManager.shared.usernameExists(username: username) { result in
                    switch result {
                    case .success(let documents):
                        if documents.count > 0 {
                            completion(.failure(.UsernameAlreadyTaken))
                        }else {
                            DatabaseManager.shared.insertUser(username: username, email: email) { inserted in
                                if inserted {
                                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                        guard let result = authResult, error == nil else {
                                            completion(.failure(.ThisEmailAlreadyInUse))
                                            print(error!.localizedDescription)
                                            return
                                        }
                                        completion(.success(result))
                                    }
                                }else {
                                    completion(.failure(.SomethingWentWrong))
                                }
                            }
                        }
                    case .failure(let error):
                        print(print(error.localizedDescription))
                        completion(.failure(.SomethingWentWrong))
                    }
                    
                }
            }
        }
        
    }
    public func userLogin(email: String, password: String, completion: @escaping (Result<AuthDataResult,LoginError>) -> Void) {
        if email.contains("@gmail.com") || email.contains("@yahoo.com") || email.contains(".com") {
            DatabaseManager.shared.userExists(email: email) { exists in
                if exists {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        guard let result = authResult, error == nil else {
                            print(error!.localizedDescription)
                            completion(.failure(.UserDoesNotExist))
                            return
                        }
                        completion(.success(result))
                    }
                }else {
                    completion(.failure(.UserDoesNotExist))
                }
            }
        }else {
            DatabaseManager.shared.usernameExists(username: email) { result in
                switch result {
                case .success(let documents):
                    if documents.count > 0 {
                    for document in documents {
                        
                        Auth.auth().signIn(withEmail: document.documentID, password: password) { authResult, error in
                            guard let result = authResult, error == nil else {
    
                                completion(.failure(.UserDoesNotExist))
                                return
                            }
                            
                            completion(.success(result))
                        }
                    }
                    }else {
                        completion(.failure(.UserDoesNotExist))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(.SomethingWentWrong))
                }
            }
            
        }
        
    }
}

enum SignupError: Error {
    case  UsernameAlreadyTaken, ThisEmailAlreadyInUse, SomethingWentWrong
}

enum LoginError: Error {
    case UserDoesNotExist, SomethingWentWrong
}
