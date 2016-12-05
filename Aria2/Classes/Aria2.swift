//
//  Aria2.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Gloss

public typealias ResponseCompletion<T:BaseResponseData> = (T?) -> Void

public class Aria2 {
    private static let REQUEST_PATH: String = "/jsonrpc"

    public class func connect(url: String, token: String? = nil) -> Aria2 {
        let serverURL = URL(string: url + Aria2.REQUEST_PATH)!
        if let scheme = serverURL.scheme {
            if (scheme == "ws" || scheme == "wss") {
                return Aria2WebSocket(serverURL: serverURL, token: token)
            }
        }
        
        return Aria2HTTP(serverURL: serverURL, token: token)
    }
    
    public class func websocket(url: String, token: String? = nil) -> Aria2WebSocket {
        let serverURL = URL(string: url + REQUEST_PATH)!
        return Aria2WebSocket(serverURL: serverURL, token: token)
    }
    
    public class func http(url: String, token: String? = nil) -> Aria2HTTP {
        let serverURL = URL(string: url + REQUEST_PATH)!
        return Aria2HTTP(serverURL: serverURL, token: token)
    }
    
    internal var serverURL: URL
    internal var token: String?
    
    internal init(serverURL:URL, token:String?) {
        self.serverURL = serverURL
        self.token = token
    }
    
    internal func writeToServer<T:BaseResponseData>(request: BaseRequestData, completion: @escaping ResponseCompletion<T>) {}

    internal func matchResponse<T:BaseResponseData>(json: JSON, completion: @escaping ResponseCompletion<T>) {
        if let stats = T(json: json) {
            print("matchResponse \(stats)")
            completion(stats)
        } else {
            print("matchResponse nil")
            completion(nil)
        }
        /*else if let gid = GID(json: json) {
            completion(gid)
        } else {
            completion(BaseResponseData(json: json))
        }
        */
    }
    
    private func requestWithGID<T:BaseResponseData>(_ gid:String, method:String, completion: @escaping ResponseCompletion<T>) {
        let request = BaseRequestData(method: method, token: self.token, params: [gid])
        self.writeToServer(request: request, completion: completion)
    }
    
    // MARK: - Aria2 Functions
    
    public func addUri(_ uri:String, _ completion: @escaping ResponseCompletion<GID>) {
        addUri([uri], completion)
    }
    
    public func addUri(_ uris:[String], _ completion: @escaping ResponseCompletion<GID>) {
        let request = BaseRequestData(method: "aria2.addUri", token: self.token, params: [uris])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func remove(_ gid:String, _ completion: @escaping ResponseCompletion<GID>) {
        requestWithGID(gid, method: "aria2.remove", completion: completion)

    }
  
    public func forceRemove(_ gid:String, _ completion: @escaping ResponseCompletion<GID>) {
        requestWithGID(gid, method: "aria2.forceRemove", completion: completion)
    }
    
    public func pause(_ gid:String, _ completion: @escaping ResponseCompletion<GID>) {
        requestWithGID(gid, method: "aria2.pause", completion: completion)
    }
    
    public func forcePauseAll(_ completion: @escaping ResponseCompletion<GID>) {
        let request = BaseRequestData(method: "aria2.forcePauseAll", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func unpause(_ gid:String, _ completion: @escaping ResponseCompletion<GID>) {
        requestWithGID(gid, method: "aria2.unpause", completion: completion)
    }
    
    public func unpauseAll(_ completion: @escaping ResponseCompletion<GID>) {
        let request = BaseRequestData(method: "aria2.unpauseAll", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func tellStatus(_ gid:String, keys: [String] = [String](), _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.tellStatus", token: self.token, params: [gid, keys])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func getUris(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.getUris", completion: completion)
    }
    
    public func getFiles(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.getFiles", completion: completion)
    }
    
    public func getPeers(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.getPeers", completion: completion)
    }
    
    public func getServers(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.getServers", completion: completion)
    }
    
    public func tellActive(keys: [String] = [String](), _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.tellActive", token: self.token, params: [keys])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func tellWaiting(offset: Int, num: Int, keys: [String] = [String](), _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.tellWaiting", token: self.token, params: [offset, num, keys])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func tellStopped(offset: Int, num: Int, keys: [String] = [String](), _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.tellStopped", token: self.token, params: [offset, num, keys])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func changePosition(_ gid: String, pos: Int, how: String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.changePosition", token: self.token, params: [gid, pos, how])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func changeUri(_ gid: String, fileIndex: Int, delUris:[String], addUris:[String], position: Int, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.changeUri", token: self.token, params: [gid, fileIndex, delUris, addUris, position])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func getOption(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.getOption", completion: completion)
    }
    
    // TODO: Options
    public func changeOption(_ gid:String, options:Any, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.changeOption", token: self.token, params: [gid, options])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func getGlobalOption(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.getGlobalOption", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    // TODO: Options
    public func changeGlobalOption(options:Any, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.changeGlobalOption", token: self.token, params: [options])
        self.writeToServer(request: request, completion: completion)
    }
    
    public func getGlobalStat(_ completion: @escaping ResponseCompletion<GlobalStat>) {
        let request = BaseRequestData(method: "aria2.getGlobalStat", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func purgeDownloadResult(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.purgeDownloadResult", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func removeDownloadResult(_ gid:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        requestWithGID(gid, method: "aria2.removeDownloadResult", completion: completion)
    }
    
    public func getVersion(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.getVersion", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func getSessionInfo(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.getSessionInfo", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func shutdown(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.shutdown", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func forceShutdown(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.forceShutdown", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    public func saveSession(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        let request = BaseRequestData(method: "aria2.saveSession", token: self.token)
        self.writeToServer(request: request, completion: completion)
    }
    
    // TODO
    public func multicall(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }
    
    // TODO
    public func listMethods(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }
    
    // TODO
    public func listNotifications(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }
}
