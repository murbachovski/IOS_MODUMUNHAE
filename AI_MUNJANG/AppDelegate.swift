//
//  AppDelegate.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Firebase 초기화
        FirebaseApp.configure()
        
        if Core.shared.isNewUser(){
            let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            window?.rootViewController = vc
        }
        //onBoarding이 실행된 적이 있다면 일반적인 루틴으로 앱 실행
       
        
        return true
    }




}

