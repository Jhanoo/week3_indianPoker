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

//struct GameData : Codable {
//    turn
//    chip
//    
//}

