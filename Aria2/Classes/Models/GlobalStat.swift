//
//  GlobalStat.swift
//  Pods
//
//  Created by Michael Freiwald on 01.12.16.
//
//

import Foundation
import Gloss

public class GlobalStat : BaseResponseData {
    
    public let downloadSpeed:Int
    public let numActive:Int
    public let numStopped:Int
    public let numStoppedTotal:Int
    public let numWaiting:Int
    public let uploadSpeed:Int
    
    /**
     Returns new instance created from provided JSON.
     
     - parameter: json: JSON representation of object.
     */
    public required init?(json: JSON) {
        guard let downloadSpeed:Int = Int(("result.downloadSpeed" <~~ json) ?? "") else {
            return nil
        }
        self.downloadSpeed = downloadSpeed
        
        guard let numActive:Int = Int(("result.numActive" <~~ json) ?? "") else {
            return nil
        }
        self.numActive = numActive
        
        guard let numStopped:Int = Int(("result.numStopped" <~~ json) ?? "") else {
            return nil
        }
        self.numStopped = numStopped
        
        guard let numStoppedTotal:Int = Int(("result.numStoppedTotal" <~~ json) ?? "") else {
            return nil
        }
        self.numStoppedTotal = numStoppedTotal
        
        guard let numWaiting:Int = Int(("result.numWaiting" <~~ json) ?? "") else {
            return nil
        }
        self.numWaiting = numWaiting
        
        guard let uploadSpeed:Int = Int(("result.uploadSpeed" <~~ json) ?? "") else {
            return nil
        }
        self.uploadSpeed = uploadSpeed
        
        super.init(json: json)
    }
    
}
