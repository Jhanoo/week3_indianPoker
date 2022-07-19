//
//  GameListView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

struct GameListView: View {
    @State var rooms : [Room] = []
    var body: some View {
        ZStack{
            VStack{
                Text("Game List")
                List(rooms) { room in
                    RoomButtonInListView(room: room)
                }
                
            }
            CreateRoomButton(rooms: $rooms, title: "New game", iconName: "plus.circle")
        }
        .onAppear {
            SocketIOManager.shared.socket.on("rooms") { dataArray, ack in
                rooms = []
                let datas = dataArray[0] as! [[String : [String : Any]]]
                for data in datas {
                    let h = data["host"]!
                    let host = User(id: h["id"] as! String, name: h["name"] as! String, profileImg: h["profileImg"]! as! String, win: h["win"] as! Int, lose:h["lose"] as! Int)
                    print(host.profileImg)
                    let room = Room(host: host, title : "\(host.name)의 게임")
                    rooms.append(room)
                }
            }
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}

struct CreateRoomButton: View {
    @Binding var rooms : [Room]
    
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            rooms.append(Room(host: Constants.user!, title : "\(Constants.user!.name)의 게임"))
            SocketIOManager.shared.createRoom(hostId: Constants.user!.id, user: Constants.user!)
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
    
    var body: some View {
        VStack{
            Text("\(room.title)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Spacer()
            HStack{
                AsyncImage(url: URL(string: (room.host.profileImg)), content: { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 300, maxHeight: 100)
                         .cornerRadius(20)
                },
                           placeholder: {
                    ProgressView()
                })
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
                SocketIOManager.shared.enterRoom(hostId: "\(room.host.id)", user: Constants.user!)
                SocketIOManager.shared.socket.on("\(room.host.id)") {data, ack in
                }
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


