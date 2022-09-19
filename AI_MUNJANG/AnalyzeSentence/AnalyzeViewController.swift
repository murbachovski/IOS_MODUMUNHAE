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

        checkIfMultiSentence(inputStr: inputString)
        
    
    }
    
    
    private func analyzeDanmunAfterEight(str:String){
        let senToAnalyze:String = str
        
        let urlString = "http://118.67.133.8/gpt_danmun_new"
        
        requestByDanmun(url: urlString, sen: senToAnalyze) { results in
            print("단문results:\(results)")
            
            let changedSentence = results.joined(separator: " VV ")
            print(changedSentence)
            self.requestAnalyzeEight(inputString: changedSentence)
        }
    }
    
    
    func requestAnalyzeEight(inputString: String) {
        let urlString = "http://118.67.133.8/eight_logic/m"

        requestByEight(url: urlString, sen: inputString) { resDic in
            print("resDic:\(resDic)")
            DispatchQueue.main.async {
                guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
                analyzeResultViewController.analyzedData = resDic
                self.navigationController?.pushViewController(analyzeResultViewController, animated: true)
            }
        }
    }


    func checkIfMultiSentence(inputStr:String){
        let urlString = "http://118.67.133.8/div_kiwi/m"
        
        requestByKiwi(url: urlString, sen: inputStr) {  resDic in
            
            if resDic.count > 1 { //다문장
                print("다문장 별도의 페이지로 이동 필요")
                DispatchQueue.main.async {
                    guard let senListViewController = self.storyboard?.instantiateViewController(withIdentifier: "SenListViewController")  as? SenListViewController else {return}
                    senListViewController.senList = resDic
                    self.navigationController?.pushViewController(senListViewController, animated: true)
                }
            }else{ //단일문장
                print("단일 문장이므로 바로 분석하고 결과 페이지로 이동")
                self.analyzeDanmunAfterEight(str: resDic[0])
            }
            
        }
        
}


}
