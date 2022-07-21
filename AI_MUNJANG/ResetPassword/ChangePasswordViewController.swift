//
//  ChangePasswordViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/20.
//

import UIKit

class ChangePasswordViewController: UIViewController,CheckConfirmPassword {
  
    
    @IBAction func clickedClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var currentPasswordView: CustomPasswordView!
    
    @IBOutlet weak var newPasswordView: CustomPasswordView!
    
    @IBOutlet weak var newConfirmPasswordView: CustomPasswordView!
    
    @IBOutlet weak var completionButtonView: CustomButtonView!
    
    var isValidConfirmPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        currentPasswordView.textField.isSecureTextEntry = true
        currentPasswordView.textField.textContentType = .oneTimeCode
        currentPasswordView.textField.enablePasswordToggle()
        currentPasswordView.titleLabel.text = "현재 비밀번호"
        
        newPasswordView.textField.isSecureTextEntry = true
        newPasswordView.textField.textContentType = .oneTimeCode
        newPasswordView.textField.enablePasswordToggle()
        newPasswordView.titleLabel.text = "새 비밀번호"
        
        newConfirmPasswordView.textField.isSecureTextEntry = true
        newConfirmPasswordView.textField.textContentType = .oneTimeCode
        newConfirmPasswordView.textField.enablePasswordToggle()
        newConfirmPasswordView.titleLabel.text = "새 비밀번호 재확인"
        newConfirmPasswordView.checkConfirmPasswordDelegate = self
        newConfirmPasswordView.isConfirmPasswordView = true
        
        completionButtonView.button.layer.cornerRadius = 8
        completionButtonView.button.setTitle("회원가입", for: .normal)
        completionButtonView.button.backgroundColor = .lightGray
        completionButtonView.buttonCompletion {
            self.clickedCompletionButton()
        }
        
    }
    
    
   
    func checkConfirmPassword(){
        print("😀checkConfirmPassword")
        if let password1 = newPasswordView.textField.text,password1.count > 0 , let password2 = newConfirmPasswordView.textField.text, password2.count > 0 {
            if password1 == password2 {
                isValidConfirmPassword = true
                newConfirmPasswordView.okInConfirmPassword()
            }else{
                isValidConfirmPassword = false
                newConfirmPasswordView.errorInConfirmPassword(errorMessage: "비밀번호가 일치하지 않습니다.")
                
            }
        }else{
            isValidConfirmPassword = false
        }
        
        //비밀번호 재확인이 있기 때문에 로그인 로직과 달리 비밀번호를 비교하는 로직 필요
        if isValidConfirmPassword == true {
            //Email의
            if newPasswordView.isValidStatus == true && newConfirmPasswordView.isValidStatus == true {
                completionButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
            }
        } else{
            completionButtonView.convertButtonStatus(status: false, backgroundColor: .lightGray, titleColor: .darkGray)
        }

    }
    
    func clickedCompletionButton(){
        print("clickedCompletionButton is called")
    }

    @IBAction func clickedResetPasswordButton(_ sender: Any) {
        
        print("비밀번호 재설정 화면으로 이동")
    }
}



