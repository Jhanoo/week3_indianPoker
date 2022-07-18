//
//  InitView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

var userGlobal : User = User(id: "default")

struct InitView: View {
    @AppStorage("isFirst") var isFirst = UserDefaults.standard.bool(forKey: "isFirst")
    @State private var kakaoTokenValid = false
    var body: some View {
        Group {
            if isFirst {
                IntroView()
            } else if kakaoTokenValid {
                MainView()
//                InGameView()
            } else {
                LoginView()
                    .onOpenURL { url in
                        // 커스텀 URL 스킴 처리
                        // 앱으로 돌아오기 위한 url
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
            }
        }
        .onAppear{
            // 발급받은 토큰 여부 확인
            if (AuthApi.hasToken()) {
                // 토큰 유효성 확인
                UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            // 로그인 필요
                            // 로그인 뷰로 이동
                            print("⛔️ token is not valid")
                            kakaoTokenValid = false
                        }
                        else {
                            //기타 에러
                            print(error)
                            kakaoTokenValid = false
                        }
                    }
                    else {
                        // 토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                        // 메인 뷰로 이동
                        print("✅ token is valid")
                        kakaoTokenValid = true
                        UserApi.shared.me { tmpUser, Error in
                            request("/auth/signin", "POST", ["user": (tmpUser?.id)!]) { (success, data) in
                                print(data)
                                let output = try? JSONDecoder().decode(User.self, from: data as! Data)
                                print(output as Any)
                                Constants.user = output
                                saveAppStorage(output!)
                                kakaoTokenValid = true
                            }
                        }
                    }
                }
                UserDefaults.standard.set(false, forKey: "isFirst")
            } else if (isFirst) {
                // 토큰 없음
                // 로그인 뷰로 이동
                print("⛔️ no tokens")
                kakaoTokenValid = false
                UserDefaults.standard.set(false, forKey: "isFirst")
            } else {
                // 첫 접속
                // 소개 뷰로 이동
                print("😀 First Access")
                kakaoTokenValid = false
                UserDefaults.standard.set(true, forKey: "isFirst")
            }
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
