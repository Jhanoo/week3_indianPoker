//
//  week3_indianPokerApp.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/17.
//

import SwiftUI
import KakaoSDKAuth
import KakaoSDKCommon


@main
struct week3_indianPokerApp: App {
    
    init() {
        KakaoSDK.initSDK(appKey:"066a9764b9693059a659e13349024e74")
    }

    var body: some Scene {
        WindowGroup {
            InitView()
//            socketTestView()
        }
    }
}
