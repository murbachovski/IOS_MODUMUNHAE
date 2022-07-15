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


class CustomEmailView: UIView, UITextFieldDelegate{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate:ShowDropDelegate?
    
    var isEmailMode:Bool = false
    
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
          
//            containerView.layer.borderWidth = 1
//            containerView.layer.borderColor = UIColor.black.cgColor
//            containerView.layer.cornerRadius = 10
            
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            textField.leftViewMode = .always
            textField.autocorrectionType = .no

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
        
        if isEmailMode == true && string == "@" {
            print("@추가되어 키보드 내림")
            textField.resignFirstResponder()
            self.delegate?.showDrop()
        }
        if let count = textField.text?.count , count > 10 {
            errorInTextField()
            return true
        }
        normalInTextField()
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
}
