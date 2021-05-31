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
    
   
}
 
class CourseDetailsViewModel:CourseDetailsViewModelProtocol {
    
    var arrayUnit:[ContentUnit] = []
    var arrayStoreUnit:[ContentUnit] = []
    var searchUnitString: String?
    var arrayCourse:[Contents] = []
    
    func callUnitapi(courseId:String?, completion:@escaping (NeidersResult<Any?>) -> Void){
        let content = ContentUnit.keys
        let predict = content.course_id == courseId
    Amplify.API.query(request: .paginatedList(ContentUnit.self, where: predict, limit: 1000)) { event in
         switch event {
         case .success(let result):
             switch result {
             case .success(let Contents):

                     self.arrayUnit.append(contentsOf: Contents)
                self.arrayStoreUnit.append(contentsOf: Contents)
                print("Successfully retrieved list  \(Contents.count)")
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
    }
    
    func getSearchUnit(completion:@escaping (NeidersResult<Any?>) -> Void){
        
        if let searchtext = searchUnitString {
            let filteredArray = arrayUnit.filter { (modelObject) -> Bool in
                return modelObject.title?.range(of: searchtext, options: String.CompareOptions.caseInsensitive) != nil
            }
            print(filteredArray as Any)
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
}
