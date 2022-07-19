//
//  CustomPasswordView.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import UIKit

class CustomPasswordView: UIView, UITextFieldDelegate{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var checkEmailDelegate:CheckEmailAndPasswordValid?
    weak var checkConfirmPasswordDelegate:CheckConfirmPassword?

    
    var isValidStatus = false
    var isConfirmPasswordView = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    
    
    //방법 1: loadNibNamed(_:owner:options:) 사용
    func customInit() {
        if let view = Bundle.main.loadNibNamed("CustomPasswordView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
            
            textField.delegate = self
          
            
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            textField.leftViewMode = .always
            textField.autocorrectionType = .no
            textField.rightViewMode = .always
           

        }
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.blue.cgColor
    }
    
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.black.cgColor
        if isConfirmPasswordView == true {
            self.checkConfirmPasswordDelegate?.checkConfirmPassword()
        }
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()

        return true
    }

    // return NO to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        // Range(range, in: text): 갱신된 range값과 기존 string을 가지고 객체 변환: NSRange > Range
       guard let oldString = textField.text, let newRange = Range(range, in: oldString) else { return true }

       // range값과 inputString을 가지고 replacingCharacters(in:with:)을 이용하여 string 업데이트
       let inputString = string.trimmingCharacters(in: .whitespacesAndNewlines)
       let newString = oldString.replacingCharacters(in: newRange, with: inputString)
        
        
        isValidStatus = isValidPassword(password: newString)
        if !isConfirmPasswordView{
            self.checkEmailDelegate?.checkEmailAndPasswordValid()
        }
        
        if newString.count == 0 {
            errorInTextField(errorMessage: "")
        }
        if newString.count <= 7 {
            errorInTextField(errorMessage: "8자 이상 입력해주세요.")
            return true
        }
        
        if newString.count > 12 { //12제한을
            errorInTextField(errorMessage: "12자 이내로 입력해주세요.")
            return true
        }
        
       
        if !isValidStatus && (newString.count > 7 && newString.count <= 12) {
            errorInTextField(errorMessage: "영문, 숫자, 기호를 모두 조합해주세요." )
            return true
        }
        normalInTextField()
        
        
        return true
    }
    
    func errorInTextField(errorMessage:String){
        if isConfirmPasswordView == false {
            containerView.layer.borderColor = UIColor.red.cgColor
            noticeLabel.text = errorMessage
            noticeLabel.textColor = .red
        }
    }
    
    func normalInTextField(){
        noticeLabel.text = ""
    }
    
    func setupTextOfLabel(title:String){
        noticeLabel.text = title
    }
    

    func okInConfirmPassword(){
        noticeLabel.text = ""
        noticeLabel.textColor = .black
    }
    
    func errorInConfirmPassword(errorMessage:String){
        noticeLabel.text = errorMessage
        noticeLabel.textColor = .red
    }
    
}
