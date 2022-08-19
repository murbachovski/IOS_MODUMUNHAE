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
    var serverVersion = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase 초기화
        FirebaseApp.configure()
        
        UserDefaults.standard.register(defaults: ["versionNumber" : 1000])
        
        //image파일 contents 조회
        _ = QuizContentData.shared.sectionTotal
        
        //구독여부 판단 - 영수증의 유효성을 판단해야
        InAppProducts.store.checkReceiptValidation(isProduction: true, completion: { _ in})
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DownloadViewController") as! DownloadViewController
        window?.rootViewController = vc
        
        

        return true
    }
}
