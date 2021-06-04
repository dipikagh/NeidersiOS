//
//  EditPasswordViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 28/05/21.
//

import Foundation
import Amplify
import AmplifyPlugins
import AWSPluginsCore


protocol EditPasswordViewModelProtocol:class {
    var arrayContainer:[String] {get set}
    func UPdate(completion:@escaping (NeidersResult<Any?>) -> Void)
  
}
class EditPasswordViewModel: EditPasswordViewModelProtocol {
    var arrayContainer: [String] = ["","",""]
    
    func UPdate(completion:@escaping (NeidersResult<Any?>) -> Void){
        let Id = UserDefaults.standard.value(forKey: "ID") as? String ?? ""
        print(Id)
        if arrayContainer[0] == "" {
            completion(.failure(NeidersError.customMessage("Old Password field can not be blank".localized())))
        }else if !arrayContainer[0].isValidPassword() {
            completion(.failure(NeidersError.customMessage("Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())))
        }
        else if arrayContainer[1] == ""{
            completion(.failure(NeidersError.customMessage("New Password field can not be blank".localized())))
            
        }else if !arrayContainer[1].isValidPassword() {
            completion(.failure(NeidersError.customMessage("Password should be of min 8 characters including upper string,lower string,alphanumeric and special symbols".localized())))
        }
        else if arrayContainer[2] == "" {
            completion(.failure(NeidersError.customMessage("Confirm New Password field can not be blank".localized())))
        }
        else if arrayContainer[2] != arrayContainer[1] {
            completion(.failure(NeidersError.customMessage("New password and confirm new password field does not matched".localized())))
        }
        else {
        Amplify.API.query(request: .get(Users.self, byId: Id))
        { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(var user):
                    print("retrieved the user of description \(user as Any)")
                    if (user?.password == self.arrayContainer[0]){
                        user?.password = self.arrayContainer[1]
                        print( user?.password as Any)
                  
                        let updatedTodo = user
                       
                      
                        
                          Amplify.DataStore.save(updatedTodo!) { result in
                          switch result {
                          case .success(let savedTodo):
                            
                            print("Updated item: \(savedTodo as Any )")
                              completion(.success(true))
                          case .failure(let error):
                              completion(.success(false))
                            print("Could not update data with error: \(error)")
                          }
                        }

                    }else {
                        completion(.failure(NeidersError.customMessage("Old Passsword is incorrect".localized())))
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
        

        
        
    }
    
    
    func toggleComplete(_ todo: Users,completion:@escaping (NeidersResult<Any?>) -> Void) {
        let updatedTodo = todo
       
      
      Amplify.DataStore.save(updatedTodo) { result in
        switch result {
        case .success(let savedTodo):
            completion(.success(true))
          print("Updated item: \(savedTodo as Any )")
        case .failure(let error):
            completion(.success(false))
          print("Could not update data with error: \(error)")
        }
      }
 }
}
