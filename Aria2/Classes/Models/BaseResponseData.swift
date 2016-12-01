//
//  BaseResponseData.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Gloss

public class BaseResponseData : Decodable {
    public let id: String
    public let jsonrpc: String
    
    /**
     Returns new instance created from provided JSON.
     
     - parameter: json: JSON representation of object.
     */
    public required init?(json: JSON) {
        guard let id: String = "id" <~~ json else {
            return nil
        }
        self.id = id
        
        guard let jsonrpc: String = "jsonrpc" <~~ json else {
            return nil
        }
        self.jsonrpc = jsonrpc
        
    }

}
