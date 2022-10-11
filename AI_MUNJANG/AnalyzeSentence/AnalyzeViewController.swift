//
//  AnalyzeViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/25.
//

import UIKit
import NVActivityIndicatorView

class AnalyzeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var analyzeSentenceCustomTextView: CustomTextView!
    
    @IBOutlet weak var analyzeButton: UIButton!
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                            type: .lineSpinFadeLoader,
                                            color: hexStringToUIColor(hex: Constants.primaryColor),
                                            padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        analyzeSentenceCustomTextView.changeRestrictedCharacters(res: 300)
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
        
        if !Core.shared.isUserSubscription() {
            let tmpUseCount = UserDefaults.standard.integer(forKey: "tmpUseCount")
            print("😃 😃 😃 😃 😃 😃 😃 tmpUseCount:\(tmpUseCount)")
            //TODO: -횟수제한
            if tmpUseCount + 1 > 1000{
                let alert = AlertService().alert(title: "구독", body: "사용 횟수 10회 초과 입니다.", cancelTitle: "확인", confirTitle: "구독하기") {
                    //이전 페이지로 이동
                   self.navigationController?.popViewController(animated: true)
                } fourthButtonCompletion: {
                    // 사용자가 구독하기 선택
                    guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                    subscriptionViewController.modalPresentationStyle = .fullScreen
                    self.present(subscriptionViewController, animated: true)
                    
                    print("cliocked subscribe")
                }
                present(alert, animated: true)
            }else {
                UserDefaults.standard.set(tmpUseCount + 1, forKey: "tmpUseCount")
                print("clicked Analyze Button")
                print(analyzeSentenceCustomTextView.textView.text!)
                let inputString = analyzeSentenceCustomTextView.textView.text!

                checkIfMultiSentence(inputStr: inputString)
            }
        }else {
            print(analyzeSentenceCustomTextView.textView.text!)
            let inputString = analyzeSentenceCustomTextView.textView.text!

            checkIfMultiSentence(inputStr: inputString)
        }
    
    }
    
    
    private func analyzeDanmunAfterEight(str:String){
        let senToAnalyze:String = str
        DispatchQueue.main.async {
            if !self.indicator.isAnimating {
                self.indicator.startAnimating()
            }
        }
        let urlString = "http://118.67.133.8/danmun/m"
//        let urlString = "http://127.0.0.1:5000/danmun/m"
        
        requestByDanmun(url: urlString, sen: senToAnalyze) { results in
            print("단문results:\(results)")
            if results[0] == "not hangle" {
                DispatchQueue.main.async {
                    if self.indicator.isAnimating {
                        self.indicator.stopAnimating()
                    }
                    
                    let alert = AlertService().alert(title: "", body: "입력한 문장이 옳바르지 않습니다.", cancelTitle: "", confirTitle: "확인") {
                    } fourthButtonCompletion: {
                        print("cliocked subscribe")
                    }
                    self.present(alert, animated: true)
                    return
                }
                return
            }
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
                if self.indicator.isAnimating {
                    self.indicator.stopAnimating()
                }
                guard let analyzeResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeResultViewController")  as? AnalyzeResultViewController else {return}
                analyzeResultViewController.analyzedData = resDic
                self.navigationController?.pushViewController(analyzeResultViewController, animated: true)
            }
        }
    }


    func checkIfMultiSentence(inputStr:String){
        self.view.addSubview(self.indicator)
        self.indicator.center = self.view.center
        self.indicator.startAnimating()
        
        if inputStr.isEmpty {
            self.indicator.stopAnimating()
            let alert = AlertService().alert(title: "", body: "분석할 문장을 입력해주세요", cancelTitle: "", confirTitle: "확인") {
            } fourthButtonCompletion: {
                print("cliocked subscribe")
            }
            present(alert, animated: true)
            return
        }
        let urlString = "http://118.67.133.8/div_kiwi/m"
        
        requestByKiwi(url: urlString, sen: inputStr) {  resDic in
            DispatchQueue.main.async {
                if self.indicator.isAnimating {
                    self.indicator.stopAnimating()
                }
                
            }
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
