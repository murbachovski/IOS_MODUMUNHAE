//
//  CustomEmailView.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/12.
//

import UIKit

protocol ShowDropDelegate: AnyObject {
    func showDrop()
}

protocol CheckEmailAndPasswordValid: AnyObject {
    func checkEmailAndPasswordValid()
}

class CustomEmailView: UIView, UITextFieldDelegate{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate:ShowDropDelegate?
    weak var checkEmailDelegate:CheckEmailAndPasswordValid?
    
    
    var isValidStatus = false
    
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
        if let view = Bundle.main.loadNibNamed("CustomEmailView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
            
            textField.delegate = self
            
            
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            textField.leftViewMode = .always
            textField.autocorrectionType = .no
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)

        }
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.blue.cgColor
    }
    
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    func textFieldDidEndEditing(_ textField: UITextField){
        containerView.layer.borderColor = UIColor.black.cgColor
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
        
        if newString.contains("@") {
            print("@추가되어 키보드 내림")
            textField.resignFirstResponder()
            self.delegate?.showDrop()
            isValidStatus = true
        }else{
            isValidStatus = false
        }
        self.checkEmailDelegate?.checkEmailAndPasswordValid()
        
        if newString.count > 10 {
            errorInTextField()
            return true
        }
        normalInTextField()
        
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isValidStatus = false
        self.checkEmailDelegate?.checkEmailAndPasswordValid()
        return true
    }
    
    func errorInTextField(){
        containerView.layer.borderColor = UIColor.red.cgColor
        label.textColor = .red
        label.text = "오류 메시지 텍스트"
    }
    
    func normalInTextField(){
        containerView.layer.borderColor = UIColor.blue.cgColor
        label.textColor = .black
//        label.text = "비밀번호 찾기에 이용되니 정확히 입력해주세요."
    }
    
    func setupTextOfLabel(title:String){
        label.text = title
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        
        //이메일의 입력된 내용 중 @가 있다면 isValidStatus를 true
        if ((textField.text?.contains("@")) != nil){
            isValidStatus = true
        }
    }
}

