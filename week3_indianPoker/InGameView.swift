//
//  InGameView.swift
//  week3_indianPoker
//
//  Created by Chanwoo on 2022/07/18.
//

import SwiftUI

struct InGameView: View {
    @State private var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
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
                Spacer()
            }
            
        }.onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
    }
}

struct InGameView_Previews: PreviewProvider {
    static var previews: some View {
        InGameView()
    }
}

