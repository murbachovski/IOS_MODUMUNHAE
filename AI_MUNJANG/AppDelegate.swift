//
//  AppDelegate.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Firebase 초기화
        FirebaseApp.configure()
        
        
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
