//
//  ViewController.swift
//  Aria2
//
//  Created by Michael Freiwald on 12/01/2016.
//  Copyright (c) 2016 Michael Freiwald. All rights reserved.
//

import UIKit
import Aria2

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate

    var lastAdded:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    /*
    @IBAction func update(_ sender: Any) {
        app.aria?.getGlobalStat { (response) in
            print(response)
            guard let stats = response else {
                return
            }
            var str = ""
            str += "Download Speed: \(stats.downloadSpeed)\n"
            str += "Num Active: \(stats.numActive)\n"
            str += "Num Stopped: \(stats.numStopped)\n"
            str += "Num Stopped Total: \(stats.numStoppedTotal)\n"
            str += "Num Waiting: \(stats.numWaiting)\n"
            str += "Upload Speed: \(stats.uploadSpeed)"
            
            self.label.text = str
        }
    }

    @IBAction func add(_ sender: Any) {
        self.app.aria!.addUri("http://ipv4.download.thinkbroadband.com/50MB.zip", { (response) in
            guard let gid = response else {
                return
            }
            
            self.lastAdded = gid.gid
        })
    }
    
    @IBAction func remove(_ sender: Any) {
        if let gid = self.lastAdded {
            self.app.aria!.tellStatus(gid, { (response) in
                print(response)
            })
        }
    }
    */
}

