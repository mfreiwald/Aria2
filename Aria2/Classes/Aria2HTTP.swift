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
    
    internal override func sendToServer(json: Data, completion: @escaping SendCompletion) {
        var urlRequest = URLRequest(url: self.serverURL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = json

        Alamofire.request(urlRequest).responseJSON { response in
            
            if let jsonArray = response.result.value as? [JSON] {
                completion(jsonArray)
            } else {
                completion([JSON]())
            }
            
        }

    }
}
