//
//  AnalyzeViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/25.
//

import UIKit

class AnalyzeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var analyzeSentenceCustomTextView: CustomTextView!
    
    @IBOutlet weak var analyzeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.font = UIFont(name: "NanumSquareEB", size: 18)
        analyzeSentenceCustomTextView.textView.becomeFirstResponder()
        
        analyzeButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 15)
        analyzeButton.layer.cornerRadius = 4
        analyzeButton.layer.borderWidth = 1
        analyzeButton.layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor

        navigationItem.title = "문장분석"
    }

    @IBAction func clickedAnalyze(_ sender: Any) {
        print("clicked Analyze Button")
        
        guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
        navigationController?.pushViewController(analyzeResultViewController, animated: true)
    }
}
