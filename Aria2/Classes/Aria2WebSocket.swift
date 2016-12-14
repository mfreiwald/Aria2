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
internal typealias WebsocketCompletion = ([JSON]) -> Bool
public class Aria2WebSocket : Aria2, WebSocketDelegate, WebSocketPongDelegate {
    
    public var onDownloadStart:NotificationCompletion
    public var onDownloadPause:NotificationCompletion
    public var onDownloadStop:NotificationCompletion
    public var onDownloadComplete:NotificationCompletion
    public var onDownloadError:NotificationCompletion
    public var onBtDownloadComplete:NotificationCompletion
    
    public var autoReconnect:Bool = false
    
    private let socket:WebSocket
    private var connectCompletion:(()->())?
    
    private var completions:[WebsocketCompletion] = [WebsocketCompletion]()
    //private var completionsById:[String : Any] = [String : Any]()
    
    public override init(serverURL: URL, token: String? = nil) {
        socket = WebSocket(url: serverURL)
        super.init(serverURL: serverURL, token: token)
        socket.delegate = self
        socket.pongDelegate = self
    }
    
    // MARK: - Addtional functions
    
    public func connect(_ completion: @escaping ()->()) {
        self.connectCompletion = completion
        if(!socket.isConnected) {
            socket.connect()
        } else {
            self.connectCompletion?()
        }
    }
    
    public func disconnect() {
        if(socket.isConnected) {
            socket.disconnect()
        }
    }
    
    // MARK: - WebSocketDelegate
    
    public func websocketDidConnect(socket: WebSocket) {
        self.connectCompletion?()
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        if(self.autoReconnect) {
            connect {}
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        print(text)
        let jsonObj = try! JSONSerialization.jsonObject(with: text.data(using: String.Encoding.utf8)!)
        if let jsonArray = jsonObj as? [JSON] {
            for i in (0 ..< self.completions.count).reversed() {            //for completion in self.completions {
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
    
    override func sendToServer(json: Data, completion: @escaping WebsocketCompletion) {
        // problem wenn methode öfter aufgerufen wird!!
        self.completions.append(completion)
        connect {
            self.socket.write(data: json)
        }
    }
    
    /*
    internal override func writeToServer<T:BaseResponseData>(request: BaseRequestData, completion: @escaping ResponseCompletion<T>) {
        
        self.completionsById[request.id] = completion
        
        connect {
            do {
                let data = try JSONSerialization.data(withJSONObject: request.toJSON()!)
                self.socket.write(data: data)
            } catch {
                print(error)
            }
        }
    }
    
    private func completeResponse(_ baseResponse: BaseResponseData, with json: JSON) {
        if let completion = self.completionsById[baseResponse.id] {
            switch(String(describing: type(of:completion))) {
            case String(describing: ResponseCompletion<GID>.self): super.matchResponse(json: json, completion: completion as! ResponseCompletion<GID>)
            case String(describing: ResponseCompletion<GlobalStat>.self): super.matchResponse(json: json, completion: completion as! ResponseCompletion<GlobalStat>)
            default: super.matchResponse(json: json, completion: completion as! ResponseCompletion<BaseResponseData>)
            }
            
        } else {
            print("completeResponse = nil...")
        }
    }
    */
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
