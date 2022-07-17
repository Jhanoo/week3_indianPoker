//
//  MainView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import SocketIO

struct MainView: View {
    var body: some View {
        Group {
            Button {
//                SocketIOManager.shared
            } label: {
                Text("Enter room")
            }
            
            Button {
                
            } label: {
                Text("Create Room")
            }
            
            Button {
                
            } label: {
                Text("start game")
            }
            
            Button {
                
            } label: {
                Text("Room enter")
            }
        }
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
