//
//  HomeViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 06/05/21.
//

import Foundation
import Amplify
import AmplifyPlugins

protocol HomeViewModelProtocol:class {
    
    var arrayContentList:[Contents] {get}
    var searchLocString: String? {get set}
    func callContentList(completion:@escaping (NeidersResult<Any>) -> Void)
    func callFilteredContentList(completion:@escaping (NeidersResult<Any>) -> Void)
}

class HomeViewModel:HomeViewModelProtocol {
    var arrayContentList:[Contents] = []
    var dataService : [Contents]? = []
    var searchLocString: String?
    
    func callContentList(completion:@escaping (NeidersResult<Any>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        self.arrayContentList.removeAll()
        self.dataService?.removeAll()
        
        
        Amplify.API.query(request: .paginatedList(Contents.self, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let Contents):
                    let filteredArray = Contents.filter { $0.deleted == false}
                    print(filteredArray.count)
                    self.dataService?.append(contentsOf: filteredArray)
                    self.arrayContentList.append(contentsOf: filteredArray)
                    print("Successfully retrieved list  \(Contents.count)")
                    completion(.success(true))
                    
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
    
    func callFilteredContentList(completion:@escaping (NeidersResult<Any>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        self.arrayContentList.removeAll()
        self.dataService?.removeAll()
        let content = Contents.keys
        let predicate = content.organization_name == "" || content.content_type == "" || content.language == ""
        
        Amplify.API.query(request: .paginatedList(Contents.self,where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let Contents):
                    let filteredArray = Contents.filter { $0.deleted == false}
                    print(filteredArray)
                    self.dataService?.append(contentsOf: Contents)
                    self.arrayContentList.append(contentsOf: Contents)
                    // print("Successfully retrieved list  \(Contents[0])")
                    completion(.success(true))
                    
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
    
    
    func getSearchLocation(completion:@escaping (NeidersResult<Any?>) -> Void){
        
        if let searchtext = searchLocString {
            let filteredArray = arrayContentList.filter { (modelObject) -> Bool in
                return modelObject.title?.range(of: searchtext, options: String.CompareOptions.caseInsensitive) != nil || modelObject.subject?.range(of: searchtext, options: String.CompareOptions.caseInsensitive) != nil
            }
            print(filteredArray as Any)
            if (filteredArray as NSArray).count > 0{
                self.arrayContentList = filteredArray
                completion(.success(true))
            }else {
                self.arrayContentList = filteredArray
                completion(.failure(NeidersError.customMessage("Some thing went wrong. Please try again later".localized())))
            }
        }else {
            self.arrayContentList = self.dataService ?? []
        }
    }
    
    
}
