//
//  loginViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 06/05/21.
//

import Foundation

import Amplify
import AmplifyPlugins



protocol loginViewModelProtocol:class {
    
    func callSigninApi(email:String?,password:String?, completion:@escaping (NeidersResult<Any?>) -> Void)
    func callSignup(fullName:String?,email:String?, completion:@escaping (NeidersResult<Any?>) -> Void)
    func callForgotApi(email:String?, completion:@escaping (NeidersResult<Any?>) -> Void)
}
class loginViewModel: loginViewModelProtocol {
    
    // MARK: - LoginApi
    func callSigninApi(email:String?,password:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()) {
        
        guard let email = email, email.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("please enter your email address".localized())))
            return
        }
        guard email.isValidEmail() else {
            completion(.failure(NeidersError.customMessage("please enter your proper email address".localized())))
            return
        }
        guard let password = password, password.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("please enter your password".localized())))
            return
        }
       
        let user = Users.keys
        let predicate = user.email == email && user.password == password
        Amplify.API.query(request: .paginatedList(Users.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully retrieved list of todos: \(user.count)")
                    if (user.count == 1) {
                        UserDefaults.standard.setValue(user[0].email, forKey: "EMAIL")
                        UserDefaults.standard.setValue(user[0].full_name, forKey: "NAME")
                        UserDefaults.standard.setValue(user[0].id, forKey: "ID")
                        UserDefaults.standard.setValue(user[0].login_type, forKey: "LOGINTYPE")
                        
                        completion(.success(true))
                    }else if (user.count == 0) {
                        completion(.failure(NeidersError.customMessage("Wrong credential! \nPlease check your Email or Password".localized())))
                    }else {
                        completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                
                print("Got failed event with error \(error)")
            }
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
        
        
    }
    
    // MARK:- Signup Api For FBLOGIN
    func callSingleSignup(fullName:String?,email:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()) {
        let user = Users(full_name: fullName, email: email)
        // 3
        _ = Amplify.API.mutate(request: .create(user)) { event in
            switch event {
            // 4
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                print("Got failed result with \(error.errorDescription)")
            case .success(let result):
                switch result {
                
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    print("Got failed result with \(error.errorDescription)")
                case .success(let user):
                    completion(.success(true))
                    print("Successfully created todo: \(user)")
                    UserDefaults.standard.setValue(user.email, forKey: "EMAIL")
                    UserDefaults.standard.setValue(user.full_name, forKey: "NAME")
                    UserDefaults.standard.setValue(user.id, forKey: "ID")
                    
                    
                // 5
                
                }
            }
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
    }
    
    // MARK:- Signup Api For FBLOGIN Checking If User Exist
    func callSignup(fullName:String?,email:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        
     
        
        let user = Users.keys
        let predicate = user.email == email
        Amplify.API.query(request: .paginatedList(Users.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully retrieved list of todos: \(user.count)")
                    if (user.count >= 1) {
                        //                        completion(.failure(NeidersError.customMessage("This user is already exists. Please try with another information")))
                        self.callfbSigninApi( email: email,  completion: {(result) in
                            switch result {
                            case .success(let value):
                                if let success =  value as? Bool, success == true {
                                    completion(.success(true))
                                }
                            case .failure(let error):
                                completion(.failure(NeidersError.customMessage(error.localizedDescription)))
                                
                                
                            }
                        })
                    }else if (user.count == 0){
                        completion(.failure(NeidersError.customMessage("Please signin to continue".localized())))
                    }
                    else {
                        self.callSingleSignup(fullName: fullName, email: email,  completion: {(result) in
                            switch result {
                            case .success(let value):
                                if let success =  value as? Bool, success == true {
                                    completion(.success(true))
                                }
                            case .failure(let error):
                                completion(.failure(NeidersError.customMessage(error.localizedDescription)))
                                
                                
                            }
                        })
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                
                print("Got failed event with error \(error)")
            }
        }
        
        
        
        
    }
    
    // If already signup with fb then login
    func callfbSigninApi(email:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        
        let user = Users.keys
        let predicate = user.email == email
        Amplify.API.query(request: .paginatedList(Users.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully retrieved list of todos: \(user[0])")
                    if (user.count == 1) {
                        if let email = user[0].email {
                            UserDefaults.standard.setValue(email, forKey: "EMAIL")
                        }
                        if let name = user[0].full_name {
                            UserDefaults.standard.setValue(name, forKey: "NAME")
                        }
                        if  user[0].id != "" {
                            UserDefaults.standard.setValue(user[0].id, forKey: "ID")
                        }
                        completion(.success(true))
                    }else if (user.count == 0) {
                        completion(.failure(NeidersError.customMessage("Wrong credential! \nPlease check your Email or Password".localized())))
                    }else {
                        completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                
                print("Got failed event with error \(error)")
            }
        }
        
    }
    
    //MARK:- API For Forgot PAssword, First Fetch data for perticular usee
    func callForgotApi(email:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        
        if (Reachability.isConnectedToNetwork()) {
        guard let email = email, email.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("please enter your email address".localized())))
            return
        }
        guard email.isValidEmail() else {
            completion(.failure(NeidersError.customMessage("please enter your proper email address".localized())))
            return
        }
        
        let user = Users.keys
        let predicate = user.email == email
        Amplify.API.query(request: .paginatedList(Users.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully retrieved list of todos: \(user.count)")
                    if (user.count == 1) {
                        
                        if let success = user[0] as? Users {
                            completion(.success(success))
                        }
                        
                    }else if (user.count == 0) {
                        completion(.failure(NeidersError.customMessage("Email does not exit".localized())))
                    }else {
                        completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                
                print("Got failed event with error \(error)")
            }
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
        
        
    }
    
    
}
