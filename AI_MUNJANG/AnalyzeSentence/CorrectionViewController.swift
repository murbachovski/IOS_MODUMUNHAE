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
    
    @IBOutlet var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dicData:\(dicData)")
        questionLabel.text = originSentence
        
        let res = dicData.randomElement()!
        originWord = res.key
        let tmpDic = res.value as! [String : String]
        selectedLex = tmpDic.keys.first!
        selectedTag = tmpDic.values.first!

        let changeLex = "는"
        changedWord = originWord.replacingOccurrences(of: selectedLex, with: changeLex)
        changedSentence = originSentence.replacingOccurrences(of: originWord, with: changedWord)
        questionLabel.text = changedSentence
        print("selectedLex:\(selectedLex), changedLex:\(changeLex)")
        print("changedWord:\(changedWord)")
        print("changedSentence:\(changedSentence)")
    }
    
    func composeQuestion() {
        
    }
}
