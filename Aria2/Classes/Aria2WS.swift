//
//  WebSocket.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Starscream

public class Aria2WS : Aria2Provider, WebSocketDelegate {
 
    public private(set) var serverURL: URL
    public private(set) var token: String?
    
    let socket:WebSocket
    
    
    public required init(serverURL: URL, token: String? = nil) {
        self.serverURL = serverURL
        self.token = token
        socket = WebSocket(url: self.serverURL)
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: - WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        print("websocketDidConnect")
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocketDidDisconnect")

    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("websocketDidReceiveMessage: \(text)")

    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("websocketDidReceiveData: \(data)")

    }
    
    // MARK: - Aria2 Protocol
    
    public func getGlobalStat(completion: @escaping (GlobalStat?) -> Void) {
        
    }
}
