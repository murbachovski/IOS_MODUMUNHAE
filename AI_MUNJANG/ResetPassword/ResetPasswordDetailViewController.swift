//
//  ResetPasswordDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/19.
//

import UIKit

class ResetPasswordDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var userEmail:String = "test@gmail.com"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "비밀번호 재설정"
        self.navigationController?.navigationBar.topItem?.title = " "

        
        titleLabel.text = "\(userEmail)으로 비밀번호 재설정 이메일을 발송했습니다."
        // Do any additional setup after loading the view.
    }
    

}
