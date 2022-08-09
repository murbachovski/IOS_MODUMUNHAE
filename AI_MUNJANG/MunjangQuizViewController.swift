//
//  MunjangQuizViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/05.
//

import UIKit

enum QuizStatus {
    case NONE
    case CORRECT
    case INCORRECT
}

class MunjangQuizViewController: UIViewController {

    @IBOutlet var correctOrNotView: UIView!
    
    @IBOutlet weak var trueOrNotImageView: UIImageView!
    
    @IBOutlet weak var trueOrNotTitle: UILabel!
    
    @IBOutlet weak var trueOrNotButton: UIButton!
    
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    
    @IBOutlet weak var answer01Button: UIButton!
    
    @IBOutlet weak var answer02Button: UIButton!
    
    @IBOutlet weak var answer03Button: UIButton!
    
    
    @IBOutlet weak var quizProgressView: UIProgressView!
    
   
    @IBOutlet weak var quizTextLabel: UILabel!
    
    @IBOutlet weak var quizContainerView: UIView!
    
    @IBOutlet weak var button01Image: UIImageView!
    
    @IBOutlet weak var button02Image: UIImageView!
    
    @IBOutlet weak var button03Image: UIImageView!
    
    @IBOutlet weak var correctViewSubContainerView: UIView!
    
    
    @IBOutlet var completeView: UIView!
    
    @IBOutlet var stopMessageView: UIView!
    
    @IBOutlet weak var stopSubContainer: UIView!
    
    var quizStatus:QuizStatus = .NONE
    
    var currentQuizFool:QuizContents = []
    
    var currentQuizIndex = 0
    lazy var currentQuiz = QuizContent(id: "", type: "", section: "", mission: 0, title: "", jimun: nil, example: "", result: nil, imageName: nil)
    

    var answerButtons : [UIButton] = []
    var answerButtonImages : [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerButtons = [answer01Button, answer02Button, answer03Button]
        answerButtonImages = [button01Image, button02Image, button03Image]

        
        quizImage.isHidden = false
        quizTextLabel.isHidden = true
        // Do any additional setup after loading the view.
       
        currentQuiz = currentQuizFool[0]
        print("CurrentQuiz : \(currentQuiz)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func setupUI(){
        
        let exampleArray = currentQuiz.example.components(separatedBy:"//")
        answer01Button.setTitle(exampleArray[0].trimmingCharacters(in: .whitespaces)
                            , for: .normal)
        answer01Button.layer.cornerRadius = 8
        answer01Button.layer.borderWidth = 1
        answer01Button.layer.borderColor = UIColor.lightGray.cgColor
        
        
        answer02Button.setTitle(exampleArray[1].trimmingCharacters(in: .whitespaces), for: .normal)
        answer02Button.layer.cornerRadius = 8
        answer02Button.layer.borderWidth = 1
        answer02Button.layer.borderColor = UIColor.lightGray.cgColor
        
        answer03Button.setTitle(exampleArray[2].trimmingCharacters(in: .whitespaces), for: .normal)
        answer03Button.layer.cornerRadius = 8
        answer03Button.layer.borderWidth = 1
        answer03Button.layer.borderColor = UIColor.lightGray.cgColor
        
        questionTitle.text = currentQuiz.title
        
        if currentQuiz.type == "Image"{
            quizTextLabel.isHidden = true
            quizImage.isHidden = false
            quizImage.image = UIImage(named: currentQuiz.imageName!)
            quizImage.layer.cornerRadius = 12
            quizImage.layer.masksToBounds = true

        }else{
            quizTextLabel.isHidden = false
            quizImage.isHidden = true
            
            quizTextLabel.text = currentQuiz.jimun
            quizTextLabel.layer.cornerRadius = 12
            quizTextLabel.layer.masksToBounds = true
            
            let attributedString = NSMutableAttributedString(string: currentQuiz.jimun!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            quizTextLabel.attributedText = attributedString
            quizTextLabel.textAlignment = .center
            
        }
        
     
        quizContainerView.layer.cornerRadius = 12
        quizContainerView.layer.shadowOpacity = 1
        quizContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        quizContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        quizContainerView.layer.shadowRadius = 2
        quizContainerView.layer.masksToBounds = false
     
        
        trueOrNotButton.layer.cornerRadius = 8
        
        correctViewSubContainerView.clipsToBounds = true
        correctViewSubContainerView.layer.cornerRadius = 20
        correctViewSubContainerView.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]

        stopSubContainer.clipsToBounds = true
        stopSubContainer.layer.cornerRadius = 20
        stopSubContainer.layer.maskedCorners = [ .layerMinXMinYCorner, .layerMaxXMinYCorner]
   
        
    }
    

   
    
    
    
    @IBAction func clickedOptions(_ sender: UIButton) {
        print("clicked \(sender.tag) button")
        
        if sender.titleLabel?.text == currentQuiz.result {
            
            
            quizStatus = .CORRECT
            changeButtonUIByRsult(sender, correct: true)
            
            showCorrectOrNotView()
            currentQuizIndex += 1
            currentQuiz = currentQuizFool[currentQuizIndex]

        }else{
            changeButtonUIByRsult(sender, correct: false)
                        
            quizStatus = .INCORRECT
            
            showCorrectOrNotView()
        }

    }
    
    fileprivate func changeButtonUIByRsult(_ sender: UIButton, correct:Bool) {
        if correct {
            answerButtons[sender.tag].layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
            answerButtonImages[sender.tag].image = UIImage(named: "icCorrect32Px")
            answerButtonImages[sender.tag].isHidden = false
        }else{
            answerButtons[sender.tag].layer.borderColor = hexStringToUIColor(hex: "#ff4343").cgColor
            answerButtonImages[sender.tag].image = UIImage(named: "icIncorrect32Px")
            answerButtonImages[sender.tag].isHidden = false
        }
        
    }
    
    
    
    
    func showCorrectOrNotView(){
        
        correctOrNotView.frame = self.view.frame
        correctOrNotView.backgroundColor = .clear
        
        if quizStatus == .CORRECT {
            correctViewSubContainerView.backgroundColor = hexStringToUIColor(hex: "#EAF9F1")
            trueOrNotImageView.image = UIImage(named: "icCorrect24Px") //
            trueOrNotTitle.text = "정답입니다!"
            trueOrNotTitle.textColor =  hexStringToUIColor(hex: "#04bf55")
            trueOrNotButton.setTitle("다음", for: .normal)
            trueOrNotButton.backgroundColor = hexStringToUIColor(hex: "#04bf55")
            
        
            
        }else if quizStatus == .INCORRECT {
            correctViewSubContainerView.backgroundColor = hexStringToUIColor(hex: "#FCEBEA")
            trueOrNotImageView.image = UIImage(named: "icIncorrect24Px")
            trueOrNotTitle.text = "다시 한 번 맞춰보세요!"
            trueOrNotTitle.textColor =  hexStringToUIColor(hex: "#ff4343")
            trueOrNotButton.setTitle("다시 맞추기", for: .normal)
            trueOrNotButton.backgroundColor = hexStringToUIColor(hex: "#ff4343")
        }
        
        view.addSubview(correctOrNotView)
    }
    
    
    func updateUI(){
      setupUI()
   
    }
    
    
    @IBAction func clickedTrueOrNotButton(_ sender: Any) {
        quizStatus = .NONE
        correctOrNotView.removeFromSuperview()
        for item in answerButtonImages {
            item.isHidden = true
        }
        updateUI()
    }
    @IBAction func clickedCompleteViewButton(_ sender: Any) {

        
        dismiss(animated: true)
    }

    
    @IBAction func clickedClose(_ sender: UIButton) {
        
        stopMessageView.frame = view.frame
        view.addSubview(stopMessageView)
    }
    
    @IBAction func clickedStopMessageContinue(_ sender: Any) {
        //next quiz
        stopMessageView.removeFromSuperview()
    }
    
    @IBAction func clickedStopMessageStop(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
