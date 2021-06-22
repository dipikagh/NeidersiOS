//
//  CourseDetailsViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 13/05/21.
//

import Foundation
import Amplify
import AmplifyPlugins

protocol CourseDetailsViewModelProtocol:class {
    var arrayUnit:[ContentUnit]  {get set}
    var arrayCourse:[Contents] {get set}
    func callUnitapi(courseId:String?, completion:@escaping (NeidersResult<Any?>) -> Void)
    func callAdditionalCourse(organizationName:String,id:String, completion:@escaping (NeidersResult<Any>) -> Void)
    
    
}

class CourseDetailsViewModel:CourseDetailsViewModelProtocol {
    
    var arrayUnit:[ContentUnit] = []
    var arrayStoreUnit:[ContentUnit] = []
    var searchUnitString: String?
    var arrayCourse:[Contents] = []
    var arrayAdditionalCourse:[Contents] = []
    
    func callUnitapi(courseId:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        if (Reachability.isConnectedToNetwork()) {
        let content = ContentUnit.keys
        let predict = content.course_id == courseId
        Amplify.API.query(request: .paginatedList(ContentUnit.self, where: predict, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let Contents):
                    let filteredArray = Contents.filter { $0.deleted == false}
                  //  print(filteredArray.count)
                    self.arrayUnit.append(contentsOf: filteredArray)
                    self.arrayStoreUnit.append(contentsOf: filteredArray)
                    print("Successfully retrieved list  \(filteredArray.count)")
                    completion(.success(true))
                    
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later")))
                    
                    print("\(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later")))
                print("\(error.errorDescription)")
                
            }
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
    }
    
    func getSearchUnit(completion:@escaping (NeidersResult<Any?>) -> Void){
        
        if let searchtext = searchUnitString {
            let filteredArray = arrayUnit.filter { (modelObject) -> Bool in
                return modelObject.title?.range(of: searchtext, options: String.CompareOptions.caseInsensitive) != nil
            }
          //  print(filteredArray as Any)
            if (filteredArray as NSArray).count > 0{
                self.arrayUnit = filteredArray
                completion(.success(true))
            }else {
                self.arrayUnit = filteredArray
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later")))
            }
        }else {
            self.arrayUnit = self.arrayStoreUnit
        }
    }
    
    
    func callAdditionalCourse(organizationName:String,id:String, completion:@escaping (NeidersResult<Any>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        print(id)
        self.arrayAdditionalCourse.removeAll()
        let content = Contents.keys
        let predicateSingle = content.organization_name == organizationName
        Amplify.API.query(request: .paginatedList(Contents.self,where: predicateSingle, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let Contents):
                   
                   // self.arrayAdditionalCourse.append(contentsOf: Contents)
                    let filteredArray = Contents.filter { $0.id != id && $0.deleted == false}
                    self.arrayAdditionalCourse.append(contentsOf: filteredArray)
                    print("Successfully retrieved list  \(filteredArray.count)")
                    completion(.success(true))
                    
                case .failure(let error):
                    completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later")))
                    
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later")))
                
                print("Got failed event with error \(error)")
            }
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
    }
}
