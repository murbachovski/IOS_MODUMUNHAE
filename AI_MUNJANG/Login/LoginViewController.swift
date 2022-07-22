//
//  LoginViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import UIKit
import DropDown
import FirebaseAuth

class LoginViewController: UIViewController, ShowDropDelegate, CheckEmailAndPasswordValid {
   
    
    
    let dropdown = DropDown()
    

    @IBOutlet weak var emailContainerView: CustomEmailView!
    @IBOutlet weak var passwordContainerView: CustomPasswordView!
    
    @IBOutlet weak var loginButtonView: CustomButtonView!
    @IBOutlet weak var appleLoginButtonView: CustomButtonView!
    
    @IBOutlet weak var onlyTourButton: UIButton!
    
    @IBOutlet weak var searchPasswordButton: UIButton!
    
    
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        
        if Core.shared.isNewUser() == true{
            onlyTourButton.isHidden = false
            onlyTourButton.layer.cornerRadius = onlyTourButton.frame.size.height / 2
            onlyTourButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            searchPasswordButton.isUserInteractionEnabled = false
        }else{
            searchPasswordButton.isUserInteractionEnabled = true
            onlyTourButton.isHidden = true
        }
        setupUI()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        passwordContainerView.textField.textContentType = .oneTimeCode
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
        if let emailError = emailContainerView.subLabel.text, emailError.count == 0, let passwordError = passwordContainerView.noticeLabel.text, passwordError.count == 0  {
            if emailContainerView.textField.text?.count ?? -1 > 0 && passwordContainerView.textField.text?.count ?? -1 > 7 {
                loginButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
                }
            }
    }
    
    
    
    fileprivate func clickedByAppleUser(){
        print("appleloginbutton is clicked")
        //클릭시 사용자가 애플계정으로 회원가입여부 판단하여 미가입시 약관 페이지로 이동 
    }
    
    fileprivate func clickedByEmailUser(){
        print("EmailUser is clicked")
        guard let email = emailContainerView.textField.text else { return }
        guard let password = passwordContainerView.textField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if error != nil {
                print(error)
            }else{
                print(authResult?.user)
            }
            
        }
    }
    
    @IBAction func searchPasswordButton(_ sender: Any) {
        print("비밀번호 찾기 클릭됨.")
        
        guard let resetPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController")  as? ResetPasswordViewController else {return}
        self.navigationController?.pushViewController(resetPasswordViewController, animated: true)
    }
    
    @IBAction func registerMembershipButton(_ sender: Any) {
        print("회원가입 버튼 클릭됨")
        guard let termsViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermsViewController")  as? TermsViewController else {return}
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    @IBAction func clickedOnlyTourButton(_ sender: Any) {
        print("그냥 구경만 할게요 클릭됨.")
        Core.shared.setIsNotUser()
        changeRootVC(self: self)
        
    }
    
}
