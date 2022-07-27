
//
//  ResignReasonViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit
import FirebaseAuth

class ResignReasonViewController: UIViewController,CheckButtonDelegate {
  
    

    
    @IBOutlet weak var customResignReasonView01: CustomCheckBoxLabel!
    
    @IBOutlet weak var customResignReasonView02: CustomCheckBoxLabel!
    
    @IBOutlet weak var customResignReasonView03: CustomCheckBoxLabel!
    
    @IBOutlet weak var customResignReasonView04: CustomCheckBoxLabel!
    
    @IBOutlet weak var customResignReasonView05: CustomCheckBoxLabel!
    
    @IBOutlet weak var customResignReasonTextView: CustomTextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var reasonToResign:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
    
    
        
        customResignReasonView01.checkButtonDelegate = self
        customResignReasonView01.checkButton.tag = 1
        customResignReasonView02.checkButtonDelegate = self
        customResignReasonView02.checkButton.tag = 2
        customResignReasonView03.checkButtonDelegate = self
        customResignReasonView03.checkButton.tag = 3
        customResignReasonView04.checkButtonDelegate = self
        customResignReasonView04.checkButton.tag = 4
        customResignReasonView05.checkButtonDelegate = self
        customResignReasonView05.checkButton.tag = 5
        
        setupUI()
    }

    fileprivate func setupUI(){
        customResignReasonView01.checkButtonLabel.text = "탈퇴 후 재가입을 하기 위해서"
        customResignReasonView02.checkButtonLabel.text = "자주 이용하지 않아서"
        customResignReasonView03.checkButtonLabel.text = "컨텐츠가 부족해서"
        customResignReasonView04.checkButtonLabel.text = "사용 방법이 어려워서"
        customResignReasonView05.checkButtonLabel.text = "기타"
        
        customResignReasonView01.checkSubButton.isHidden = true
        customResignReasonView02.checkSubButton.isHidden = true
        customResignReasonView03.checkSubButton.isHidden = true
        customResignReasonView04.checkSubButton.isHidden = true
        customResignReasonView05.checkSubButton.isHidden = true
        
        customResignReasonTextView.changePlaceHolder(placeholder: "불편하셨던 점 또는 개선할 점을 알려주세요.")
        customResignReasonTextView.changeRestrictedCharacters(res: 100)
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.green.cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.textColor = .green
        
        nextButton.layer.cornerRadius = 8
        nextButton.isUserInteractionEnabled = false
    }
    

    
    @IBAction func clickedCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clickedNext(_ sender: Any) {
        //사용자가 체크한 항목들을 수집
        collectCheckItem()
        //사용자들이 불편해 했던 부분을 수집
        let userText = collectUsersText()
        print("checkItem: \(reasonToResign), userText: \(userText)")
        
        
        Auth.auth().currentUser?.delete(completion: { [weak self] error in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                
                if Core.shared.isSignupByApple() { //애플계정으로  회원가입한 경우
                    Core.shared.setResignByApple()                    
                }else{
                    //정상적으로 회원탈퇴
                    Core.shared.setUserResign()
                }
                Core.shared.setUserLogout()
                
                let alert = AlertService().alert(title: "", body: "회원탈퇴가 완료되었습니다.", cancelTitle: "", confirTitle: "확인", fourthButtonCompletion: {
                    changeLoginNC(self: self!)
                })
                self!.present(alert, animated: true)
            }
        })
    }
    
    
    
    //회원탈퇴 부분 확인할 것
    
    func checkButtonClicked(_ sender: UIButton) {
        if sender.tag == 1 {
            customResignReasonView01.checkButton.isSelected = !customResignReasonView01.checkButton.isSelected
            isCheckAnyButton()
        }else if sender.tag == 2 {
            customResignReasonView02.checkButton.isSelected = !customResignReasonView02.checkButton.isSelected
            isCheckAnyButton()
        }else if sender.tag == 3 {
            customResignReasonView03.checkButton.isSelected = !customResignReasonView03.checkButton.isSelected
            isCheckAnyButton()
        }else if sender.tag == 4 {
            customResignReasonView04.checkButton.isSelected = !customResignReasonView04.checkButton.isSelected
            isCheckAnyButton()
        }else if sender.tag == 5 {
            customResignReasonView05.checkButton.isSelected = !customResignReasonView05.checkButton.isSelected
            isCheckAnyButton()
        }

    }
    
    func checkSubButtonClicked(_ sender: UIButton) {
        
    }
    
    func isCheckAnyButton(){
        if customResignReasonView01.checkButton.isSelected ||
            customResignReasonView02.checkButton.isSelected ||
            customResignReasonView03.checkButton.isSelected ||
            customResignReasonView04.checkButton.isSelected ||
            customResignReasonView05.checkButton.isSelected {
            
            convertActiveButton(isActive:true)
        }else{
            convertActiveButton(isActive:false)
        }
    }
    
    func convertActiveButton(isActive:Bool){
        
        
        if isActive == true {
            nextButton.isUserInteractionEnabled = true
            nextButton.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        }else{
            nextButton.isUserInteractionEnabled = false
            nextButton.backgroundColor = .lightGray
        }
    }
    
    func collectCheckItem(){
        if customResignReasonView01.checkButton.isSelected {
            reasonToResign.append(1)
        }
        if customResignReasonView02.checkButton.isSelected {
            reasonToResign.append(2)
        }
        if customResignReasonView03.checkButton.isSelected {
            reasonToResign.append(3)
        }
        if customResignReasonView04.checkButton.isSelected {
            reasonToResign.append(4)
        }
        if customResignReasonView05.checkButton.isSelected {
            reasonToResign.append(5)
        }
    }
    
    func collectUsersText()->String {
        guard let userText = customResignReasonTextView.textView.text else {return ""}
        return userText
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        self.view.frame.origin.y = 0 // Move view 150 points upward
        //이메일과 비밀번호가 정상적으로 입력되었는지 판단하여 이메일 버튼 활성화 여부 판단
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        print("keyboardWillShow")
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let borderLimitY = keyboardFrame.cgRectValue.minY
        let  bottomTextView = customResignReasonTextView.frame.maxY
        
        print(borderLimitY, bottomTextView)
        if borderLimitY < bottomTextView {
            let diff = bottomTextView - borderLimitY
            self.view.frame.origin.y = -diff - 4
        }
       
    }
}
