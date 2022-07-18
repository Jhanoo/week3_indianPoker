//
//  MainView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import SocketIO

//var user = users[0]

struct MainView: View {
    
    
    @State private var isShowingPopOver = false
    
    
    init() {
//        addSample()
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
    }
    
    
    
    var body: some View {
        TabView {
            GameListView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }
            
            BankView()
                .tabItem {
                    Image(systemName: "dollarsign.square")
                    Text("Bank")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .font(.headline)
        .accentColor(.green)    // 클릭된 색깔
        .onAppear {
            SocketIOManager.shared.establishConnection()
        }

    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
