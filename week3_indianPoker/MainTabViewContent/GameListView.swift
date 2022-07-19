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
    @State private var isPresented = false
    var room: Room
    var user = User(id: "test")
    
    var body: some View {
        VStack{
            Text("\(room.title)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Spacer()
            HStack{
                ProfileImage(imageName: "Card_10")
                VStack{
                    Spacer()
                    Text("Name: \(room.host.name)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("Win: \(room.host.win)\tLose: \(room.host.lose)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().padding()
                }
            }
            Button {
                //                    SocketIOManager.shared.enterRoom(hostId: "\(room.host.id)", user: user)
                isPresented.toggle()
            } label: {
                Text("Enter game")
            }
            .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
            
            Spacer()
        }
    }
    
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            InGameView()
        }
    }
}


