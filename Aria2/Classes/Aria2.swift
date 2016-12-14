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

public typealias ResponseCompletion2<T:BaseResponseData> = (Result<T>) -> Void

public enum RPCCall {
    case addUri         ([String],  ResponseCompletion2<GID>)
    case getGlobalStat  (           ResponseCompletion2<GlobalStat>)
    
    
    var methodName:String {
        switch self {
        case .addUri:           return "aria2.addUri"
        case .getGlobalStat:    return "aria2.getGlobalStat"
        }
    }
}

public enum Result<T:BaseResponseData> {
    case Success(T)
    case Failure(Error?)
    
    /// Constructs a success wrapping a `value`.
    public init(value: T) {
        self = .Success(value)
    }
    
    /// Constructs a failure wrapping an `error`.
    public init(error: Error?) {
        self = .Failure(error)
    }
}

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
    
    
    private var completions:[String:Any] = [String:Any]()
    
    internal init(serverURL:URL, token:String?) {
        self.serverURL = serverURL
        self.token = token
    }


    internal func sendToServer(json: Data, completion: @escaping ([JSON]) -> Bool) {}
    
    public func call(method:RPCCall) {
        self.call(methods: [method])
    }
    
    public func call(methods:[RPCCall]) {
        var requests = [BaseRequestData]()
        
        for call in methods {
            switch call {
            case let .addUri        (uris, completion):     requests.append(self.createRequest(methodName: call.methodName, params: [uris]  , completion: completion))
            case let .getGlobalStat (completion):           requests.append(self.createRequest(methodName: call.methodName, params: nil     , completion: completion))
            }
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: requests.toJSONArray()!)
        self.sendToServer(json: jsonData, completion: sendToServerCompletion)
    }
    
    
    private func createRequest<T:BaseResponseData>(methodName: String, params: [Any]? = nil, completion: @escaping ResponseCompletion2<T>) -> BaseRequestData {
        let request = BaseRequestData(id: nil, method: methodName, token: self.token, params: params)
        self.completions[request.id] = completion
        return request
    }
    
    private func sendToServerCompletion(jsonArray: [JSON]) -> Bool {
        var foundCompletion = false
        for json in jsonArray {
            if let response = BaseResponseData(json: json) {
                if let completion = self.completions[response.id] as? ResponseCompletion2<GID> { self.completeResponse(json: json, completion: completion); foundCompletion = true }
                else if let completion = self.completions[response.id] as? ResponseCompletion2<GlobalStat> { self.completeResponse(json: json, completion: completion); foundCompletion = true }
                //else if let completion = self.completions[response.id] as? ResponseCompletion2<GlobalStat> { self.completeResponse(json: json, completion: completion) }
            }
        }
        return foundCompletion
    }
    
    
    private func completeResponse<T:BaseResponseData>(json: JSON, completion: @escaping ResponseCompletion2<T>) {
        if let data = T(json: json) {
            self.completions.removeValue(forKey: data.id)
            completion(Result.Success(data))
        } else {
            completion(Result.Failure(nil))
        }
    }
    
    /*
    private func requestWithGID<T:BaseResponseData>(_ gid:String, method:String, completion: @escaping ResponseCompletion<T>) {
        let request = BaseRequestData(method: method, token: self.token, params: [gid])
        self.writeToServer(request: request, completion: completion)
    }
    */
    /*
    public func response() {
        
        
        for (id, (request, completion)) in self.requests {
            
            if let complete = completion as? ResponseCompletion2<GID> {
                self.writeToServer2(request: request, completion: complete)
            } else if let complete = completion as? ResponseCompletion2<GlobalStat> {
                self.writeToServer2(request: request, completion: complete)
            }
            self.requests.removeValue(forKey: id)
        }
        
        
        /*
        print("response")
        print(self.completions["abc"])
        if let completion = self.completions["abc"] as? ResponseCompletion2<GID> {
            if let gid:GID = GID(json: ["result":"abc"]) {
                completion(Result.Success(gid))
            } else {
                print("gid not created but found")
            }
        } else {
            print("completion not found")
        }
        */
        
    }
    */
    
    // MARK: - Aria2 Functions
    /*
    public func addUri(_ uri:String, _ completion: @escaping ResponseCompletion2<GID>) -> Aria2 {
        return addUri([uri], completion)
    }
    
    public func addUri(_ uris:[String], _ completion: @escaping ResponseCompletion2<GID>) -> Aria2 {
        let request = BaseRequestData(method: "aria2.addUri", token: self.token, params: [uris])
        self.requests[request.id] = (request, completion)
        return self
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
    
    public func getGlobalStat(_ completion: @escaping ResponseCompletion2<GlobalStat>) -> Aria2 {
        print("getGlobalStat")
        let request = BaseRequestData(method: "aria2.getGlobalStat", token: self.token)
        //self.writeToServer2(request: request, completion: completion)
        self.requests[request.id] = (request, completion)
        return self
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
    public func multicall(params:[String : [Any]], _ completion: @escaping ResponseCompletion<BaseResponseData>) {

    }
    
    public func multicall(uri1:String, uri2:String, _ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }

    
    // TODO
    public func listMethods(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }
    
    // TODO
    public func listNotifications(_ completion: @escaping ResponseCompletion<BaseResponseData>) {
        
    }
    */
}
