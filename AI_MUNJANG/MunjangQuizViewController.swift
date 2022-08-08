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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        
        quizImage.isHidden = false
        quizTextLabel.isHidden = true
        // Do any additional setup after loading the view.
        
       
        currentQuiz = currentQuizFool[0]
        setupUI()
    }
    
    func setupUI(){
        
        let exampleArray = currentQuiz.example.components(separatedBy:"//")
        answer01Button.titleLabel?.text = exampleArray[0]
        answer01Button.layer.cornerRadius = 8
        answer01Button.layer.borderWidth = 1
        answer01Button.layer.borderColor = UIColor.lightGray.cgColor
        
        
        answer02Button.titleLabel?.text = exampleArray[1]
        answer02Button.layer.cornerRadius = 8
        answer02Button.layer.borderWidth = 1
        answer02Button.layer.borderColor = UIColor.lightGray.cgColor
        
        answer03Button.titleLabel?.text = exampleArray[2]
        answer03Button.layer.cornerRadius = 8
        answer03Button.layer.borderWidth = 1
        answer03Button.layer.borderColor = UIColor.lightGray.cgColor
        
        quizTextLabel.text = currentQuiz.jimun
        quizTextLabel.layer.cornerRadius = 12
        quizTextLabel.layer.masksToBounds = true
        
//        quizImage.image = UIImage(named: currentQuiz.imageName)
        quizImage.layer.cornerRadius = 12
        quizImage.layer.masksToBounds = true
     
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
            showCorrectOrNotView()
            updateUI()
        }else{
            quizStatus = .INCORRECT
            showCorrectOrNotView()
        }
        
        //응답이 참인 경우와 거짓인 경우를 나누어..
//        if sender.tag == 1 {
//            quizStatus = .CORRECT
//            showCorrectOrNotView()
//
//        }else if sender.tag == 2{
//            quizStatus = .INCORRECT
//            showCorrectOrNotView()
//        }else if sender.tag == 3 {
//            completeView.frame = view.frame
//            view.addSubview(completeView)
//        }
        
        
        
    }
    
    
    func showCorrectOrNotView(){
        
        correctOrNotView.frame = self.view.frame
        correctOrNotView.backgroundColor = .clear
        
        if quizStatus == .CORRECT {
            correctViewSubContainerView.backgroundColor = hexStringToUIColor(hex: "#EAF9F1")
            trueOrNotImageView.image = UIImage(named: "icCorrect24Px") //
            trueOrNotTitle.text = "정답입니다!"
            trueOrNotTitle.textColor =  hexStringToUIColor(hex: "#04bf55")
            trueOrNotButton.titleLabel?.text = "다음"
            trueOrNotButton.backgroundColor = hexStringToUIColor(hex: "#04bf55")
            
            
        }else if quizStatus == .INCORRECT {
            correctViewSubContainerView.backgroundColor = hexStringToUIColor(hex: "#FCEBEA")
            trueOrNotImageView.image = UIImage(named: "icIncorrect24Px")
            trueOrNotTitle.text = "다시 한 번 맞춰보세요!"
            trueOrNotTitle.textColor =  hexStringToUIColor(hex: "#ff4343")
            trueOrNotButton.titleLabel?.text = "다시 맞추기"
            trueOrNotButton.backgroundColor = hexStringToUIColor(hex: "#ff4343")
        }
        
        view.addSubview(correctOrNotView)
    }
    
    
    func updateUI(){
//        quizImage.isHidden = !quizImage.isHidden
//        quizTextLabel.isHidden = !quizTextLabel.isHidden
   
    }
    
    
    @IBAction func clickedTrueOrNotButton(_ sender: Any) {
        quizStatus = .NONE
        correctOrNotView.removeFromSuperview()
        
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
