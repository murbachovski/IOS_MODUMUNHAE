//
//  CommonUIViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/12.
//

import UIKit
import DropDown


class CommonUIViewController: UIViewController,ShowDropDelegate {
    func showDrop() {
        dropdown.show() // 아이템 팝업을 보여준다.
    }
    

    @IBOutlet weak var customBV: CustomButtonView!
    @IBOutlet weak var customBV2: CustomButtonView!
    
    @IBAction func clickedDrop(_ sender: Any) {
        dropdown.show() // 아이템 팝업을 보여준다.
    }
    @IBOutlet weak var emailTextField: CustomTextFieldView!
    
    let dropdown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        //1. 공통UI 중 하나인 버튼이 활성화된 경우, 클릭 이벤트는 completion 핸들러를 통해 받아온다.
        customBV.convertButtonStatus(status: true, title: "다음") {
            print("button is clicked")
        }
        
        //2. 공통UI 중 하나인 버튼이 비활성화된 경우
        customBV2.convertButtonStatus(status: false, title: "네이버로그인", completion: {})
        
        emailTextField.setupTextOfLabel(title: "이메일을 입력해주세요")
        emailTextField.isEmailMode = true
        emailTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initUI()
        setDropdown()
    }
    
    var itemList = ["@naver.com","@hanmail.com","@daum.net","@gmail.com","@nate.com","@hotmail.com","@outlook.com","@icloud.com","@yahoo.com",
                "@lycos.co.kr","@dreamwiz.com","@empal.com","@korea.com","@paran.com","@empas.com","@me.com","@chol.com"]
    
    func initUI() {
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
        let itemList_added = itemList.map{ "\(emailTextField.textField!.text ?? "")\($0)" }

        
        dropdown.dataSource = itemList_added
        
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.emailTextField.containerView
        
        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: 60)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self?.emailTextField.textField.text = item
            
        }
        
        // 취소 시 처리
        dropdown.cancelAction = { [weak self] in
            //빈 화면 터치 시 DropDown이 사라지고 아이콘을 원래대로 변경
           
        }
    }
     


}
