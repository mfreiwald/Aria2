//
//  MultiCallRequest.swift
//  Pods
//
//  Created by Michael Freiwald on 07.12.16.
//
//

import Foundation
import Gloss

internal class MultiCallRequest : BaseRequestData {

    init(id:String? = nil, token:String? = nil, params:[String:[Any]]) {
        var tmp = [MultiCallParameter]()
        for (key, value) in params {
            var parameters = [Any]()
            if let _ = token {
                parameters.append("token:\(token!)")
            }
            for para in value {
                parameters.append(para)
            }
            tmp.append(MultiCallParameter(methodName: key, params: parameters))
        }
        super.init(id: id, method: "system.multicall", token: nil, params: tmp.toJSONArray())
    }
}

internal struct MultiCallParameter : Encodable {
    let params:[Any]
    let methodName:String
    
    init(methodName:String, params:[Any]) {
        self.methodName = methodName
        self.params = params
    }
    
    /**
     Encodes and object as JSON.
     
     - returns: JSON when encoding was successful, nil otherwise.
     */
    internal func toJSON() -> JSON? {
        return jsonify([
            "methodName" ~~> self.methodName,
            "params" ~~> self.params
            ])
    }
}
