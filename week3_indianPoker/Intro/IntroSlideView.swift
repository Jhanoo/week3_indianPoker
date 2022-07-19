//
//  IntroSlideView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/19.
//

import SwiftUI

struct IntroSlideView: View {
    var num : Int
    init(_ num : Int) {
        self.num = num
    }
    
    var body: some View {
        VStack{
            Image("Intro_\(num)")
                .resizable()
                .scaledToFit()
                .tag(num)
            Text(Constants.introDescription[num])
                .padding(20)
        }
    }
}

struct IntroSlideView_Previews: PreviewProvider {
    static var previews: some View {
        IntroSlideView(1)
    }
}
