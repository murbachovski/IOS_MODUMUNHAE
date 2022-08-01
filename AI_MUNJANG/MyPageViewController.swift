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
    
    @IBOutlet weak var restoreSubscriptionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationItem.title = "My페이지"
        
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Core.shared.isUserSubscription(){
            subscribeButton.isHidden = true
        }else{
            subscribeButton.isHidden = false
        }
    }
    
    @objc func methodOfReceivedNotification(notification:Notification){
        print(notification.userInfo as Any)
        if notification.object as! String == InAppProducts.product{
            
            let alert = AlertService().alert(title: "", body: "구독내역을 정상적으로 조회하였습니다.", cancelTitle: "", confirTitle: "확인")
            present(alert, animated: true)
        }
    }
    
    func setupUI(){
        
      
        if Core.shared.isUserLogin() {  //로그인된 경우에 heartCountView를 표시
            heartCountView.isHidden = false
        }else{
            heartCountView.isHidden = true
        }


        if Core.shared.isUserSubscription() { //구독여부에 따라 구독하기 버튼 노출여부 판단
            manageSubscriptionButton.isHidden = false
        }else{
            manageSubscriptionButton.isHidden = true
        }
        
        if Core.shared.isUserLogin() { //로그인 된 경우만 로그아웃 버튼 노출
            logoutButton.isHidden = false
        }else{
            logoutButton.setTitle("로그인", for: .normal)
        }
        
        if Core.shared.isUserLogin() { //로그인 된 경우에 회원탈퇴 버튼 노출
            resignButton.isHidden = false
        }else{
            resignButton.isHidden = true
        }
        
        
        
        
        logoutButton.layer.cornerRadius = 8
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = hexStringToUIColor(hex: "#DEDEDE").cgColor
        
        
        resignButton.layer.cornerRadius = 8
      
        
        manageSubscriptionButton.layer.cornerRadius = manageSubscriptionButton.frame.size.height / 2
        manageSubscriptionButton.layer.borderWidth = 1
        manageSubscriptionButton.layer.borderColor = hexStringToUIColor(hex: "#04BFB9").cgColor
        
        restoreSubscriptionButton.layer.cornerRadius = restoreSubscriptionButton.frame.size.height / 2
        restoreSubscriptionButton.layer.borderWidth = 1
        restoreSubscriptionButton.layer.borderColor = hexStringToUIColor(hex: "#04BFB9").cgColor
        
        homepageButton.layer.cornerRadius = homepageButton.frame.size.height / 2
        homepageButton.layer.borderWidth = 1
        homepageButton.layer.borderColor = hexStringToUIColor(hex: "#04BFB9").cgColor
    }
    
    @IBAction func clickedSubscribe(_ sender: Any) {
        guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
        subscriptionViewController.modalPresentationStyle = .fullScreen
        present(subscriptionViewController, animated: true)
        
        print("cliocked subscribe")
    }
    
    
    @IBAction func clickedLogout(_ sender: UIButton) {
        if sender.titleLabel?.text != "로그인" {
            let alert = AlertService().alert(title: "", body: "로그아웃 하시겠습니까?", cancelTitle: "취소", confirTitle: "확인", fourthButtonCompletion:  {
                self.callLogout()
            })
            present(alert, animated: true)
        }else{
            changeLoginNC()
        }
        
       
        
    }
    
    @IBAction func clickedResign(_ sender: Any) {
        print("clicked resign")
  
        guard let resignViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResignViewController")  as? ResignViewController else {return}
        navigationController?.pushViewController(resignViewController, animated: true)
        
    }
    
    @IBAction func clickedManageSubscription(_ sender: Any) {
        print("clicked manageSubscription")
        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func clickedRestoreSubscription(_ sender: Any) {
        InAppProducts.store.restorePurchases()
    }
    
    @IBAction func clickedHomepage(_ sender: Any) {
        print("clicked homepage")
        
    }

    func callLogout(){

        print("cliocked logout")
        do{
            try Auth.auth().signOut()
            Core.shared.setUserLogout() //에러가 발생하지 않는다면 정상적으로 로그아웃 처리됨.
            
            changeLoginNC()
        }catch let e as NSError{
            print(e.localizedDescription)
        }

    }
}
