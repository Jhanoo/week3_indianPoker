//
//  MainView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/17.
//

import SwiftUI

struct MainView: View {
    
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
   
    var body: some View {
        
        Button(action: {
            self.showModal = true
        }){
            Text("\(room.title)").accentColor(.black)
        }
        .sheet(isPresented: self.$showModal) {
            Text("\(room.title)")
                .padding()
        }


    }
}
