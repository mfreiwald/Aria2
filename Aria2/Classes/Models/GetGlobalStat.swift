//
//  GetGlobalStat.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation

internal class GetGlobalStat : BaseRequestData {
    
    internal init(id:String? = nil, token:String? = nil) {
        super.init(id: id, method: "aria2.getGlobalStat", token: token)
    }

}
