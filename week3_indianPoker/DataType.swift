//
//  DataType.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI

struct User: Codable {
    var id: String
    var name: String = "null"
    var profileImg: String = "null"
    var win: Int = 0
    var lose: Int = 0
    
    mutating func updateUser(name: String, profileImg: String, win: Int, lose: Int){
        self.name = name
        self.profileImg = profileImg
        self.win = win
        self.lose = lose
    }
}

struct Room: Identifiable, Codable {
    let id = UUID()
    let host: User
    var participant: User?
    var title: String = "default"
    var onPlaying: Bool = false
    mutating func updateRoom(participant: User, title: String, onPlaying: Bool){
        self.participant = participant
        self.title = title
        self.onPlaying = true
    }
}

var users: [User] = []
var rooms: [Room] = []
func addSample(){
    users.append(User(id: "userSample00", name: "Sample00", win: 0, lose: 0))
    users.append(User(id: "userSample01", name: "Sample01", win: 0, lose: 0))
    users.append(User(id: "userSample02", name: "Sample02", win: 0, lose: 0))
    users.append(User(id: "userSample03", name: "Sample03", win: 0, lose: 0))
    users.append(User(id: "userSample04", name: "Sample04", win: 0, lose: 0))
    users.append(User(id: "userSample05", name: "Sample05", win: 0, lose: 0))
    rooms.append(Room(host: users[0], title: "Sample00's room"))
    rooms.append(Room(host: users[1], title: "Sample01's room"))
    rooms.append(Room(host: users[2], title: "Sample02's room"))
    rooms.append(Room(host: users[3], title: "Sample03's room"))
}

