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
                print("22222222222")
                
//                for i in dataArray {
//                    let json = try? JSONSerialization.data(withJSONObject: i, options: .fragmentsAllowed)
//                    let jsonData = try? JSONDecoder().decode(RoomData.self, from: json!)
//                    print(jsonData)
//                }
                
                let jsonData = try? JSONDecoder().decode(RoomsArr.self, from: dataArray[0] as? RoomsArr )
                print(jsonData)
//                let output = try? JSONDecoder().decode(RoomsArr.self, from: dataArray[0] as! Data)
//                    print(output)
//                var rooms : [RoomData] = []
//                for i in dataArray {
//                    let output = try? JSONDecoder().decode(dataArray, from: i)
//                    rooms.append(output!)
//                }
//                print(rooms)
//                print(dataArray[0])
                print("33333333333")
                print(ack)
                print("44444444444")
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
    @State var presentInGameView = false
    @Binding var rooms : [Room]
    
    var title: String
    var iconName: String
    
    var body: some View {
        Button(action: {
            presentInGameView = true
            print("new game")
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
    @State private var showModal = false
    var room: Room
    
    var body: some View {
        
        Button(action: {
            self.showModal = true
            
        }){
            Text("\(room.title)").accentColor(.black)
        }
        .sheet(isPresented: self.$showModal) {
            VStack{
                Text("\(room.title)")
                    .padding()
                
                Spacer()
                ProfileImage(imageName: "Card_10")
                Text("Name: \(room.host.name)")
                Text("Win: \(room.host.win)\tLose: \(room.host.lose)")
                Text("Profile: " + (room.host.profileImg))
                
                Button {
                    SocketIOManager.shared.enterRoom(hostId: "\(room.host.id)", user: Constants.user!)
                    print("------------------------------------")
                    print(room.host.id)
                    SocketIOManager.shared.socket.on("\(room.host.id)") {data, ack in
                        print("------------------------------------")
                        print(data)
                        print(ack)
                    }
//                    InGameView()
                } label: {
                    Text("Enter game")
                }
                Spacer()
            }
        }
        
        
    }
}
