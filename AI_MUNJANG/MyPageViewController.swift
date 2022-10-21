//
//  MyPageViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/26.
//

import UIKit
import FirebaseAuth
import StoreKit

class MyPageViewController: UIViewController {
    
    @IBOutlet var editNameTextfield: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton! //구독여부
    @IBOutlet weak var subscribeByCoupon: UIButton!
    
    @IBOutlet weak var resignButton: UIButton!
    
    @IBOutlet weak var manageSubscriptionButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    
    @IBOutlet weak var heartCountView: UIView! //회원가입여부
    
    @IBOutlet weak var heartCountLabel: UILabel!
    
    @IBOutlet weak var restoreSubscriptionButton: UIButton!
    var isReferenceRestore = false
   
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var subscribeContainer: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationItem.title = "My페이지"
        self.navigationItem.backButtonTitle = " "
        
//        InAppProducts.store.requestProducts { success, products in
//            self.monthProduct =  products?.first
//        }
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Core.shared.isUserSubscription(){
            subscribeContainer.isHidden = true
        }else{
            subscribeContainer.isHidden = false
            
            if Core.shared.isCouponeCampaign() == true{
                subscribeByCoupon.isHidden = false
                subscribeButton.setTitle("구독하기", for: .normal)
            }else{
                subscribeByCoupon.isHidden = true
                subscribeButton.setTitle("구독하고 무제한으로 이용하기", for: .normal)
            }
        }
    }
    
    
    @objc func methodOfReceivedNotification(notification:Notification){
        print(notification.userInfo as Any)
        
        if notification.object as! String == InAppProducts.product && isReferenceRestore == true {
            isReferenceRestore = false

            InAppProducts.store.checkReceiptValidation(isProduction: true) { valid in
                    DispatchQueue.main.async {
                        var bodyMessage = ""
                        if valid == true {
                            print("유효")
                            bodyMessage = "구독내역을 정상적으로 복원하였습니다."
                            self.subscribeButton.isHidden = true
                        }else{
                            bodyMessage = "구독내역이 없거나 구독일자가 유효하지 않습니다."
                            self.subscribeButton.isHidden = false
                            print("무효")
                        }
                        self.view.layoutIfNeeded()
                        
                        let alert = AlertService().alert(title: "", body: bodyMessage, cancelTitle: "", confirTitle: "확인", thirdButtonCompletion: nil) {}
                        self.present(alert, animated: true)
                }
            }
        }
        
    }
    
    func setupUI(){
        
        usernameLabel.text = MyInfo.shared.displayName + " 님"
        usernameLabel.font =  UIFont(name: "NanumSquareEB", size: 19)
        
        heartCountView.layer.cornerRadius = 8
        
        heartCountLabel.text = String(MyInfo.shared.numberOfHearts) 
        
        subscribeButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 17)
      
        if Core.shared.isUserLogin() {  //로그인된 경우에 heartCountView를 표시
            heartCountView.isHidden = false
        }else{
            heartCountView.isHidden = true
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
        logoutButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 17)
        
        resignButton.layer.cornerRadius = 8
        resignButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 17)
      
        
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
    
    @IBAction func clickedSubscribeByCoupon(_ sender: Any) {
        
        
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
        print("clicked clickedRestoreSubscription")
        isReferenceRestore = true
        InAppProducts.store.restorePurchases()
    }
    
    @IBAction func clickedHomepage(_ sender: Any) {
        print("clicked homepage")
        guard let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController")  as? HomePageViewController else {return}
        navigationController?.pushViewController(homePageViewController, animated: true)
        
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
    
    
    
    @IBAction func clickedEditButton(_ sender: Any) {
        
        var usernameTextField: UITextField?
        
        let alertController = UIAlertController(
            title: "사용자 이름 변경",
            message: "",
            preferredStyle: .alert)
        
        let changeAction = UIAlertAction(
            title: "변경",
            style: .default) { (action) -> Void in
                if let username = usernameTextField?.text {
                    if username.count > 0 {
                        MyInfo.shared.displayName = username
                        self.usernameLabel.text = username + " 님"
                    }
                    
                } else {
                    print("No Username entered")
                }
            }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel) { (action) -> Void in
        }
         
        alertController.addTextField {
            (txtUsername) -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = MyInfo.shared.displayName
        }
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }

    }
    
