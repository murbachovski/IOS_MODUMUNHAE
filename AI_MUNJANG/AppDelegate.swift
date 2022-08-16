//
//  AppDelegate.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    var remoteConfig:  RemoteConfig?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Firebase 초기화
        FirebaseApp.configure()
        //파이어베이스 원격구성
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        
        remoteConfig?.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.remoteConfig?.activate { changed, error in
              // ...
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
            print("remote_config:\(self.remoteConfig!["versionNumber"].numberValue)")
        }
        
        _ = QuizContentData.shared.sectionTotal
        
        //구독여부 판단 - 영수증의 유효성을 판단해야
        InAppProducts.store.checkReceiptValidation(isProduction: true, completion: { _ in})
        
        if Core.shared.isNewUser(){
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            window?.rootViewController = vc
            return true
        }
        
        if Core.shared.isUserLogin() { //MainPage로 이동
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            window?.rootViewController = vc
            
        }else{ //로그인페이지로 이동
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            window?.rootViewController = vc
            
        }
        //onBoarding이 실행된 적이 있다면 일반적인 루틴으로 앱 실행
       
        
        
        return true
    }




}


//회원탈퇴 및
//로그아웃 로직 구현 할 것

//둘러보기_ 사용자의 회원가입 여부로 판단해야 할듯.
//구독 여부와 _둘러보기 판단할 것
