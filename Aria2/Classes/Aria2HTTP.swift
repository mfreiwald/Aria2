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
    
    internal override func writeToServer<T:BaseResponseData>(request: BaseRequestData, completion: @escaping ResponseCompletion<T>) {
        Alamofire.request(self.serverURL, method: .post, parameters: request.toJSON()!, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            if let json = response.result.value as? JSON {
                super.matchResponse(json: json, completion: completion)
            } else {
                completion(nil)
            }
        })
    }
}
