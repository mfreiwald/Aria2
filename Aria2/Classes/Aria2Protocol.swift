//
//  Aria2Protocol.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation

public protocol Aria2Provider {
    
    var serverURL: URL { get }
    var token: String? { get }
    
    init(serverURL:URL, token:String?)
    func getGlobalStat(completion: @escaping (GlobalStat?) -> Void)
}
