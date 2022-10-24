//
//  ResetPasswordDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit

class ResetPasswordDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    var userEmail:String = "test@gmail.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.topItem?.title = " "

        
        titleLabel.text = "\(userEmail)으로 비밀번호 재설정 이메일을 발송했습니다."
        titleLabel.font =  UIFont(name: "NanumSquareEB", size: 17)
        titleLabel.textColor = hexStringToUIColor(hex: Constants.Balck_51)
        
        
        subLabel.layer.cornerRadius = 10
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            subLabel.font = UIFont(name: "NaumSquareB", size: 17)
            
        }else{
            subLabel.asFont(targetString: "3분 내에 이메일이 오지 않는다면?", font: UIFont(name: "NanumSquareB", size: 15))
        }
        
        
    }
    

}
