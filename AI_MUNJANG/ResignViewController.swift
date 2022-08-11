//
//  ResignViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit

class ResignViewController: UIViewController, CheckButtonDelegate {
   
    
    @IBOutlet weak var userTitle: UILabel! //사용자명 변경 필요
    
    @IBOutlet weak var noticeToUserLabel: UILabel! //사용자명과 하트개수 변경 필요
    
    @IBOutlet weak var confirmView: CustomCheckBoxLabel!
    
    @IBOutlet weak var completionCancelView: CustomCheckBoxLabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "탈퇴하기"
        self.navigationItem.backButtonTitle = " "
        
        
        
        let username = "막길동"
        userTitle.text = "\(username)님, 탈퇴 전 꼭 확인해주세요!"
        userTitle.font =  UIFont(name: "NanumSquareEB", size: 19)
        
        
        let userHeartCount = 10
        let userHeartCountText = "하트 \(userHeartCount)개"
        noticeToUserLabel.text = "- 탈퇴 시 홍길동님의 \(userHeartCountText)는 모두 삭제되며, 다시 가입해도 복구되지 않습니다.\n\n- 회원 탈퇴와 구독권 해지는 별도로 진행되므로 반드시 회원 탈퇴 전 구독권을 해지해 주세요."
        //전체적으로 폰트 적용
        let attStringSub = NSMutableAttributedString(string: noticeToUserLabel.text!)
        let normalFont: UIFont =  UIFont(name: "NanumSquareR", size: 15)!
        attStringSub.addAttribute(NSAttributedString.Key.font, value: normalFont, range: NSMakeRange(0, attStringSub.length))
        
        //행간 조정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attStringSub.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attStringSub.length))
        
        //강조 폰트 적용
        let accentFont: UIFont =  UIFont(name: "NanumSquareEB", size: 17)!
        let totalText:NSString = NSString(string: noticeToUserLabel.text!)
        let theRange = totalText.range(of: userHeartCountText)
        attStringSub.addAttribute(NSAttributedString.Key.font, value: accentFont, range: theRange)
        
        noticeToUserLabel.attributedText = attStringSub
      

        
        confirmView.checkButtonDelegate = self
        confirmView.checkButton.tag = 1
        confirmView.checkButtonLabel.text = "[필수] 위 내용을 모두 확인했습니다."
        confirmView.checkSubButton.isHidden = true
        
        completionCancelView.checkButtonDelegate = self
        completionCancelView.checkButton.tag = 2
        completionCancelView.checkButtonLabel.text = "[필수] 구독권 해지 완료했습니다."
        completionCancelView.checkSubButton.isHidden = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI(){
        
        
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.font =  UIFont(name: "NanumSquareEB", size: 17)
        cancelButton.titleLabel?.textColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        
        nextButton.layer.cornerRadius = 8
        nextButton.isUserInteractionEnabled = false
        nextButton.titleLabel?.font =  UIFont(name: "NanumSquareEB", size: 17)
        nextButton.setTitleColor(.lightGray, for: .normal)
        nextButton.backgroundColor = hexStringToUIColor(hex: Constants.inActive_status)
                                    
    }
    

    @IBAction func cancelSubscribeButton(_ sender: Any) {
        //실제 기기에서만 연동됨.
        goSubscriptionsManager()
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedNext(_ sender: Any) {
        guard let resignReasonViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResignReasonViewController")  as? ResignReasonViewController else {return}
        navigationController?.pushViewController(resignReasonViewController, animated: true)
    }
    
    
    func checkButtonClicked(_ sender: UIButton) {
        
        print("😀checkButtonClicked is called")
        
        if sender.tag == 1 {
            confirmView.checkButton.isSelected = !confirmView.checkButton.isSelected
            isAllChecked()
        }else if sender.tag == 2 {
            completionCancelView.checkButton.isSelected = !completionCancelView.checkButton.isSelected
            isAllChecked()
        }
    }
    
    func isAllChecked(){
        if confirmView.checkButton.isSelected && completionCancelView.checkButton.isSelected {
            convertActiveButton(isActive: true)
        }else{
            convertActiveButton(isActive: false)
        }
    }
    
    func convertActiveButton(isActive:Bool){
        if isActive == true {
            nextButton.isUserInteractionEnabled = true
            nextButton.setTitleColor(.white, for: .normal)
            nextButton.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        }else {
            nextButton.isUserInteractionEnabled = false
            nextButton.setTitleColor(.lightGray, for: .normal)
            nextButton.backgroundColor = hexStringToUIColor(hex: Constants.inActive_status)
        }
        
    }
    
    func checkSubButtonClicked(_ sender: UIButton) {
        print("😀checkSubButtonClicked is called")
        if sender.tag == 1 {
            
        }else if sender.tag == 2 {
            
        }
    }
    
   func goSubscriptionsManager() {
       
       if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:])
           }
       }

   }
    
}






