//
//  Functions.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/18.
//

import Foundation

func saveAppStorage(_ user : User) {
    // 내부 저장소 저장
    if let encoded = try? JSONEncoder().encode(user) {
        UserDefaults.standard.setValue(encoded, forKey: "user")
    }
//        // 내부 저장소에서 꺼내기
//        if let savedData = UserDefaults.standard.object(forKey: "user") as? Data {
//            if let savedObject = try? JSONDecoder().decode(User.self, from: savedData) {
//                print(savedObject)
//            }
//        }
}
