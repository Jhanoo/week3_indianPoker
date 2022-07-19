//
//  IntroSlideView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/19.
//

import SwiftUI

struct IntroSlideView: View {
    @Binding private var endIntro : Bool
    var num : Int
    var pages : Int
    
    init(_ num : Int, _ pages : Int, _ endIntro : Binding<Bool>) {
        self.num = num
        self.pages = pages
        self._endIntro = endIntro
    }
    
    var body: some View {
        if endIntro {
            LoginView()
        } else {
            VStack{
                Image("Intro_\(num)")
                    .resizable()
                    .scaledToFit()
                    .tag(num)
                Text(Constants.introDescription[num-1])
                    .padding(20)
                if num == pages {
                    Button {
                        endIntro = true
                    } label: {
                        Text("로그인하러 가기!")
                    }
                    .frame(width: 300, height: 20)
                    .background(Color.kakaoYellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(12.0)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
