//
//  SignUpViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit
import DropDown

class SignUpViewController: UIViewController, ShowDropDelegate, CheckEmailAndPasswordValid, CheckConfirmPassword {
 
    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    var currentTextField: UITextField?
    
    let dropdown = DropDown()
    

    @IBOutlet weak var emailView: CustomEmailView!
    
    @IBOutlet weak var passwordView: CustomPasswordView!
    
    @IBOutlet weak var passwordConfirmView: CustomPasswordView!
    
    @IBOutlet weak var nicknameView: CustomTextField!
    
    
    @IBOutlet weak var registerView: CustomButtonView!
    var isValidConfirmPassword = false
    
    
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initDropDownUI()
        setDropdown()
    }

    fileprivate func setupUI() {
        
        setupTitleOfNavibar(self: self, title: "회원가입")
        
        emailView.delegate = self
        emailView.checkEmailDelegate = self
        emailView.textField.keyboardType = .emailAddress
        emailView.subLabel.text = "비밀번호 찾기에 이용되니 정확히 입력해주세요."
        emailView.subLabel.textColor = .lightGray
        
        
        passwordView.textField.isSecureTextEntry = true
        passwordView.textField.textContentType = .oneTimeCode
        passwordView.textField.enablePasswordToggle()
        passwordView.checkEmailDelegate = self
        passwordView.noticeLabel.text = "영문,숫자,기호를 모두 조합하여 8~12자로 입력해주세요."
        
        passwordConfirmView.textField.isSecureTextEntry = true
        passwordConfirmView.textField.textContentType = .oneTimeCode
        passwordConfirmView.textField.enablePasswordToggle()
        passwordConfirmView.isConfirmPasswordView = true
        passwordConfirmView.checkEmailDelegate = self
        passwordConfirmView.checkConfirmPasswordDelegate = self
        passwordConfirmView.titleLabel.text = "비밀번호 재확인"
                
        registerView.button.layer.cornerRadius = 8
        registerView.button.setTitle("회원가입", for: .normal)
        registerView.button.backgroundColor = .lightGray
        registerView.buttonCompletion {
            self.clickedRegisterButton()
        }
        
        nicknameView.textField.placeholder = "이름 또는 닉네임을 입력해주세요."
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
        let itemList_added = itemList.map{ "\(emailView.textField!.text ?? "")\($0)" }

        
        dropdown.dataSource = itemList_added
        
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.emailView.containerView
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: 40)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.emailView.textField.text = item
            
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
        checkConfirmPassword()
        print("checkEmailAndPasswordValid is called")
        
    }
    
  
    
    fileprivate func checkEmailAndPassword(){
        if let emailError = emailView.subLabel.text, emailError.count == 0, let passwordError = passwordView.noticeLabel.text, passwordError.count == 0  {
            if emailView.textField.text?.count ?? -1 > 0 && passwordView.textField.text?.count ?? -1 > 7 {
                registerView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
                }
            }
    }
        
        
    
    
    func checkConfirmPassword(){
        print("checkConfirmPassword is called")
        if let password1 = passwordView.textField.text,password1.count > 0 , let password2 = passwordConfirmView.textField.text, password2.count > 0 {
            if password1 == password2 {
                isValidConfirmPassword = true
                passwordConfirmView.okInConfirmPassword()
            }else{
                isValidConfirmPassword = false
                passwordConfirmView.errorInConfirmPassword(errorMessage: "비밀번호가 일치하지 않습니다.")
                
            }
        }else{
            isValidConfirmPassword = false
        }
        
        //비밀번호 재확인이 있기 때문에 로그인 로직과 달리 비밀번호를 비교하는 로직 필요
        if isValidConfirmPassword == true {
            //Email의
            if emailView.isValidStatus == true && passwordView.isValidStatus == true && passwordConfirmView.isValidStatus == true {
                registerView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
            }
        } else{
            registerView.convertButtonStatus(status: false, backgroundColor: .lightGray, titleColor: .darkGray)
        }

    }
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        self.view.frame.origin.y = 0
        //이메일과 비밀번호가 정상적으로 입력되었는지 판단하여 이메일 버튼 활성화 여부 판단
        checkConfirmPassword()
    }

    fileprivate func clickedRegisterButton(){
        
        var userEmailToSignUp = ""
        var userPasswordToSigUp = ""
        guard let userEmail = emailView.textField.text, let userPassword = passwordView.textField.text else {return}
        userEmailToSignUp = userEmail
        userPasswordToSigUp = userPassword
        
        if let nickName = nicknameView.textField.text , nickName.count > 0 {
            print("userNickname is :: \(nickName)")
            //TODO: 추후에 로컬에 저장하자
            
        }
    }
    
 
    @objc func keyboardWillShow(notification: NSNotification){
        print("keyboardWillShow")
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let borderLimitY = keyboardFrame.cgRectValue.minY
        let  bottomTextView = nicknameView.frame.maxY
        
        print(borderLimitY, bottomTextView)
        //활성화된 텍스트필드가 이름필드인지 확인 필요
        if borderLimitY < bottomTextView  && nicknameView.isActive == true {
            let diff = bottomTextView - borderLimitY
            self.view.frame.origin.y = -diff - 4
        }else{
            self.view.frame.origin.y = 0
        }
       
    }

}
