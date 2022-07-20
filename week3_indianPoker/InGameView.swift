//
//  InGameView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

struct InGameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var timeRemaining = 30
    @State private var isStart = false
    @State var round = 1
    @Binding var rooms : [Room]
    @State private var showingDieAlert = false
    @Binding var isHost : Bool
    
    @State private var endGame = false
    @State private var host : User = User(id: "default")
    @State private var guest : User = User(id: "default")
    @State private var roundChainging = false
    
    @State private var myTurn = false
    @State private var disabled = true
    @State private var myTotChip = 50
    @State private var myChip = 0
    @State private var yourChip = 0
    @State private var myChipSum = 50
    @State private var yourChipSum = 50
    @State private var myCard = 1
    @State private var yourCard = 1
    
//    @State private var GameEnd
    
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
                    Text(isHost ? guest.name : host.name)
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text(isHost ? "\(guest.win)승 \(guest.lose)패" : "\(host.win)승 \(host.lose)패")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    Image(uiImage: UIImage(named: "Card_\(yourCard)")!)
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
                        
                        Text("\(yourChipSum)")
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
                    if roundChainging {
                        
                    } else {
                        Image(uiImage: UIImage(named: "chip")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        Text("\(yourChip)")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                
                Text("Round \(round)")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                // 내 칩
                ZStack{
                    if roundChainging {
                        
                    } else {
                        Image(uiImage: UIImage(named: "chip")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        Text("\(myChip)")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
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
                            myChip += 1
                            myChipSum -= 1
                        }){
                            Image(uiImage: UIImage(named: "chip")!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                        }
                        .disabled(disabled)
                        Text("\(myChipSum)")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.white)
                    }
                    ProfileImage(imageName: "Card_1")
                }
                VStack{
                    Spacer()
                    
                    Image(uiImage: UIImage(named: roundChainging ? "Card_\(myCard)" : "Card_back")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 140)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(isHost ? host.name : guest.name)
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(isHost ? "\(host.win)승 \(host.lose)패" : "\(guest.win)승 \(guest.lose)패")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        SocketIOManager.shared.bet(bet: myChip)
                        disabled = true
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
                    .disabled(disabled)
                    Button(action: {
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
                    .disabled(disabled)
                    .alert("라운드 포기", isPresented: $showingDieAlert) {
                        Button("취소"){}
                        Button(action: {
                            SocketIOManager.shared.die(die: 1)
                            disabled = true
                        }) {
                            Text("DIE").foregroundColor(.red)
                        }
                    } message: {
                        Text("정말로 DIE 하시겠습니까?")
                    }
                }
                Spacer()
                
            }
            
            
        }.alert({
            Text("게임 종료")
        }(), isPresented: $endGame) {
            Button("나가기") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            if yourChip > myChip {
                Text("You Lose")
            } else {
                Text("You Win")
            }
        }
        .onAppear {
            SocketIOManager.shared.socket.on("start") { data, ack in
                let datas = data[0] as! [String : [ String : Any ]]
                let h = datas["host"]!
                let g = datas["guest"]!
                let host = User(id: h["id"] as! String, name: h["name"] as! String, profileImg: h["profileImg"]! as! String, win: h["win"] as! Int, lose:h["lose"] as! Int)
                let guest = User(id: g["id"] as! String, name: g["name"] as! String, profileImg: g["profileImg"]! as! String, win: g["win"] as! Int, lose:g["lose"] as! Int)
                self.host = host
                self.guest = guest
            }
            SocketIOManager.shared.socket.on("gameinfo") {data, ack in
                print("rooms = \(rooms)")
                print(data)
                let datas = data[0] as! [String : [ String : Any]]
                print("------------------------------------")
                print(datas)
                print("------------------------------------")
                
                if datas["round"]!["1"] as! Int == 16 {
                    endGame = true
                    if isHost {
                        myChip = datas["chip"]!["1"] as! Int
                        yourChip = datas["chip"]!["0"] as! Int
                    } else {
                        myChip = datas["chip"]!["0"] as! Int
                        yourChip = datas["chip"]!["1"] as! Int
                    }
                    return
                }
                
                if (self.round != datas["round"]!["1"] as! Int) {
                    roundChainging = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        roundChainging = false
                        self.round = datas["round"]!["1"] as! Int
                        if isHost {
                            print("😁")
                            print(type(of: datas["turn"]!["1"] as! Int))
                            print(datas["turn"]!["1"] as! Int == 1)
                            if datas["turn"]!["1"] as! Int == 1 {
                                self.myTurn = true
                                self.disabled = false
                            } else {
                                self.myTurn = false
                                self.disabled = true
                            }
                            print(myTurn)
                            self.myCard = datas["card"]!["1"] as! Int
                            self.yourCard = datas["card"]!["0"] as! Int
                            self.myChip = datas["chip"]!["1"] as! Int
                            self.yourChip = datas["chip"]!["0"] as! Int
                            self.myChipSum = datas["chip_sum"]!["1"] as! Int
                            self.yourChipSum = datas["chip_sum"]!["0"] as! Int
                            print("😁")
                            print(datas["turn"]!["1"] as! Int)
                            print(self.myChip)
                            print(self.myCard)
                            print(self.yourChip)
                            print(self.yourCard)
                        } else {
                            print("😡ajsdfkjnakjsdnfkjansdfkjnaksdfkj")
                            print(datas["turn"]!["0"] as! Int == 1)
                            print(type(of: datas["turn"]!["1"] as! Int))
                            if datas["turn"]!["0"] as! Int == 1 {
                                self.myTurn = true
                                self.disabled = false
                            } else {
                                self.myTurn = false
                                self.disabled = true
                            }
                            print(myTurn)
                            self.myCard = datas["card"]!["0"] as! Int
                            self.yourCard = datas["card"]!["1"] as! Int
                            self.myChip = datas["chip"]!["0"] as! Int
                            self.yourChip = datas["chip"]!["1"] as! Int
                            self.myChipSum = datas["chip_sum"]!["0"] as! Int
                            self.yourChipSum = datas["chip_sum"]!["1"] as! Int
                            print(self.myChip)
                            print(self.myCard)
                            print(self.yourChip)
                            print(self.yourCard)
                        }
                    })
                } else {
                    self.round = datas["round"]!["1"] as! Int
                    if isHost {
                        print("😁")
                        print(type(of: datas["turn"]!["1"] as! Int))
                        print(datas["turn"]!["1"] as! Int == 1)
                        if datas["turn"]!["1"] as! Int == 1 {
                            self.myTurn = true
                            self.disabled = false
                        } else {
                            self.myTurn = false
                            self.disabled = true
                        }
                        print(myTurn)
                        self.myCard = datas["card"]!["1"] as! Int
                        self.yourCard = datas["card"]!["0"] as! Int
                        self.myChip = datas["chip"]!["1"] as! Int
                        self.yourChip = datas["chip"]!["0"] as! Int
                        self.myChipSum = datas["chip_sum"]!["1"] as! Int
                        self.yourChipSum = datas["chip_sum"]!["0"] as! Int
                        print("😁")
                        print(datas["turn"]!["1"] as! Int)
                        print(self.myChip)
                        print(self.myCard)
                        print(self.yourChip)
                        print(self.yourCard)
                    } else {
                        print("😡ajsdfkjnakjsdnfkjansdfkjnaksdfkj")
                        print(datas["turn"]!["0"] as! Int == 1)
                        print(type(of: datas["turn"]!["1"] as! Int))
                        if datas["turn"]!["0"] as! Int == 1 {
                            self.myTurn = true
                            self.disabled = false
                        } else {
                            self.myTurn = false
                            self.disabled = true
                        }
                        print(myTurn)
                        self.myCard = datas["card"]!["0"] as! Int
                        self.yourCard = datas["card"]!["1"] as! Int
                        self.myChip = datas["chip"]!["0"] as! Int
                        self.yourChip = datas["chip"]!["1"] as! Int
                        self.myChipSum = datas["chip_sum"]!["0"] as! Int
                        self.yourChipSum = datas["chip_sum"]!["1"] as! Int
                        print(self.myChip)
                        print(self.myCard)
                        print(self.yourChip)
                        print(self.yourCard)
                    }
                }
                
                
            }
            if(!isHost){
                SocketIOManager.shared.startGame()
            }
        }
        .onReceive(timer) { time in
            print("🤣 timer running")
            print(myTurn)
            if timeRemaining > 0 && myTurn && !roundChainging {
                timeRemaining -= 1
            }
            else if(timeRemaining == 0 && myTurn && !roundChainging){
                timeRemaining = 30
                myTurn = false
                SocketIOManager.shared.timeOut(timeout: 1)
            } else if(roundChainging) {
                timeRemaining = 30
                print("round changing")
            }
            else if(!myTurn){
                timeRemaining = 30
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
                    SocketIOManager.shared.removeRoom(hostId: Constants.user!.id, user: Constants.user!)
                    
                    
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("게임을 항복하고 나가시겠습니까?")
            }
            
            Spacer().padding()
        }
    }
}

