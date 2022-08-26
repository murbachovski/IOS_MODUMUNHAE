//
//  Coe.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/08/18.
//

import Foundation

class Core {
    static let shared = Core()
    
    //신규 사용자
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    //로그인 여부
    func isUserLogin()-> Bool {
        return UserDefaults.standard.bool(forKey: "isLogin")
    }
    
    func setUserLogin(){
        UserDefaults.standard.set(true, forKey: "isLogin")
    }
    
    func setUserLogout(){
        UserDefaults.standard.set(false, forKey: "isLogin")
    }
    
    //회원가입 여부
    func isUserSignup()-> Bool {
        return UserDefaults.standard.bool(forKey: "isSignup")
    }
    
    func setUserSignup(){
        UserDefaults.standard.set(true, forKey: "isSignup")
    }
    
    func setUserResign(){
        UserDefaults.standard.set(false, forKey: "isSignup")
    }
    
    //구독여부
    func isUserSubscription()-> Bool {
        return UserDefaults.standard.bool(forKey: "isSubscription")
    }
    
    func setUserSubscription(){
        UserDefaults.standard.set(true, forKey: "isSubscription")
    }
    
    func setUserCancelSubscription(){
        UserDefaults.standard.set(false, forKey: "isSubscription")
    }
    
    //애플계정으로 회원 가입 여부
    func isSignupByApple()-> Bool {
        return UserDefaults.standard.bool(forKey: "isSignupByApple")
    }
    
    func setSignupByApple(){
        UserDefaults.standard.set(true, forKey: "isSignupByApple")
        UserDefaults.standard.set(true, forKey: "isSignup")
    }
    
    func setResignByApple(){
        UserDefaults.standard.set(false, forKey: "isSignupByApple")
        UserDefaults.standard.set(false, forKey: "isSignup")
    }
    
    
}
