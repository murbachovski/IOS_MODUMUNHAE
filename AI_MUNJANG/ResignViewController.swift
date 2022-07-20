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
        
        setupUI()
        
        
        confirmView.checkButtonDelegate = self
        confirmView.checkButton.tag = 1
        confirmView.checkButtonLabel.text = "[필수] 위 내용을 모두 확인했습니다."
        confirmView.checkSubButton.isHidden = true
        
        completionCancelView.checkButtonDelegate = self
        completionCancelView.checkButton.tag = 2
        completionCancelView.checkButtonLabel.text = "[필수] 구독권 해지 완료했습니다."
        completionCancelView.checkSubButton.isHidden = true
    }
    
    func setupUI(){
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.green.cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.textColor = .green
        
        nextButton.layer.cornerRadius = 8
        nextButton.isUserInteractionEnabled = false

    }
    

    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelSubscribeButton(_ sender: Any) {
        goSubscriptionsManager()
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        
    }
    
    @IBAction func clickedNext(_ sender: Any) {
        
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
            nextButton.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        }else {
            nextButton.isUserInteractionEnabled = false
            nextButton.backgroundColor = .lightGray
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






