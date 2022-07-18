//
//  SocketManager.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import Foundation
import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    let encoder = JSONEncoder()
    
    var manager = SocketManager(socketURL: URL(string: "\(Constants.IP_ADDRESS):\(Constants.PORT_NUM)/")!, config: [.log(true), .compress])
    
    var socket: SocketIOClient!
    
    override init() {
        super.init()
        socket = self.manager.socket(forNamespace: "/")
        
        socket.on("connection") { dataArray, ack in
            print(dataArray)
        }
    }

    func establishConnection() {
        socket.connect()
        print("소켓 연결 시작")
    }
    
    func closeConnection() {
        socket.disconnect()
        print("소켓 연결 종료")
    }
   
    func sendMessage(message: String, nickname: String) {
        socket.emit("msg", ["nick": nickname, "msg" : message])
    }
    
    func enterRoom(roomId : String, user : User) {
        let userData = try? encoder.encode(user)
        socket.emit("enter", ["roomId" : roomId, "enteredUserData" : userData as Any])
    }
    
    func createRoom(roomId : String, user : User) {
        let userData = try? encoder.encode(user)
        socket.emit("create", ["roomId" : roomId, "enteredUserData" : userData as Any])
    }
    
    func startGame(roomId : String, host : User, participant : User) {
        let hostData = try? encoder.encode(host)
        let participantData = try? encoder.encode(host)
        socket.emit("start", ["roomId" : roomId, "host" : hostData as Any, "participant" : participantData as Any])
    }
}
