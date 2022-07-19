//
//  InGameView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

struct InGameView: View {
    @State private var timeRemaining = 10
    @State private var isStart = false
    @State var round = 1
    @Binding var rooms : [Room]
    @State private var showingDieAlert = false
    @Binding var isHost : Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            // Timer, Surrender
            VStack{
                HStack{
                    Spacer()
                    Text("Time: \(timeRemaining)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                    Spacer().padding()
                }
                SurrenderButtonView(rooms: $rooms)
                Spacer()
            }
            
            // 상대방 정보
            HStack{
                Spacer().padding()
                VStack{
                    Text("Name")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("300승 3패")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    Image(uiImage: UIImage(named: "Card_5")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 140)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                }
                VStack{
                    ProfileImage(imageName: "Card_1")
                    ZStack{
                        
                        Image(uiImage: UIImage(named: "chip")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        
                        Text("100")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                Spacer()
            }
            VStack{
                Spacer()
                // 상대 칩
                ZStack{
                    Image(uiImage: UIImage(named: "chip")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    Text("0")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                }
                Spacer()
                
                Text("Round \(round)")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                // 내 칩
                ZStack{
                    Image(uiImage: UIImage(named: "chip")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    Text("0")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .frame(height: 250)
            
            // 내 정보
            HStack{
                Spacer()
                VStack{
                    Spacer().padding()
                    
                    ZStack{
                        Button(action: {
                            
                        }){
                            Image(uiImage: UIImage(named: "chip")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                        Text("100")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    ProfileImage(imageName: "Card_1")
                }
                VStack{
                    Spacer()
                    
                    Image(uiImage: UIImage(named: "Card_back")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 140)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Name22")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("100승 30패")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        SocketIOManager.shared.bet(hostBet: 13, guestBet: 15)
                    }){
                        Text("베팅")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 5)
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    }
                    Button(action: {
                        SocketIOManager.shared.die(hostDie: true, guestDie: false)
                        showingDieAlert = true
                    }){
                        Text("다이")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 5)
                            .background(.black.opacity(0.75))
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    }
                    .alert("라운드 포기", isPresented: $showingDieAlert) {
                        Button("취소"){}
                        Button(action: {
                            
                        }) {
                            Text("DIE").foregroundColor(.red)
                        }
                    } message: {
                        Text("정말로 DIE 하시겠습니까?")
                    }
                }
                Spacer()
                
            }
            
            
        }.onAppear {
            SocketIOManager.shared.socket.on("gameinfo") {data, ack in
                let datas = data[0] as! [String : [String : [ Int : Any]]]
                print(datas)
            }
        }
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            else if(timeRemaining == 0){
                timeRemaining = 10
                SocketIOManager.shared.timeOut(hostTimeout: true, guestTimeout: false)
            }
        }
        .background(
            Image(uiImage: UIImage(named: "casino_table_only")!)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}


struct SurrenderButtonView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var rooms: [Room]
    @State private var showingAlert = false
    
    var body: some View {
        HStack{
            Spacer()
            Spacer()
            Button(action: {
                showingAlert = true
            }){
                Image(systemName: "flag.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 60)
                    .accentColor(.white)
            }
            .alert({
                Text("게임 항복")
            }(), isPresented: $showingAlert) {
                Button("취소"){}
                Button("나가기") {
                    for i in 0...(rooms.count-1) {
                        if(rooms[i].host.id == Constants.user?.id){
                            rooms.remove(at: i)
                            SocketIOManager.shared.removeRoom(hostId: Constants.user!.id, user: Constants.user!)
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("게임을 항복하고 나가시겠습니까?")
            }
            
            Spacer().padding()
        }
    }
}

