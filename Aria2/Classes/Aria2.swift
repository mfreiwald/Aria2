//
//  Aria2.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation

public class Aria2 {
    private static let REQUEST_PATH: String = "/jsonrpc"

    public class func connect(url: String, token: String? = nil) -> Aria2Provider {
        let serverURL = URL(string: url + REQUEST_PATH)!

        if let scheme = serverURL.scheme {
            if (scheme == "ws" || scheme == "wss") {
                return Aria2WS(serverURL: serverURL, token: token)
            }
        }
        return Aria2HTTP(serverURL: serverURL, token: token)
    }
}
