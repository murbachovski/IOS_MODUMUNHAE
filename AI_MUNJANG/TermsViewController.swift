//
//  TermsViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit

class TermsViewController: UIViewController, CheckButtonDelegate {
  
    
    
    
    @IBOutlet weak var allCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var useTermsCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var personalInfoCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var fourteenCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var marketingInfoCheckLabel: CustomCheckBoxLabel!
    
    @IBOutlet weak var nextButton: CustomButtonView!
    
    var isAppleLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }
    
    
    
    fileprivate func setupUI() {
     
        
        
        self.navigationItem.title = "회원가입"
        self.navigationItem.backButtonTitle = ""
        
        
        allCheckLabel.checkButtonLabel.text = "모두 동의합니다."
        allCheckLabel.checkButton.tag = 0
        allCheckLabel.checkSubButton.isHidden = true
        
        useTermsCheckLabel.checkButtonLabel.text = "[필수] 이용약관 동의"
        useTermsCheckLabel.checkButton.tag = 1
        useTermsCheckLabel.checkSubButton.tag = 1
        
        personalInfoCheckLabel.checkButtonLabel.text = "[필수] 개인정보 수집・이용 동의"
        personalInfoCheckLabel.checkButton.tag = 2
        personalInfoCheckLabel.checkSubButton.tag = 2
        
        fourteenCheckLabel.checkButtonLabel.text = "[필수] 14세 이상입니다"
        fourteenCheckLabel.checkButton.tag = 3
        fourteenCheckLabel.checkSubButton.tag = 3
        
        marketingInfoCheckLabel.checkButtonLabel.text = "[선택] 마케팅 정보 수신 동의"
        marketingInfoCheckLabel.checkButton.tag = 4
        marketingInfoCheckLabel.checkSubButton.tag = 4
        
        nextButton.button.setTitle("다음", for: .normal)
        nextButton.button.titleLabel?.font = UIFont(name: "NanumSquareB", size: 20)
        nextButton.convertButtonStatus(status: true, backgroundColor: .lightGray, titleColor: .white)
        nextButton.button.layer.cornerRadius = 8
        nextButton.buttonCompletion {            
            self.clickedNextButton()
        }
        
        
        allCheckLabel.checkButtonDelegate = self
        useTermsCheckLabel.checkButtonDelegate = self
        personalInfoCheckLabel.checkButtonDelegate = self
        fourteenCheckLabel.checkButtonDelegate = self
        marketingInfoCheckLabel.checkButtonDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func checkButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            if sender.isSelected == true {
                useTermsCheckLabel.checkButton.isSelected = false
                personalInfoCheckLabel.checkButton.isSelected = false
                fourteenCheckLabel.checkButton.isSelected = false
                marketingInfoCheckLabel.checkButton.isSelected = false
                allCheckLabel.checkButton.isSelected = false
            }else {
                useTermsCheckLabel.checkButton.isSelected = true
                personalInfoCheckLabel.checkButton.isSelected = true
                fourteenCheckLabel.checkButton.isSelected = true
                marketingInfoCheckLabel.checkButton.isSelected = true
                allCheckLabel.checkButton.isSelected = true
            }
            
        }else if sender.tag == 1 {
            useTermsCheckLabel.checkButton.isSelected = !useTermsCheckLabel.checkButton.isSelected
        }else if sender.tag == 2 {
            personalInfoCheckLabel.checkButton.isSelected = !personalInfoCheckLabel.checkButton.isSelected
        }else if sender.tag == 3 {
            fourteenCheckLabel.checkButton.isSelected = !fourteenCheckLabel.checkButton.isSelected
        }else if sender.tag == 4 {
            marketingInfoCheckLabel.checkButton.isSelected = !marketingInfoCheckLabel.checkButton.isSelected
        }
        
        //모두 동의 버튼 활성화여부 판단
        if useTermsCheckLabel.checkButton.isSelected && personalInfoCheckLabel.checkButton.isSelected && fourteenCheckLabel.checkButton.isSelected && marketingInfoCheckLabel.checkButton.isSelected {
            allCheckLabel.checkButton.isSelected = true
        }
        
        if useTermsCheckLabel.checkButton.isSelected == false || personalInfoCheckLabel.checkButton.isSelected  == false || fourteenCheckLabel.checkButton.isSelected == false || marketingInfoCheckLabel.checkButton.isSelected == false {
            allCheckLabel.checkButton.isSelected = false
        }
        
        //다음버튼 활성화 여부 판단
        if useTermsCheckLabel.checkButton.isSelected && personalInfoCheckLabel.checkButton.isSelected && fourteenCheckLabel.checkButton.isSelected {
            nextButton.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
        }else{
            nextButton.convertButtonStatus(status: true, backgroundColor: .lightGray, titleColor: .white)
        }
    }

    func checkSubButtonClicked(_ sender: UIButton) {
        var titleOfLabel = ""
            
        if sender.tag == 1 {
            titleOfLabel = "이용약관"
        }else if sender.tag == 2 {
            titleOfLabel = "개인정보 수집・이용"
        }else if sender.tag == 3 {
            titleOfLabel = "14세 이상"
        }else if sender.tag == 4 {
            titleOfLabel = "마케팅 정보 수신"
        }
        
        let termsDetailViewController = storyboard?.instantiateViewController(withIdentifier: "TermsDetailViewController") as! TermsDetailViewController
        termsDetailViewController.modalPresentationStyle = .fullScreen
        termsDetailViewController.titleOfLabel = titleOfLabel
        present(termsDetailViewController, animated: true)
    }

    func clickedNextButton(){
        
        //출발점이 애플로그인 버튼인지 회원가입 버튼(이메일)인지를 판단하여
        //애플로그인인 경우는 애플 라이브러리를 통해 회원가입,
        //회원가입 로그인인 경우는 다음 단계로 이동
        
        if isAppleLogin == true {
            
        }else{
            let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
        
    }
    
}
