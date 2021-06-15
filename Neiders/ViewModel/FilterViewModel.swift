//
//  FilterViewModel.swift
//  Neiders
//
//  Created by DIPIKA GHOSH on 11/05/21.
//

import Foundation
import Amplify
import AmplifyPlugins

struct ItemList {
    var name: String
    var items: [String]
    var collapsed: Bool
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
protocol FilterViewModelProtocol:class {
    
    var arrayContentList:[Contents] {get}
    var searchLocString: String? {get set}
    var setIndexOrganization:Set<Int> {get set}
    func callContentList(completion:@escaping (NeidersResult<Any>) -> Void)
    func callFilteredContentList(organizationName:String,contentType:String,language:String,completion:@escaping (NeidersResult<Any>) -> Void)
}

class FilterViewModel:FilterViewModelProtocol {
    var arrayContentList:[Contents] = []
    var arrayOrganization : [String]? = []
    var arrayContentType : [String]? = []
    var searchLocString: String?
    var items: [ItemList] = [
        ItemList(name: "Organisation Name".localized(), items: []),
        ItemList(name: "Content Type".localized(), items: []),
        ItemList(name: "Language".localized(), items: ["English", "French"])
    ]
    
    var setIndexOrganization:Set = Set<Int>()
    
    func callContentList(completion:@escaping (NeidersResult<Any>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        self.arrayContentList.removeAll()
        Amplify.API.query(request: .paginatedList(Contents.self, limit: 1000)) { [self] event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let Contents):
                    let filteredArray = Contents.filter { $0.deleted == false}
                    print(filteredArray.count)
                    self.arrayContentList.append(contentsOf: filteredArray)
                    let uniqueBasedOnName = (self.arrayContentList ).compactMap { $0.organization_name }
                    let uniqueBasedOntype = (self.arrayContentList ).compactMap { $0.content_type }
                    self.arrayOrganization = Array(Set(uniqueBasedOnName))
                    self.arrayContentType = Array(Set(uniqueBasedOntype))
                    print(self.arrayOrganization ?? [])
                    self.items[0].items = Array(Set(uniqueBasedOnName))
                    self.items[1].items = Array(Set(uniqueBasedOntype))
                    print(self.items)
                    
                    print(uniqueBasedOnName)
                    
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
    
    func callFilteredContentList(organizationName:String,contentType:String,language:String,completion:@escaping (NeidersResult<Any>) -> Void){
        if (Reachability.isConnectedToNetwork()){
        
        if organizationName.trimmed.count == 0 && contentType.trimmed.count == 0 && language.trimmed.count == 0 {
            
            completion(.failure(NeidersError.customMessage("Please select at least one option to continue.".localized())))
        }else {
            self.arrayContentList.removeAll()
            
            let content = Contents.keys
            var predicateSingle = content.keyword == ""
            var predicateGroup = QueryPredicateGroup()
            
            if (contentType == "" && language == "") {
                predicateSingle = content.organization_name == organizationName
                
                
            }else if ( organizationName == "" && language == "" ){
                predicateSingle = content.content_type == contentType
            }
            else if ( organizationName == "" && contentType == "" ){
                predicateSingle = content.language == language
            }
            else if (contentType == "" ){
                predicateGroup = content.organization_name == organizationName && content.language == language
            }
            else if (organizationName == "" ){
                predicateGroup = content.content_type == contentType && content.language == language
            }else if (language == "" ){
                predicateGroup = content.organization_name == organizationName && content.content_type == contentType
            }
            else {
                predicateGroup = content.organization_name == organizationName && content.content_type == contentType && content.language == language
            }
            
            if (predicateGroup.predicates.isEmpty) {
                
                Amplify.API.query(request: .paginatedList(Contents.self,where: predicateSingle, limit: 1000)) { event in
                    switch event {
                    case .success(let result):
                        switch result {
                        case .success(let Contents):
                            let filteredArray = Contents.filter { $0.deleted == false}
                            print(filteredArray.count)
                            self.arrayContentList.append(contentsOf: filteredArray)
                            print("Successfully retrieved list  \(Contents.count)")
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
                Amplify.API.query(request: .paginatedList(Contents.self,where: predicateGroup, limit: 1000)) { event in
                    switch event {
                    case .success(let result):
                        switch result {
                        case .success(let Contents):
                            let filteredArray = Contents.filter { $0.deleted == false}
                            print(filteredArray.count)
                            self.arrayContentList.append(contentsOf: filteredArray)
                            print("Successfully retrieved list  \(Contents.count)")
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
            }
            
        }
        }else {
            completion(.failure(NeidersError.customMessage("Please check your internet connection".localized())))
        }
        
        
        
    }
    
    func CallFilterApi() {
        
    }
    
    
    
    
    
}
