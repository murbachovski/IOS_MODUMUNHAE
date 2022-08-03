//
//  TermsDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit

class TermsDetailViewController: UIViewController {

    @IBOutlet weak var titleOfTerms: UILabel!
    
    var titleOfLabel:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfTerms.text = titleOfLabel
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

//약관 상세보기는 추가적인 작업 필요
