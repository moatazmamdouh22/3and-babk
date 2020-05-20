//
//  Socketmanger.swift
//  DriverRequest
//
//  Created by MacBook on 4/22/18.
//  Copyright © 2018 Technosaab. All rights reserved.
//

import Foundation
import Alamofire
import SocketIO
import SwiftyJSON

class MySocket {
    
    static let instance = MySocket()
    let manager = SocketManager(socketURL: URL(string: "http://46.101.212.87:7000")!)
    var socket:SocketIOClient
    init(){
         self.socket = self.manager.defaultSocket
    }
    
    func connect(){
        socket.connect()
    }
    
    func disconnect(){
        socket.disconnect()
    }
}
