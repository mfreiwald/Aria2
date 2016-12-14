//
//  Aria2HTTP.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Alamofire
import Gloss

public class Aria2HTTP : Aria2 {

    public override init(serverURL:URL, token:String?) {
        super.init(serverURL: serverURL, token: token)
    }
    
    /*
    internal override func writeToServer<T:BaseResponseData>(request: BaseRequestData, completion: @escaping ResponseCompletion<T>) {
        
        print("Aria2HTTP:writeToServer:requests:completion")
        
        var urlRequest = URLRequest(url: self.serverURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: request.toJSON()!)
        urlRequest.httpBody = data

        Alamofire.request(urlRequest).responseJSON { response in

            print(response)
            
            if let json = response.result.value as? JSON {
                super.matchResponse(json: json, completion: completion)
            } else {
                completion(nil)
            }
        }
        
    }
    */
    /*
    internal override func writeToServer2<T:BaseResponseData>(request: BaseRequestData, completion: @escaping ResponseCompletion2<T>) {
        print("Aria2HTTP:writeToServer2:requests:completion")
        
        var urlRequest = URLRequest(url: self.serverURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try! JSONSerialization.data(withJSONObject: request.toJSON()!)
        urlRequest.httpBody = data
        
        Alamofire.request(urlRequest).responseJSON { response in
            
            print(response)
            
            if let json = response.result.value as? JSON {
                super.matchResponse2(json: json, completion: completion)
            } else {
                completion(Result.Failure(nil))
            }
        }
    }
    */
    
    internal override func sendToServer(json: Data, completion: @escaping ([JSON]) -> Bool) {
        var urlRequest = URLRequest(url: self.serverURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = json

        Alamofire.request(urlRequest).responseJSON { response in
            
            print(response)
            if let jsonArray = response.result.value as? [JSON] {
                completion(jsonArray)
            } else {
                completion([JSON]())
            }
            
        }

    }
}
