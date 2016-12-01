//
//  Aria2HTTP.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Alamofire

public class Aria2HTTP : Aria2Provider {
    public private(set) var serverURL: URL
    public private(set) var token: String?
    
    public required init(serverURL: URL, token: String? = nil) {
        self.serverURL = serverURL
        self.token = token
    }
    
    public func getGlobalStat(completion: @escaping (GlobalStat?) -> Void) {
        let globalStats = GetGlobalStat(token: self.token)
        Alamofire.request(self.serverURL, method: .post, parameters: globalStats.toJSON()!, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            if let json = response.result.value as? Dictionary<String, Any> {
                completion(GlobalStat(json: json) ?? nil)
            } else {
                completion(nil)
            }
        })
    }
}
