//
//  SignUPViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 05/05/21.
//

import Foundation
import Amplify
import AmplifyPlugins

protocol SignupViewModelProtocol:class {
    var arrayContainer:[String] {get set}
    func callSignup(fullName:String?,email:String?,phone:String?,password:String?,loginType:String?, completion:@escaping (NeidersResult<Any?>) -> Void)
}
class SignupViewModel: SignupViewModelProtocol {
    var arrayContainer = ["","","","","Student"]
    var arrayInputField = [["Full Name".localized(),"user_icon"], ["Email Id".localized(),"email_icon"],["Password".localized(),"password_icon"],["Phone Number".localized(),"mobile_icon"]]
    //Checking If User Exist
    func callSignup(fullName:String?,email:String?,phone:String?,password:String?,loginType:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        guard let fullName = fullName, fullName.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("Please enter your full name".localized())))
            return
        }
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
        guard password.isValidPassword() else {
            completion(.failure(NeidersError.customMessage("Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())))
            return
        }
        guard let phoneNumber = phone, phoneNumber.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("please enter your Phone number".localized())))
            return
        }
        guard phoneNumber.isValidPhoneNumber() else {
            completion(.failure(NeidersError.customMessage("Please enter proper phone number".localized())))
            return
        }
        guard let loginType = loginType, loginType.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("please select user type".localized())))
            return
        }
        
        let user = Users.keys
        let predicate = user.email == email || user.phone == phoneNumber
        Amplify.API.query(request: .paginatedList(Users.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully retrieved list of todos: \(user.count)")
                    if (user.count >= 1) {
                        completion(.failure(NeidersError.customMessage("This user is already exists. Please try with another information".localized())))
                    }else {
                        self.callSingleSignup(fullName: fullName, email: email, phone: phoneNumber, password: password, loginType: loginType, completion: {(result) in
                            switch result {
                            case .success(let value):
                                if let success =  value as? Users {
                                    completion(.success(success))
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
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
        
        
    }
    
    
    func callSingleSignup(fullName:String?,email:String?,phone:String?,password:String?,loginType:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        let user = Users(login_type:loginType, full_name: fullName, email: email,phone: phone, password: password)
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
                    completion(.success(user))
                    print("Successfully created todo: \(user)")
                // 5
                
                }
            }
        }
    }
    
}
