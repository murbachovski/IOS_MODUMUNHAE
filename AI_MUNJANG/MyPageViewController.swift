//
//  MyPageViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/26.
//

import UIKit
import FirebaseAuth

class MyPageViewController: UIViewController {
    

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton! //구독여부
    @IBOutlet weak var resignButton: UIButton!
    
    @IBOutlet weak var manageSubscriptionButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    
    @IBOutlet weak var heartCountView: UIView! //회원가입여부
    
    @IBOutlet weak var heartCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationItem.title = "My페이지"
        
        
        setupUI()
       
        
    }
    
    func setupUI(){
        
      
        if Core.shared.isUserSignup() {  //회원가입여부에 따라 heartCountView를 노출여부 판단
            heartCountView.isHidden = false
        }else{
            heartCountView.isHidden = true
        }


        if Core.shared.isUserSubscription() { //구독여부에 따라 구독하기 버튼 노출여부 판단
            manageSubscriptionButton.isHidden = true
        }else{
            manageSubscriptionButton.isHidden = false
        }
        
        if Core.shared.isUserLogin() { //로그인 된 경우만 로그아웃 버튼 노출
            logoutButton.isHidden = false
        }else{
            logoutButton.isHidden = true
        }
        
        if Core.shared.isUserSignup() { //회원가입된 경우만 회원탈퇴 버튼 노출
            resignButton.isHidden = false
        }else{
            resignButton.isHidden = true
        }
        
        
        
        logoutButton.layer.cornerRadius = 8
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = hexStringToUIColor(hex: "#DEDEDE").cgColor
        
        
        resignButton.layer.cornerRadius = 8
      
        
        manageSubscriptionButton.layer.cornerRadius = 8
        manageSubscriptionButton.layer.borderWidth = 1
        manageSubscriptionButton.layer.borderColor = hexStringToUIColor(hex: "#04BFB9").cgColor
        
        homepageButton.layer.cornerRadius = 8
        homepageButton.layer.borderWidth = 1
        homepageButton.layer.borderColor = hexStringToUIColor(hex: "#04BFB9").cgColor
    }
    
    @IBAction func clickedSubscribe(_ sender: Any) {
        
        print("cliocked subscribe")
    }
    
    
    @IBAction func clickedLogout(_ sender: Any) {
        
        let alert = AlertService().alert(title: "", body: "로그아웃 하시겠습니까?", cancelTitle: "취소", confirTitle: "확인", fourthButtonCompletion:  {
            self.callLogout()
        })
        present(alert, animated: true)
       
        
    }
    
    @IBAction func clickedResign(_ sender: Any) {
        print("clicked resign")
      
//        Auth.auth().currentUser?.delete(completion: { error in
//            if error != nil {
//
//            }else{
//                //정상적으로 회원탈퇴
//                Core.shared.setUserResign()
//                changeLoginNC(self: self)
//            }
//        })
            
        guard let resignViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResignViewController")  as? ResignViewController else {return}
        navigationController?.pushViewController(resignViewController, animated: true)
        
    }
    
    @IBAction func clickedManageSubscription(_ sender: Any) {
        print("clicked manageSubscription")
    }
    
    @IBAction func clickedHomepage(_ sender: Any) {
        print("clicked homepage")
    }

    func callLogout(){
      
        
        print("cliocked logout")
        do{
            try Auth.auth().signOut()
            Core.shared.setUserLogout() //에러가 발생하지 않는다면 정상적으로 로그아웃 처리됨.
            changeLoginNC(self: self)
        }catch let e as NSError{
            print(e.localizedDescription)
        }
      
        
    }
}
