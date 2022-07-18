//
//  ProfileView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

private var user = User(id: "userSample00", name: "Sample00", win: 0, lose: 0, money: 0, chip: 0)

struct ProfileView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                ProfileImage(imageName: "Card_1")
                    .padding()
                Form {
                    Section(header: Text("My Info")) {
                        HStack {
                            Text("Name: ")
                            Spacer(minLength: 100)
                            Text(user.name)
                        }
                        HStack {
                            Text("Win: ")
                            Spacer(minLength: 100)
                            Text(String(user.win))
                        }
                        HStack {
                            Text("Lose: ")
                            Spacer(minLength: 100)
                            Text(String(user.lose))
                        }
                        HStack {
                            Text("Money: ")
                            Spacer(minLength: 100)
                            Text(String(user.money))
                        }
//                        HStack {
//                            Text("Chip: ")
//                            Spacer(minLength: 100)
//                            Text(String(user.chip))
//                        }
                    }
                }
            }
            .navigationTitle("Profile")
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing)
//                {
//
//                }
//            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


struct ProfileImage: View {
    var imageName: String
    
    var body: some View {
        Image(uiImage: UIImage(named:imageName)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
//            .clipShape(Circle())
    }
}
