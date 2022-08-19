//
//  MunjangQuizViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/05.
//

import UIKit
import AVFoundation


enum QuizStatus {
    case NONE
    case CORRECT
    case INCORRECT
}

class MunjangQuizViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet var quizProcessLabel: UILabel!
    
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
    
    var audioPlayer: AVAudioPlayer? // AVAudioPlayer 인스턴스 참조체 저장
    
    var quizStatus:QuizStatus = .NONE
    
    var currentQuizPool:QuizContents = []
    
    var currentQuizIndex = 0
    var isCurrentMissionCompleted = false
    lazy var currentQuiz = QuizContent(id: "", type: "", section: "", mission: 0, title: "", jimun: nil, example: "", result: nil, imageName: nil)
    

    var answerButtons : [UIButton] = []
    var answerButtonImages : [UIImageView] = []
    var progressBarloc: Float = 0
    
    var isCompletedTypeAnimation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerButtons = [answer01Button, answer02Button, answer03Button]
        answerButtonImages = [button01Image, button02Image, button03Image]

        quizTextLabel.layer.cornerRadius = 12
        quizTextLabel.layer.masksToBounds = true
        quizContainerView.layer.cornerRadius = 12
        quizContainerView.layer.shadowOpacity = 1
        quizContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        quizContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        quizContainerView.layer.shadowRadius = 2
        quizContainerView.layer.masksToBounds = false
        
        quizImage.isHidden = true
        quizTextLabel.isHidden = true
        
        quizTextLabel.text = ""
        // Do any additional setup after loading the view.
       
        currentQuiz = currentQuizPool[0]
        print("CurrentQuiz : \(currentQuiz)")
        
        quizProgressView.progress = 0.0
        quizProgressView.tintColor = hexStringToUIColor(hex: Constants.primaryColor)
        if currentQuiz.type == "Text" {
            isCompletedTypeAnimation = false
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()

    }
    
    func setupUI(){
        
        let tts = TTS()
        tts.setText(currentQuiz.title) {
            if self.currentQuiz.type == "Text" {
//                tts.voiceTTS()
//                self.quizTextLabel.text = ""
                self.typeAnimate(label: self.quizTextLabel, str : self.currentQuiz.jimun!)
            }
//            print("실행종료 됐습니다.")
        }
//        tts.setText("안녕하세요")
        if currentQuiz.type == "Text" {
            changeButtonStatus(false)
        }
        
        
        quizProcessLabel.text = "\(currentQuizIndex)/\(currentQuizPool.count)"
        quizProcessLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        quizProcessLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
//        let attributedString = NSMutableAttributedString(string: currentQuiz.jimun!)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
//        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        let exampleArray = currentQuiz.example.components(separatedBy:"//")
        let exampleCount = exampleArray.count
        
        answer01Button.setTitle(exampleArray[0].trimmingCharacters(in: .whitespaces)
                            , for: .normal)
        answer01Button.layer.cornerRadius = 8
        answer01Button.layer.borderWidth = 1
        answer01Button.layer.borderColor = UIColor.lightGray.cgColor
        
        
        answer02Button.setTitle(exampleArray[1].trimmingCharacters(in: .whitespaces), for: .normal)
        answer02Button.layer.cornerRadius = 8
        answer02Button.layer.borderWidth = 1
        answer02Button.layer.borderColor = UIColor.lightGray.cgColor
        
        if exampleCount == 2 {
            answer03Button.isHidden = true
        }else{
            answer03Button.isHidden = false
            answer03Button.setTitle(exampleArray[2].trimmingCharacters(in: .whitespaces), for: .normal)
            answer03Button.layer.cornerRadius = 8
            answer03Button.layer.borderWidth = 1
            answer03Button.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        
        questionTitle.text = currentQuiz.title
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let getImagePath = paths.appendingPathComponent("image/total/" + currentQuiz.imageName!)
//        let getImagePath = paths.appendingPathComponent("image/total/" + currentQuiz.imageName!)
        //월요일 작업 영역 이미지 읽어오기 진행중!!
        
        if currentQuiz.type == "Image"{
            quizTextLabel.isHidden = true
            quizImage.isHidden = false
//            quizImage.image = UIImage(named: currentQuiz.imageName!)
            quizImage.image = UIImage(contentsOfFile: getImagePath)
            quizImage.layer.cornerRadius = 12
            quizImage.layer.masksToBounds = true

        }else{
            quizTextLabel.isHidden = false
            quizImage.isHidden = true
            
//            quizTextLabel.text = currentQuiz.jimun
//            typeAnimate(label: quizTextLabel, str :currentQuiz.jimun!)
            quizTextLabel.layer.cornerRadius = 12
            quizTextLabel.layer.masksToBounds = true
            
        
            

            
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
        if isCompletedTypeAnimation == false {
            return
        }
        if sender.titleLabel?.text == currentQuiz.result {
            setUpEffectSounds(fileName: "success")
            if let player = audioPlayer {
                        player.play()
                    }
            
            quizStatus = .CORRECT
            changeButtonUIByRsult(sender, correct: true)
            
            showCorrectOrNotView()
            if currentQuizIndex < currentQuizPool.count - 1 {
                currentQuizIndex += 1
                currentQuiz = currentQuizPool[currentQuizIndex]
            }else{
                isCurrentMissionCompleted = true
            }
            

        }else{
            
            setUpEffectSounds(fileName: "failed")
            if let player = audioPlayer {
                        player.play()
                    }
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
        progressBarloc = Float(currentQuizIndex) / Float(currentQuizPool.count)
        quizProgressView.setProgress(progressBarloc, animated: true)
        if quizStatus == .CORRECT{
            quizTextLabel.text = ""
        }
        
        setupUI()
   
    }
    
    
    @IBAction func clickedTrueOrNotButton(_ sender: Any) {
//        quizStatus = .NONE
        correctOrNotView.removeFromSuperview()
        for item in answerButtonImages {
            item.isHidden = true
        }
        
        if isCurrentMissionCompleted {
            print("MIssion Completed")
            completeView.frame = self.view.frame
            self.view.addSubview(completeView)
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateUI()
            }
            
        }
        
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
    
    func typeAnimate(label: UILabel, str:String) {
        if quizStatus == .INCORRECT {
            changeButtonStatus(true)
            return
        }
        label.text = ""
        for i in str {
            AudioServicesPlaySystemSound(1306)
            label.text! += "\(i)"
            RunLoop.current.run(until: Date()+0.12)
        }
        changeButtonStatus(true)
    }
    
    fileprivate func changeButtonStatus(_ isStatus: Bool) {
        isCompletedTypeAnimation = isStatus
        answer01Button.isUserInteractionEnabled = isStatus
        answer02Button.isUserInteractionEnabled = isStatus
        answer03Button.isUserInteractionEnabled = isStatus
    }
    
    func setUpEffectSounds(fileName: String) {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "mp3") {
                
                let url = URL.init(fileURLWithPath: filePath)
                    do {
                        try audioPlayer = AVAudioPlayer(contentsOf: url)
                        audioPlayer?.delegate = self
                        audioPlayer?.prepareToPlay()
                    } catch {
                        print("audioPlayer error \(error.localizedDescription)")
                    }
                } else {
                    print("file not found")
                }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            
        }
}
