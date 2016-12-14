//
//  BatchResponse.swift
//  Pods
//
//  Created by Michael Freiwald on 13.12.16.
//
//

import Foundation
import Gloss

internal class BatchResponse : Decodable {
    
    var responses:[BaseResponseData]
    
    /**
     Returns new instance created from provided JSON.
     
     - parameter: json: JSON representation of object.
     */
    internal required init?(json: JSON) {
        guard let responses: [BaseResponseData] = "" <~~ json else {
            return nil
        }
        self.responses = responses
        
    }
}
