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
        
//        socket.on("rooms") { data, ack in
//            print(data)
//        }
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
    
    func enterRoom(hostId : String, user : User) {
        let userData = try? encoder.encode(user)
        socket.emit("enter", ["hostId" : hostId, "enteredUserData" : userData as Any])
    }
    
    func createRoom(hostId : String, user : User) {
        let userData = try? encoder.encode(user)
        socket.emit("create", ["hostId" : hostId, "enteredUserData" : userData as Any])
    }
    
    func removeRoom(hostId : String, user: User) {
        let userData = try? encoder.encode(user)
        socket.emit("remove", ["hostId" : hostId, "enteredUserData" : userData as Any])
    }
    
    func startGame(hostId : String, host : User, participant : User) {
        let hostData = try? encoder.encode(host)
        let participantData = try? encoder.encode(host)
        socket.emit("start", ["hostId" : hostId, "host" : hostData as Any, "participant" : participantData as Any])
    }
}
