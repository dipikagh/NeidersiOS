//
//  ModelConfigurable.swift
//  TCSTransit
//
//  Created by Palash Das, Appsbee LLC on 27/10/20.
//  Copyright © 2020 Intelebee. All rights reserved.
//

import Foundation

import Foundation

protocol ModelConfigurable {
    
    associatedtype ModelType
    
    var model: ModelType? { get }
    
    func configureFrom(_ model: ModelType?)
}
