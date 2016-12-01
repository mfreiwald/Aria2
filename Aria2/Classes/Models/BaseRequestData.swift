//
//  BaseRequestData.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Gloss

internal class BaseRequestData : Encodable {
    let id: String
    let method: String
    private(set) var params: [Any]
    
    internal init(id:String?, method:String, token:String? = nil, params:[Any] = [Any]()) {
        self.id = id ?? UUID().uuidString
        self.method = method
        
        self.params = [Any]()
        if let _ = token {
            self.params.append("token:\(token!)")
        }
        self.params.append(params)
    }
    
    /**
     Encodes and object as JSON.
     
     - returns: JSON when encoding was successful, nil otherwise.
     */
    internal func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> self.id,
            "method" ~~> self.method,
            "params" ~~> self.params
            ])
    }

    
}
