//
//  IntroView().swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct IntroView: View {
    @State private var endIntro = false
    @State private var pageNum = 1
    private let numberOfPages = 13
    
    var body: some View {
        if (endIntro) {
            LoginView()
                .onOpenURL { url in
                    // 커스텀 URL 스킴 처리
                    // 앱으로 돌아오기 위한 url
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        } else {
            GeometryReader{ proxy in
                VStack {
                    TabView {
                        ForEach(1..<numberOfPages+1) { num in
                            IntroSlideView(num)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}


