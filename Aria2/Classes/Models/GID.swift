//
//  GID.swift
//  Pods
//
//  Created by Michael Freiwald on 02.12.16.
//
//

import Foundation
import Gloss

public class GID : BaseResponseData {
    public let gid:String

    /**
     Returns new instance created from provided JSON.
     
     - parameter: json: JSON representation of object.
     */
    public required init?(json: JSON) {
        guard let gid:String = "result" <~~ json else {
            return nil
        }
        self.gid = gid
        super.init(json: json)
    }
}
