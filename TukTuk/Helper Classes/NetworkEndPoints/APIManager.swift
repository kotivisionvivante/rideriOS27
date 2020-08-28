//
//  APIManager.swift
//  Jobs
//
//  Created by KAMAL BALKARAN on 05/05/19.
//  Copyright © 2019 Raman Kant. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    static let alamofireShared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 600.0
        configuration.timeoutIntervalForRequest = 600.0
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()

    private init() {}
    
    func request(url:String,method:HTTPMethod,parameters:Parameters?=nil,tryAgain:Bool=true,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        print(url)
        print(parameters as Any)
     
        let strToken = GlobalUserDetail?.data?.access_token ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer\(strToken)"
        ]
        print("token: ", strToken)
        URLCache.shared.removeAllCachedResponses()
        
        APIManager.alamofireShared.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headers).responseJSON { (response) in
            print(response.result.value as Any)
            completionCallback(response as AnyObject)
            
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    successCallback(responseJSON as AnyObject)
                case .failure(let error):
                    failureCallback(error.localizedDescription)
                }
            } else {
                
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
                
            }
        }
    }
    
    func requestWithoutHeader(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        print(url)
        print(parameters as Any)
        let headers: HTTPHeaders = [:]
        URLCache.shared.removeAllCachedResponses()

        APIManager.alamofireShared.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headers).responseJSON { (response) in
            print(response.result.value as Any)
            completionCallback(response as AnyObject)
            
            if self.isResponseValid(response: response) {
                switch response.result {
                case .success(let responseJSON):
                    successCallback(responseJSON as AnyObject)
                case .failure(let error):
                    failureCallback(error.localizedDescription)
                }
            } else {
                let error =  self.getErrorForResponse(response: response)
                failureCallback(error)
            }
        }
    }
    
    func requestWithFlag(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (DataResponse<Any>) -> Void) {
        
//        let strToken = UserDefaults.getxAuthToken()
        let headers: HTTPHeaders = [
            "Connection": "Keep-Alive",
            "X-Auth-Token": "strToken"
        ]
        
        URLCache.shared.removeAllCachedResponses()
        
        APIManager.alamofireShared.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent, headers: headers).responseJSON { (response) in
            completionCallback(response)
        }
    }
    
    func upload(url:String,method:HTTPMethod,parameters:Parameters?=nil,completionCallback:@escaping (AnyObject) -> Void ,success successCallback: @escaping (AnyObject) -> Void ,failure failureCallback: @escaping (String?) -> Void) {
        
//        let strToken = UserDefaults.getxAuthToken()
        
        let headers: HTTPHeaders = [
            //   "Content-Type": "application/json",
            "Connection": "Keep-Alive",
            "X-Auth-Token":"strToken"
        ]
    
        APIManager.alamofireShared.upload(
            multipartFormData: { multipartFormData in
                
                if let parameters = parameters {
                    for (key, value) in parameters {
                        
                        if value is UIImage {
                            let item = value as! UIImage
                            //                            for  item in value as! [UIImage] {
                            if let imageData = item.jpegData(compressionQuality: 0.6) {
                                
                                multipartFormData.append(imageData, withName: key, fileName: "\("").jpg", mimeType: "image/jpeg")
                            }
                            //                            }
                        }
                        
                        let stringValue = "\(value)"
                        multipartFormData.append((stringValue.data(using: .utf8))!, withName: key)
                    }
                }
                
                
        },
            to: url,
            method: method,
            headers: headers,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        completionCallback(response as AnyObject)
                        
                        if self.isResponseValid(response: response) {
                            
                            switch response.result {
                            case .success(let responseJSON):
                                successCallback(responseJSON as AnyObject)
                            case .failure(let error):
                                failureCallback(error.localizedDescription)
                            }
                        } else {
                            let error =  self.getErrorForResponse(response: response)
                            failureCallback(error)
                        }
                        
                    }
                    
                case .failure(let encodingError):
                    failureCallback(encodingError.localizedDescription)
                    
                }
                
        })
    }
    
    
    //MARK:- Validation (Check response is valid or not)
    //MARK:-
     private func isResponseValid(response: DataResponse<Any>) -> Bool {
        if let statusCode = response.response?.statusCode, statusCode < 200 || statusCode >= 300 {
            return false
        }
        
        if let isSuccess = (response.result.value as AnyObject)["status"] as? Bool {
            return isSuccess
        } else if let isSuccess = (response.result.value as AnyObject)["status"] as? String {
            if isSuccess == "1" {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
     func getErrorForResponse(response: DataResponse<Any>) -> String? {
        switch response.result {
        case .success(let responseJSON):
            if let responseDictionary = responseJSON as? [String: Any] {
                if let errorMessage = responseDictionary["message"] as? String {
                      return errorMessage
                }
                
                if let errorMessage = responseDictionary["error"] as? String {
                      return errorMessage
                }
                
                if let errors = responseDictionary["error"] as? [[String:AnyObject]], errors.count > 0 ,
                                let errorMessge = errors[0]["error"] as? String  {
                      return errorMessge
                }
                
                if let errorMessage = responseDictionary["response"] as? String {
                    return errorMessage
                }

                return responseDictionary.description
            }
            return nil
        case .failure(let errorObj):
            return errorObj.localizedDescription
        }
    }
    
}

