//
//  VerifyAPI.swift
//  Phone Verification
//
//  Created by Kelley Robinson on 7/3/18.
//  Copyright © 2018 krobs. All rights reserved.
//

import Foundation

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
