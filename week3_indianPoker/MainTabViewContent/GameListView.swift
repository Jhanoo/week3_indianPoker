//
//  GameListView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

struct GameListView: View {
    
    var body: some View {
        ZStack{
            VStack{
                Text("Game List")
                List(rooms) { room in
                    RoomButtonInListView(room: room)
                }
                
            }
            CreateRoomButton(title: "New game", iconName: "plus.circle")
        }
        
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}



struct CreateRoomButton: View {
    //    @State var presentInGameView = false
    
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            //            presentInGameView = true
            NavigationView(content: {
                NavigationLink(destination: InGameView()){
                    Text("Enter Game")
                }
            })
            //            SocketIOManager.shared.createRoom(hostId: "room1", user: user)
            
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
    @State private var isShowingDetailView = false
    
    var room: Room
    var user = User(id: "test")
    
    var body: some View {
        
        Button(action: {
            self.showModal = true
            
        }){
            Text("\(room.title)").accentColor(.black)
        }
        .sheet(isPresented: self.$showModal) {
            NavigationView {
                VStack{
                    Text("\(room.title)")
                        .padding()
                    
                    Spacer()
                    ProfileImage(imageName: "Card_10")
                    Text("Name: \(room.host.name)")
                    Text("Win: \(room.host.win)\tLose: \(room.host.lose)")
                    Text("Profile: " + (room.host.profileImg))
                    
                    NavigationLink(destination: InGameView(), isActive: $isShowingDetailView) {}
                    Button {
                        //                    SocketIOManager.shared.enterRoom(hostId: "\(room.host.id)", user: user)
                        isShowingDetailView = true
                    } label: {
                        Text("Enter game")
                    }
                    Spacer()
                }
            }
        }
        
        
    }
}
