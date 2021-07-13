//
//  ViewModelForgotPassword.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 01/06/21.
//

import Foundation
import Amplify
import AmplifyPlugins
import AWSPluginsCore


enum VerifyError: Error {
    case invalidUrl
    case err(String)
}


protocol WithMessage {
    var message: String { get }
}

enum VerifyResult {
    case success(WithMessage)
    case failure(Error)
}


class DataResult: WithMessage {
    let data: Data
    let message: String
    
    init(data: Data) {
        self.data = data
        self.message = String(describing: data)
    }
}

struct CheckResult: Codable, WithMessage {
    let success: Bool
    let message: String
}


struct VerifyAPI {
    static let path = Bundle.main.path(forResource: "Config", ofType: "plist")
    static let config = NSDictionary(contentsOfFile: path!)
    private static let baseURLString = config!["serverUrl"] as! String
    
    static func createRequest(_ path: String,
                              _ parameters: [String: String],
                              completionHandler: @escaping (_ result: Data) -> VerifyResult) {
        
        let urlPath = "\(baseURLString)/\(path)"
        print(urlPath)
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            if let jsonData = data {
                // if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                //}
                let result = completionHandler(jsonData)
                print(result as Any)
            } else {
                // error, no data returned
            }
        }
        task.resume()
    }
    
    static func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) {
        let parameters = [
            "via": "sms",
            "country_code": countryCode,
            "phone_number": phoneNumber
        ]
        print(parameters)
        createRequest("start", parameters) {
            json in
            do {
                let jsondata = try JSONSerialization.jsonObject(with: json, options: [])
                print(jsondata)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            return .success(DataResult(data: json))
        }
    }
    
    static func validateVerificationCode(_ countryCode: String, _ phoneNumber: String, _ code: String, segue: @escaping (CheckResult) -> Void) {
        
        let parameters = [
            "via": "sms",
            "country_code": countryCode,
            "phone_number": phoneNumber,
            "verification_code": code
        ]
        print(parameters)
        createRequest("check", parameters) {
            jsonData in
            
            let decoder = JSONDecoder()
            do {
                let checked = try decoder.decode(CheckResult.self, from: jsonData)
                DispatchQueue.main.async(execute: {
                    segue(checked)
                })
                return VerifyResult.success(checked)
            } catch {
                return VerifyResult.failure(VerifyError.err("failed to deserialize"))
            }
        }
    }
}

protocol ForgotPasswordViewModelProtocol:class {
    func UPdate(strPassword:String?,strid:String?,completion:@escaping (NeidersResult<Any?>) -> Void)
}
class ForgotPasswordViewModel:ForgotPasswordViewModelProtocol {
    func UPdate(strPassword:String?,strid:String?,completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        print(strPassword)
        guard let newpassword = strPassword, newpassword.trimmed.count > 0 else {
            completion(.failure(NeidersError.customMessage("Password field can not be blank".localized())))
            return
        }
        if !newpassword.isValidPassword() {
            completion(.failure(NeidersError.customMessage("Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())))
        }else {
            guard let Id = strid else {
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                return
            }
            print(Id)
//            Amplify.API.query(request: .get(Users.self, byId: Id))
//            { event in
//                switch event {
//                case .success(let result):
//                    switch result {
//                    case .success(var user):
//                        print("retrieved the user of description \(user as Any)")
//                        //   if (user?.password == self.arrayContainer[0]){
//                        user?.password = strPassword
//                        print( user?.password as Any)
//
//                        let updatedTodo = user
//
//
//                        Amplify.DataStore.save(updatedTodo!) { result in
//                            switch result {
//                            case .success(let savedTodo):
//
//                                print("Updated item: \(savedTodo as Any )")
//                                completion(.success(true))
//                            case .failure(let error):
//                                completion(.success(false))
//                                print("Could not update data with error: \(error)")
//                            }
//                        }
//
//
//                    case .failure(let error):
//                        completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
//                        print("Got failed result with \(error.errorDescription)")
//                    }
//                case .failure(let error):
//                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
//                    print("Got failed event with error \(error)")
//                }
//            }
//        }
            
            Amplify.DataStore.query(Users.self,
                                    where: Users.keys.id.eq("\(Id)")) { result in
                switch(result) {
                case .success(let user):
                    guard user.count == 1, var updateduser = user.first else {
                        print("Did not find exactly one todo, bailing")
                        return
                    }
                    updateduser.password = strPassword
                    Amplify.DataStore.save(updateduser) { result in
                        switch(result) {
                        case .success(let savedTodo):
                            print("Updated item: \(String(describing: savedTodo.password))")
                            completion(.success(true))
                        case .failure(let error):
                            print("Could not update data in DataStore: \(error)")
                            completion(.success(false))
                        }
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    print("Could not query DataStore: \(error)")
                }
            }
        
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
    }
    
    
    
    func UPdatePhoneVerification(isPhonevalid:Bool?,strid:String?,completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()){
////        print(strPassword)
////        guard let newpassword = strPassword, newpassword.trimmed.count > 0 else {
////            completion(.failure(NeidersError.customMessage("Password field can not be blank".localized())))
////            return
////        }
//        if !newpassword.isValidPassword() {
//            completion(.failure(NeidersError.customMessage("Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())))
//        }else {
            guard let Id = strid else {
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                return
            }
            print(Id)
//            Amplify.API.query(request: .get(Users.self, byId: Id))
//            { event in
//                switch event {
//                case .success(let result):
//                    switch result {
//                    case .success(var user):
//                        print("retrieved the user of description \(user as Any)")
//                        //   if (user?.password == self.arrayContainer[0]){
//                        user?.password = strPassword
//                        print( user?.password as Any)
//
//                        let updatedTodo = user
//
//
//                        Amplify.DataStore.save(updatedTodo!) { result in
//                            switch result {
//                            case .success(let savedTodo):
//
//                                print("Updated item: \(savedTodo as Any )")
//                                completion(.success(true))
//                            case .failure(let error):
//                                completion(.success(false))
//                                print("Could not update data with error: \(error)")
//                            }
//                        }
//
//
//                    case .failure(let error):
//                        completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
//                        print("Got failed result with \(error.errorDescription)")
//                    }
//                case .failure(let error):
//                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
//                    print("Got failed event with error \(error)")
//                }
//            }
//        }
            
            Amplify.DataStore.query(Users.self,
                                    where: Users.keys.id.eq("\(Id)")) { result in
                switch(result) {
                case .success(let user):
                    guard user.count == 1, var updateduser = user.first else {
                        print("Did not find exactly one todo, bailing")
                        return
                    }
                    updateduser.is_phone_valid = isPhonevalid
                    Amplify.DataStore.save(updateduser) { result in
                        switch(result) {
                        case .success(let savedTodo):
                            print("Updated item: \(String(describing: savedTodo.password))")
                            completion(.success(true))
                        case .failure(let error):
                            print("Could not update data in DataStore: \(error)")
                            completion(.success(false))
                        }
                    }
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
                    print("Could not query DataStore: \(error)")
                }
            }
        
        //}
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
    }
}



