//
//  MainView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import SocketIO

struct MainView: View {
    
    private var user = User(id: "testid")
    
    @State private var isShowingPopOver = false
    
    init() {
        addSample()
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
    }
    
    var body: some View {
        TabView {
            ZStack{
                VStack{
                    Text("Game List")
                    List(rooms) { room in
                        RoomButtonInListView(room: room)
                    }
                    
                }
                MyButton(title: "New game", iconName: "plus.circle")
                
            }
            .tabItem {
                Image(systemName: "gamecontroller")
                Text("Game")
            }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "dollarsign.square")
                    Text("Bank")
                }
            Text("The Last Tab")
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
        
        Group {
            Button {
                SocketIOManager.shared.enterRoom(roomId: "room1", user: user)
            } label: {
                Text("Enter room")
            }
            
            Button {
                SocketIOManager.shared.enterRoom(roomId: "room1", user: user)
            } label: {
                Text("Create Room")
            }
            
            Button {
                SocketIOManager.shared.startGame(roomId: "room1", host: user, participant: user)
            } label: {
                Text("start game")
            }
            
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct MyButton: View {
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            print("tapped!")
            
        }) {
            HStack() {
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .heavy))
                Text(title)
                    .font(.system(size: 20, weight: .heavy))
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(20)
        }
        .frame(maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(10)
    }
}

struct RoomButtonInListView: View {
    @State private var showModal = false
    var room: Room
    // 내부 저장소에서 꺼내기
//    if let savedData = UserDefaults.standard.object(forKey: "user") as? Data {
//        if let savedObject = try? JSONDecoder().decode(User.self, from: savedData) {
//            print(savedObject)
//        }
//    }
    
    var user = User(id: "test")
    var body: some View {
        
        Button(action: {
            self.showModal = true
            
        }){
            Text("\(room.title)").accentColor(.black)
        }
        .sheet(isPresented: self.$showModal) {
            Text("\(room.title)")
                .padding()
            
            Button {
                SocketIOManager.shared.enterRoom(roomId: "\(room.roomId)", user: user)
            } label: {
                Text("enter")
            }
        }
        
        
    }
}
