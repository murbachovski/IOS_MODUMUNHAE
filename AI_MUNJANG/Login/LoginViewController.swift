//
//  LoginViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import UIKit
import DropDown

class LoginViewController: UIViewController, ShowDropDelegate, CheckEmailAndPasswordValid {
   
    
    
    let dropdown = DropDown()
    

    @IBOutlet weak var closeButton: UIButton! //버튼 이미지에서 텍스트 사라지지 않는 Xcode버그로 인해 추가
    @IBOutlet weak var emailContainerView: CustomEmailView!
    @IBOutlet weak var passwordContainerView: CustomPasswordView!
    
    @IBOutlet weak var loginButtonView: CustomButtonView!
    @IBOutlet weak var appleLoginButtonView: CustomButtonView!
    

    @IBAction func clickedClosedButton(_ sender: Any) {
        print("clicked closedButton")
        self.dismiss(animated: true)
        
    }
  

    
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        
        setupUI()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initDropDownUI()
        setDropdown()
    }
 
    fileprivate func setupUI() {
    
        
        emailContainerView.delegate = self
        emailContainerView.checkEmailDelegate = self
        emailContainerView.textField.keyboardType = .emailAddress
        
        passwordContainerView.textField.isSecureTextEntry = true
        passwordContainerView.textField.enablePasswordToggle()
        passwordContainerView.checkEmailDelegate = self
        
        
        appleLoginButtonView.button.layer.cornerRadius = 8
        appleLoginButtonView.button.setTitle("  Apple 계정으로 로그인", for: .normal)
        appleLoginButtonView.button.setImage(UIImage(named: "Apple Logo"), for: .normal)
        appleLoginButtonView.button.backgroundColor = .black
        appleLoginButtonView.buttonCompletion {
            self.clickedByAppleUser()            
        }
        
        
        loginButtonView.button.layer.cornerRadius = 8
        loginButtonView.button.setTitle("로그인", for: .normal)

        loginButtonView.convertButtonStatus(status: false, backgroundColor: .lightGray, titleColor: .darkGray)
        loginButtonView.buttonCompletion {
            self.clickedByEmailUser()
        }
    }
    
    func initDropDownUI(){
        // DropDown View의 배경
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
    }
    
    func setDropdown() {
        // dataSource로 ItemList를 연결
        let itemList_added = itemList.map{ "\(emailContainerView.textField!.text ?? "")\($0)" }

        
        dropdown.dataSource = itemList_added
        
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.emailContainerView.containerView
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: 40)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.emailContainerView.textField.text = item
            
        }
        
        // 취소 시 처리
        dropdown.cancelAction = { [weak self] in
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
           
        }
    }
    
    func showDrop() {
        dropdown.show() // 아이템 팝업을 보여준다.
    }
    
    func checkEmailAndPasswordValid() {
        print("checkEmailAndPasswordValid is called")
        //Email의
        if emailContainerView.isValidStatus == true && passwordContainerView.isValidStatus == true {
            loginButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
        }else{
            loginButtonView.convertButtonStatus(status: false, backgroundColor: .lightGray, titleColor: .darkGray)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        
        //이메일과 비밀번호가 정상적으로 입력되었는지 판단하여 이메일 버튼 활성화 여부 판단
        checkEmailAndPassword()
    }
    
    fileprivate func checkEmailAndPassword(){
        if let emailError = emailContainerView.label.text, emailError.count == 0, let passwordError = passwordContainerView.noticeLabel.text, passwordError.count == 0  {
            if emailContainerView.textField.text?.count ?? -1 > 0 && passwordContainerView.textField.text?.count ?? -1 > 7 {
                loginButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
                }
            }
    }
    
    
    
    fileprivate func clickedByAppleUser(){
        print("appleloginbutton is clicked")
    }
    
    fileprivate func clickedByEmailUser(){
        print("EmailUser is clicked")
    }
    
    
     
    
}
