//
//  WebSocket.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Starscream
import Gloss

public typealias NotificationCompletion = ((_ gid:String) -> ())?
public class Aria2WebSocket : Aria2, WebSocketDelegate, WebSocketPongDelegate {
    
    public var onDownloadStart:NotificationCompletion
    public var onDownloadPause:NotificationCompletion
    public var onDownloadStop:NotificationCompletion
    public var onDownloadComplete:NotificationCompletion
    public var onDownloadError:NotificationCompletion
    public var onBtDownloadComplete:NotificationCompletion
    
    public var autoReconnect:Bool = false
    
    private let socket:WebSocket
    
    private var connectCompletions = [()->()]()
    
    private var completions:[SendCompletion] = [SendCompletion]()
    
    public override init(serverURL: URL, token: String? = nil) {
        socket = WebSocket(url: serverURL)
        super.init(serverURL: serverURL, token: token)
        socket.delegate = self
        socket.pongDelegate = self
        
        
    }
    
    // MARK: - Addtional functions
    
    public func connect(_ completion: @escaping ()->()) {
        self.connectCompletions.append(completion)
        if(!socket.isConnected) {
            socket.connect()
        } else {
            self.connectCompletion()
        }
    }
    
    public func disconnect() {
        if(socket.isConnected) {
            socket.disconnect()
        }
    }
    
    // MARK: - WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        self.connectCompletion()
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if(self.autoReconnect) {
            connect {}
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        let jsonObj = try! JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8)!)
        if let jsonArray = jsonObj as? [JSON] {
            for i in (0 ..< self.completions.count).reversed() {
                let completion = self.completions[i]
                if(completion(jsonArray)) {
                    // remove from array
                    let _ = self.completions.remove(at: i)
                }
            }
        }

    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        
    }
    
    public func websocketDidReceivePong(socket: WebSocket, data: Data?) {

    }
    
    // MARK: - Private functions
    
    override func sendToServer(json: Data, completion: @escaping SendCompletion) {
        // problem wenn methode öfter aufgerufen wird!!
        self.completions.append(completion)
        
        connect {
            self.socket.write(data: json)
        }
    }
    
    private func connectCompletion() {
        for completion in self.connectCompletions {
            completion()
        }
        self.connectCompletions.removeAll()
    }

    private func completeNotification(_ notification:NotificationResponse) {
        switch(notification.notification) {
        case .onDownloadStart: self.onDownloadStart?(notification.gid)
        case .onDownloadPause: self.onDownloadPause?(notification.gid)
        case .onDownloadStop: self.onDownloadStop?(notification.gid)
        case .onDownloadComplete: self.onDownloadComplete?(notification.gid)
        case .onDownloadError: self.onDownloadError?(notification.gid)
        case .onBtDownloadComplete: self.onBtDownloadComplete?(notification.gid)
        }
    }
 
}
