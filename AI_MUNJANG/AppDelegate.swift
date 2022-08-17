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
import FirebaseStorage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    var remoteConfig:  RemoteConfig?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase 초기화
        FirebaseApp.configure()
        
        UserDefaults.standard.register(defaults: ["versionNumber" : 1000])
        
        checkTheVersion()
        
        
        //파이어베이스 원격구성
        fetchFirebaseConfig()
    
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


    func fetchFirebaseConfig () {
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
            let returnValue = self.remoteConfig!["versionNumber"].numberValue
            print("remote_config:\(returnValue)")
            UserDefaults.standard.set(returnValue, forKey: "versionNumber")
//            print(UserDefaults.standard.integer(forKey: "versionNumber"))
        }
    }

}
func checkTheVersion() {
        //
        var urlString = "http://127.0.0.1:5000/version_number"
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            print(encodedString)
            urlString = encodedString
        }
    
        let newUrl = URL(string: urlString)
        var request = URLRequest(url: newUrl!)
        
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))

            return
          }

            let str = String(decoding: data, as: UTF8.self)
                   print("결과물: \(str)")
            
            var dicData : Dictionary<String, Any> = [String : Any]()
                    do {
                        // 딕셔너리에 데이터 저장 실시
                        dicData = try JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as! [String:Any]
                        print("리턴된 버전값:\(String(describing: dicData["version_number"]!))")
                    } catch {
                        print(error.localizedDescription)
                    }
        }
        task.resume()
}

//회원탈퇴 및
//로그아웃 로직 구현 할 것

//둘러보기_ 사용자의 회원가입 여부로 판단해야 할듯.
//구독 여부와 _둘러보기 판단할 것
