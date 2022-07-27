//
//  CustomCheckBoxLabel.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit
protocol CheckButtonDelegate: AnyObject {
    func checkButtonClicked(_ sender:UIButton)
    func checkSubButtonClicked(_ sender:UIButton)
}

class CustomCheckBoxLabel: UIView {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var checkButtonLabel: UILabel!
    @IBOutlet weak var checkSubButton: UIButton!
    var isCheckedBox = false
    weak var checkButtonDelegate:CheckButtonDelegate?
    
    
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
        if let view = Bundle.main.loadNibNamed("CustomCheckBoxLabel", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            checkButton.tintColor = .darkGray
            
            addSubview(view)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(tapGestureRecognizer:)))
            checkButtonLabel.addGestureRecognizer(tapGesture)
            checkButtonLabel.isUserInteractionEnabled = true
            
        }
    }
    
    @objc func tappedLabel(tapGestureRecognizer: UITapGestureRecognizer) {
      // do stuff here
        clickedCheckButton(checkButton)
    }
    
    @IBAction func clickedCheckButton(_ sender: UIButton) {
        print("clicked checkButton")
        self.checkButtonDelegate?.checkButtonClicked(sender)

        
    }
    
    @IBAction func clickedcheckSubButton(_ sender: UIButton) {
        print("clicked clickedcheckSubButton")
        self.checkButtonDelegate?.checkSubButtonClicked(sender)
    }
    
}


//체크서브 버튼 클릭시 약관보기 상세 페이지 관련 delegate 함수 필요
