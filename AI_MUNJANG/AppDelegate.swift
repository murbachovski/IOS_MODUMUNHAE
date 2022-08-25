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
    
        
        //구독여부 판단 - 영수증의 유효성을 판단해야
        InAppProducts.store.checkReceiptValidation(isProduction: true, completion: { _ in})
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DownloadViewController") as! DownloadViewController
        window?.rootViewController = vc
        
        

        return true
    }
    
    //앱이 로딩하거나 앱이 다시 화면에 진입시 로그인인 사용자의 userInfo를 갱신
    func applicationDidBecomeActive(_ application: UIApplication) {
        if Core.shared.isUserLogin() == true {
            if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                print("applicationDidBecomeActive is called: \(userID)")
                DataFromFirestore.share.gettingDoc(userID: userID) { info in
                    MyInfo.shared.displayName = info.displayName
                    MyInfo.shared.learningProgress = info.learningProgress
                    MyInfo.shared.numberOfHearts = info.numberOfHearts
                    
                    print("applicationDidBecomeActive userInfo: \(MyInfo.shared)")
                }
            }
            
        }
    }
  
    //앱이 백그라운드로 들어가기 전에 사용자의 정보(userInfo)를 firebase에 전송
    func applicationWillResignActive(_ application: UIApplication) {
        if Core.shared.isUserLogin() == true {
            if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                print("applicationWillResignActive is called: \(userID)")
                
                DataFromFirestore.share.settingDoc(userID: userID, userInfo: MyInfo.shared)
                print("applicationWillResignActive userInfo: \(MyInfo.shared)")
            }
            
        }
    }
  
}
