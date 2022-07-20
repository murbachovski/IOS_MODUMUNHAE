//
//  ResetPasswordViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit
import DropDown

class ResetPasswordViewController: UIViewController , ShowDropDelegate, CheckEmailAndPasswordValid{

    @IBOutlet weak var emailView: CustomEmailView!
    
    @IBOutlet weak var authenticateButtonView: CustomButtonView!
    
    let dropdown = DropDown()
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
 
    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
        
        setupUI()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        initDropDownUI()
        setDropdown()
    }
 
    fileprivate func setupUI() {
    
        
        emailView.delegate = self
        emailView.textField.keyboardType = .emailAddress
        emailView.checkEmailDelegate = self
        emailView.titleLabel.text = "가입한 이메일 주소를 입력해주세요."
        emailView.textField.textContentType = .oneTimeCode
        
        authenticateButtonView.button.layer.cornerRadius = 8
        authenticateButtonView.button.setTitle("인증하기", for: .normal)
        authenticateButtonView.button.backgroundColor = .lightGray
        authenticateButtonView.button.setTitleColor(.white, for: .normal)
        authenticateButtonView.buttonCompletion {
            self.clickedByUser()
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
        print("checkEmailAndPasswordValid is called")
        //Email의
        if emailView.isValidStatus == true  {
            authenticateButtonView.convertButtonStatus(status: true, backgroundColor: hexStringToUIColor(hex: Constants.primaryColor), titleColor: .white)
        }else{
            authenticateButtonView.convertButtonStatus(status: false, backgroundColor: .lightGray, titleColor: .darkGray)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
         print("keyboardWillHide")
        
        //이메일과 비밀번호가 정상적으로 입력되었는지 판단하여 이메일 버튼 활성화 여부 판단
        checkEmailAndPasswordValid()
    }
    

    
    
    fileprivate func clickedByUser(){
        print("appleloginbutton is clicked")
    }
    
    fileprivate func clickedByEmailUser(){
        print("EmailUser is clicked")
    }


}
