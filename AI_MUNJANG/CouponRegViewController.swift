//
//  CouponRegViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/10/21.
//

import UIKit

class CouponRegViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var couponTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponTextField.delegate = self
        couponTextField.becomeFirstResponder()
        couponTextField.keyboardType = .default
        couponTextField.returnKeyType = .done
        couponTextField.placeholder = "이 곳에 쿠폰번호를 입력해 주세요."
        
        
        let customFont:UIFont = UIFont(name: "NanumSquareB", size: 20)!
        couponTextField.font = customFont
        couponTextField.textColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickedClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let couponNum = textField.text else{return true}
    
        retrieveCoupon(docID: couponNum) { usable in
            if usable == true{
                setUpCouponRecord(docID: couponNum) { success in
                    textField.text = ""
                    textField.resignFirstResponder()
                                                    
                    var bodyMessage = ""
                    if success == true{
                        bodyMessage = "쿠폰이 정상적으로 등록되었습니다."
                    }else{
                        bodyMessage = "쿠폰 등록이 오류가 발생했습니다."
                    }
                    
                    let alert = AlertService().alert(title: "", body: bodyMessage, cancelTitle: "", confirTitle: "확인", thirdButtonCompletion: nil) {}
                    
                    
                    self.present(alert, animated: true)
                    
                }
            }else{
                
            }
            
        }
        
        
        return true
    }
    
}
