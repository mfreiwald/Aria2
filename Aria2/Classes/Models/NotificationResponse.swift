//
//  NotificationResponse.swift
//  Pods
//
//  Created by Michael Freiwald on 02.12.16.
//
//

import Foundation
import Gloss

public enum Aria2Notification : String {
    case onDownloadStart = "aria2.onDownloadStart"
    case onDownloadPause = "aria2.onDownloadPause"
    case onDownloadStop = "aria2.onDownloadStop"
    case onDownloadComplete = "aria2.onDownloadComplete"
    case onDownloadError = "aria2.onDownloadError"
    case onBtDownloadComplete = "aria2.onBtDownloadComplete"
}

public class NotificationResponse : Decodable {
    public let jsonrpc: String
    public let notification:Aria2Notification
    public let gid:String
    
    /**
     Returns new instance created from provided JSON.
     
     - parameter: json: JSON representation of object.
     */
    public required init?(json: JSON) {
        guard let jsonrpc: String = "jsonrpc" <~~ json else {
            return nil
        }
        self.jsonrpc = jsonrpc
        
        guard let method: String = "method" <~~ json else {
            return nil
        }
        guard let notification: Aria2Notification = Aria2Notification(rawValue: method) else {
            return nil
        }
        self.notification = notification
        
        guard let params: [[String:String]] = "params" <~~ json else {
            return nil
        }
        guard let gid = params[0]["gid"] else {
            return nil
        }
        self.gid = gid
    }
}
