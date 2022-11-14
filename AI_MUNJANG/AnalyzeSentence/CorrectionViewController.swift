//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Сергей Горбачёв on 18.08.2021.
//

import UIKit

class CorrectionViewController: UIViewController {
    var dicData: [String : Any] = [:]
    var originSentence = ""
    var originWord = ""
    var selectedLex = ""
    var selectedTag = ""
    var changedWord = ""
    var changedSentence = ""
    let josaDictionary = ["JKS" : ["이", "가", "께서", "에서"],
                          "JKG" : ["의"],
                          "JKO" : ["을", "를"],
                          "JKB" : ["에", "에게", "께", "한테", "에서", "에게서", "보다", "로서", "와", "과", "랑", "이랑", "에", "처럼", "같이", "만큼", "만치"],
                          "JKV" : ["야", "아", "여", "이여", "이시여"],
                          "JKQ" : ["고", "이라고", "라고"],
                          "JX" : ["이", "가", "은", "는", "도", "을", "를", "부터", "로부터", "으로부터", "까지", "마저", "조차", "일랑", "커녕", "새로에", "손", "서껀", "들", "인들", "엔들", "마는", "만", "그래", "그려", "뿐", "만", "따라", "토록", "치고", "밖에", "즉", "인즉", "대로", "요", "든지", "만큼", "만치"],
                          "JC" : ["와", "과", "하고", "이다", "이며", "에다", "랑"]
    ]
    @IBOutlet var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dicData:\(dicData)")
        questionLabel.text = originSentence
        
        questionLabel.backgroundColor = .white
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.shadowOpacity = 0.8
        questionLabel.layer.shadowColor = UIColor.lightGray.cgColor
        questionLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        questionLabel.layer.shadowRadius = 2
        questionLabel.layer.masksToBounds = false
        
        
        composeQuestion()
        self.title = "문장교정"
        
        displayHomeBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        userInput()
        userInputByCustomAlert()
    }
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
        
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.leftBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: -25, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    func userInputByCustomAlert(){

        let alert = AlertService().alertTF {
            print("cancel Button clicked")
            self.navigationController?.popViewController(animated: true)
        } confirmButtonCompletion: { res in
            print(res)
            let trimmed = res.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 0 {
                if trimmed == self.originWord {
                    print("사용자 정답")
                    self.alertBySuccess(success: true)
                }else {
                    print("사용자 오답")
                    self.alertBySuccess(success: false)
                }
            }else {
                print("No input")
                self.alertBySuccess(success: false)
            }
          
        }

        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        present(alert, animated: true)
    }
    
    func composeQuestion() {
        let res = dicData.randomElement()!
        originWord = res.key
        let tmpDic = res.value as! [String : String]
        selectedLex = tmpDic.keys.first!
        selectedTag = tmpDic.values.first!

        questionLabel.text = changedSentence
        print("changedWord:\(changedWord)")
        print("changedSentence:\(changedSentence)")
        
        pickRandomJosa()
        
    }
    
    func pickRandomJosa() {
        var tmpDic: [String:Any] = [:]
        tmpDic = josaDictionary
        tmpDic.removeValue(forKey: selectedTag)
        print(tmpDic)
        let selectedJosa = tmpDic.randomElement()?.value as! [String]
        let selectedJosaStr = selectedJosa.randomElement()!
        print(selectedJosaStr)
        if selectedLex == selectedJosaStr {
            pickRandomJosa()
        }
        changedWord = originWord.replacingOccurrences(of: selectedLex, with: selectedJosaStr)
        print("originWord:\(originWord), changedWord: \(changedWord)")
        
        changedSentence = originSentence.replacingOccurrences(of: originWord, with: changedWord)
        
        let startIndexOfChangedWord = changedSentence.index(of: changedWord)?.utf16Offset(in: changedSentence)
        
        let attributedText = NSMutableAttributedString(string: changedSentence)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(startIndexOfChangedWord!, changedWord.count))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
        
        questionLabel.attributedText = attributedText
    }
    

    func alertBySuccess(success: Bool) {
        var messageTo = ""
        if success == true {
                messageTo = "정답입니다. \n 다음 문제를 풀겠습니까?"
        }else {
            messageTo = "틀렸습니다. \n 다시 한번 도전해보세요."
        }
        
        let alert = AlertService().alert(title: "", body: messageTo, cancelTitle: "취소", confirTitle: "계속") {
            self.navigationController?.popViewController(animated: true)
        } fourthButtonCompletion: {
            self.composeQuestion()
            self.userInputByCustomAlert()
        }
        
        present(alert, animated: true)

    }
}
