//
//  AppDelegate.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //다크모드해제
        window?.overrideUserInterfaceStyle = .light
        
        //Firebase 초기화
        FirebaseApp.configure()
        UserDefaults.standard.register(defaults: ["versionNumber" : 1000])
        UserDefaults.standard.register(defaults: ["tmpUseCount" : 0])
        
        //둘러보기 사용자를 위한 학습 진행 상황
        UserDefaults.standard.register(defaults: ["tourUserData" : ["1":[]]])
        
        //쿠폰 캠페인 운영중인지 여부
        UserDefaults.standard.register(defaults: ["isCouponeCampaign" : false])
        
        //구독자가 미션 수행중 그만두는 지점을 userDefault에 저장. 실질문해 / 기초문해
        UserDefaults.standard.register(defaults: ["basicStopStep" : ["2":0, "3":0, "4":0, "5":0, "6":0, "7":0, "8":0]])
        
        UserDefaults.standard.register(defaults: ["advancedStopStep" : ["1":0, "2":0]])
        
        //구독여부 판단 - 영수증의 유효성을 판단해야
        InAppProducts.store.checkReceiptValidation(isProduction: true, completion: { _ in})

        let vc = UIStoryboard(name: whichStoryBoard(), bundle: .main).instantiateViewController(withIdentifier: "DownloadViewController") as! DownloadViewController
        window?.rootViewController = vc
        
//        if MyInfo.shared.learningProgress.isEmpty &&  Core.shared.isUserLogin() == true {
//            setUpFireStoreDB()
//        }
        return true
    }
    //앱이 로딩하거나 앱이 다시 화면에 진입시 로그인인 사용자의 userInfo를 갱신
    fileprivate func setUpMyInfoByUserId() {
        if Core.shared.isUserLogin() == true {
            if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                print("applicationDidBecomeActive is called: \(userID)")
                DataFromFirestore.share.gettingDoc(userID: userID) { info in
                    MyInfo.shared.displayName = info.displayName
                    MyInfo.shared.learningProgress = info.learningProgress
                    MyInfo.shared.numberOfHearts = info.numberOfHearts
                    MyInfo.shared.couponID = info.couponID
                    
                    if info.couponID.count > 10 { //couponID가 있다면(10은 임의숫자), 유효기간을 점검한다.
                        checkTheValidateCouponUser(docID: info.couponID)
                    }
                    
                    print("😊😊😊😊😊😊😊applicationDidBecomeActive userInfo: \(MyInfo.shared)")
                }
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        setUpMyInfoByUserId()
    }
  
    //앱이 백그라운드로 들어가기 전에 사용자의 정보(userInfo)를 firebase에 전송
    func applicationWillResignActive(_ application: UIApplication) {
        if Core.shared.isUserLogin() == true {
            if let userID = UserDefaults.standard.value(forKey: "userID") as? String {
                print("applicationWillResignActive is called: \(userID)")
                sendUserInfo(userID: userID)
//                DataFromFirestore.share.settingDoc(userID: userID, userInfo: MyInfo.shared)
                print("😊😊😊😊😊😊😊applicationWillResignActive userInfo: \(MyInfo.shared)")
            }
            
        }
    }
  
    func sendUserInfo(userID: String){
        
        
        let db = Firestore.firestore()
        
        let path = db.collection("users")
        
        path.getDocuments { (snapshot, err) in
            if let err = err {
                print(err)
            } else {
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    if document.documentID == userID {
                        // 딕셔너리 데이터를 가져온다.
                        guard var data = document["userinfo"] as? [String:Any] else { return }
                        data.updateValue(MyInfo.shared.displayName, forKey: "displayName")
                        data.updateValue(MyInfo.shared.learningProgress, forKey: "learningProgress")
                        data.updateValue(MyInfo.shared.numberOfHearts, forKey: "numberOfHearts")
                        data.updateValue(MyInfo.shared.couponID, forKey: "couponID")
                        
                        
                        // 서버의 딕셔너리 데이터를 수정된 데이터로 수정한다.
                        path.document(userID).updateData(["userinfo" : data])
                    }
                }
            }
        }
    }
    
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }
    
}
