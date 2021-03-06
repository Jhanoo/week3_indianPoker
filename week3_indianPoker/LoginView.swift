//
//  LoginView.swift
//  week3_indianPoker
//
//  Created by 남유성 on 2022/07/17.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

struct LoginView: View {
//    @AppStorage("userId") var userId = (UserDefaults.standard.string(forKey: "userId") ?? "")
//    @AppStorage("username") var username = (UserDefaults.standard.string(forKey: "username") ?? "")
//    @AppStorage("userProfile") var userProfile = (UserDefaults.standard.string(forKey: "userProfile") ?? "")
    @State private var needLogin: Bool = true
    @State private var login: Bool = false
    @State private var kakaoLogin: Bool = false
    @State private var guest: Bool = false
    
    var body: some View {
        if (needLogin) {
            NavigationView{
                VStack {
//                    Button {
//                        guest = true
//                        needLogin = false
//                    } label: {
//                        Text("게스트로 접속")
//                    }
//                    .frame(width: 300, height: 10)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(5.0)
//                    .padding(.bottom, 20)
                    
//                    Button {
//                        login = true
//                        needLogin = false
//                    } label : {
//                        Text("계정으로 로그인")
//                    }
//                    .frame(width: 300, height: 10)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(5.0)
//                    .padding(.bottom, 20)
//
//                    NavigationLink(destination: LoginView(), isActive: $login) {
//                        EmptyView()
//                    }
                    
                    Button {
                        // 카카오톡 설치 여부
                        if (UserApi.isKakaoTalkLoginAvailable()) {
                            // 카카오톡으로 로그인
                            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                                if let error = error {
                                    print("⛔️ can not login with Kakao")
                                    print(error)
                                } else {
                                    print("✅ loginWithKakaoTalk() success")
                                    UserApi.shared.me { tmpUser, Error in
                                        let user = User(id: String((tmpUser?.id)!), name: (tmpUser?.kakaoAccount?.profile?.nickname)!, profileImg : "\(String(describing: (tmpUser?.kakaoAccount?.profile?.profileImageUrl)!))")
                                        // 내부 저장소 저장
                                        saveAppStorage(user)
                                        // 전역 변수 저장
                                        Constants.user = user
                                        // 서버로 전송
                                        let userData = try? JSONEncoder().encode(user)
                                        let jsonString = String(data: userData!, encoding: .utf8)
                                        request("/auth/signup", "POST", ["user": jsonString as Any]) { (success, data) in
                                            let output = try? JSONDecoder().decode(Response.self, from: data as! Data)
                                            kakaoLogin = true
                                            needLogin = false
                                        }
                                    }
                                }
                            }
                        } else {
                            // 카카오 계정으로 로그인
                            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                                if let error = error {
                                    print("⛔️ can not login with KakaoAcount")
                                    print(error)
                                } else {
                                    print("✅ loginWithKakaoTalkAccount() success")
                                    UserApi.shared.me { tmpUser, Error in
                                        let user = User(id: String((tmpUser?.id)!), name: (tmpUser?.kakaoAccount?.profile?.nickname)!, profileImg : "\(String(describing: (tmpUser?.kakaoAccount?.profile?.profileImageUrl)!))")
                                        // 내부 저장소 저장
                                        saveAppStorage(user)
                                        // 전역 변수 저장
                                        Constants.user = user
                                        // 서버로 전송
                                        let userData = try? JSONEncoder().encode(user)
                                        let jsonString = String(data: userData!, encoding: .utf8)
                                        request("/auth/signup", "POST", ["user": jsonString as Any]) { (success, data) in
                                            let output = try? JSONDecoder().decode(Response.self, from: data as! Data)
                                            kakaoLogin = true
                                            needLogin = false
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Image("kakao_logo")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .padding(12)
                        Spacer()
                        Text("Login with Kakao")
                        Spacer()
                    }
                    .frame(width: 300, height: 20)
                    .padding()
                    .background(Color.kakaoYellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(12.0)
                    .padding(.bottom, 20)
                }
                
            }
        } else if (guest) {
            MainView()
        } else if (kakaoLogin) {
            MainView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
