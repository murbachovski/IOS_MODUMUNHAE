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
        print(analyzeSentenceCustomTextView.textView.text!)
        let inputString = analyzeSentenceCustomTextView.textView.text!
        let urlString = "http://118.67.133.8/gpt_danmun_new"
        requestByDanmun(url: urlString, sen: inputString) { results in
            print("단문results:\(results)")
            
            let changedSentence = results.joined(separator: " VV ")
            print(changedSentence)
            self.requestAnalyzeEight(inputString: changedSentence)
        }
        
        
        
//        guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
//        navigationController?.pushViewController(analyzeResultViewController, animated: true)
    }
    
    func requestAnalyzeEight(inputString: String) {
        let urlString = "http://118.67.133.8/eight_logic/m"
//        requestByEight(url: urlString, sen: inputString,, completion: ([String : Any]) -> Void
        
//            let inpurString = ""
        
        requestByEight(url: urlString, sen: inputString) { resDic in
            print("resDic:\(resDic)")
            DispatchQueue.main.async {
                guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
                analyzeResultViewController.analyzedData = resDic
                self.navigationController?.pushViewController(analyzeResultViewController, animated: true)
            }
        }
    }
}
