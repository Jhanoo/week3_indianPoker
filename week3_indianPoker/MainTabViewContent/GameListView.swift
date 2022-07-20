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
                    RoomButtonInListView(rooms: $rooms, room: room)
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
    @State private var isPresented = false
    @Binding var rooms : [Room]
    @State var isHost = true
    
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            rooms.append(Room(host: Constants.user!, title : "\(Constants.user!.name)의 게임"))
            SocketIOManager.shared.createRoom(hostId: Constants.user!.id, user: Constants.user!)
            print("host room create")
            for i in rooms {
                print("room = \(i.title)")
            }
            isPresented = true
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
        .fullScreenCover(isPresented: $isPresented, content: {
            FullScreenModalView(rooms: $rooms, isHost: $isHost)
        })
        .frame(maxHeight: .infinity, alignment: .bottomTrailing)
        .padding(10)
    }
}

struct RoomButtonInListView: View {
    @State private var isPresented = false
    @Binding var rooms: [Room]
    @State var isHost = false
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
                        .frame(width: 100, height: 100)
                    .cornerRadius(20) }, placeholder: {
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
                isPresented.toggle()
            } label: {
                Text("Enter game")
            }
            .fullScreenCover(isPresented: $isPresented, content: {
                FullScreenModalView(rooms: $rooms, isHost: $isHost)
            })
            Spacer()
        }
    }
    
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var rooms : [Room]
    @Binding var isHost : Bool
    
    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            InGameView(rooms: $rooms, isHost: $isHost)
        }
    }
}
