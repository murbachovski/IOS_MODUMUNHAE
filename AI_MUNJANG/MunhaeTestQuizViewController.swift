//
//  MunjangQuizViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/05.
//

import UIKit
import AVFoundation


enum TestQuizStatus {
    case NONE
    case CORRECT
    case INCORRECT
}

class MunhaeTestQuizViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var munhaepaddingLabel: PaddingLabel!
    
    @IBOutlet var munhaeQuizProcessLabel: UILabel!
    
    @IBOutlet var munhaeQuestionTitle: UILabel!
    
    @IBOutlet var paddingLabel: PaddingLabel!
    
    @IBOutlet var quizProgressView: UIProgressView!
    
    @IBOutlet var exampleButton01: UIButton!
    @IBOutlet var exampleButtonImage01: UIImageView!
    
    @IBOutlet var exampleButton02: UIButton!
    @IBOutlet var exampleButtonImage02: UIImageView!
    
    @IBOutlet var exampleButton03: UIButton!
    @IBOutlet var exampleButtonImage03: UIImageView!
    
    @IBOutlet var exampleButton04: UIButton!
    @IBOutlet var exampleButtonImage04: UIImageView!
    
    
    
    @IBOutlet var quizContainerView: UIView!

    @IBOutlet weak var quizTextLabel: UILabel!
    
    @IBOutlet weak var munhaeQuizContainerView: UIView!
    
    @IBOutlet weak var completeView: UIView!
    
    @IBOutlet weak var munhaeStopMessageView: UIView!
    
    @IBOutlet weak var munhaeStopContainer: UIView!
    
    @IBOutlet var munhaeDescriptionView: UIView!
    
    @IBOutlet var descriptionTitle: UILabel!
    
    @IBOutlet var descriptionSubTitle: UILabel!
    
    @IBOutlet var descriptionStartButton: UIButton!
    
    var audioPlayer: AVAudioPlayer? // AVAudioPlayer 인스턴스 참조체 저장
    
    var quizStatus: TestQuizStatus = .NONE
    
    var currentQuizPool:MunhaeTestContents = []
    
    var currentQuizIndex = 0
    lazy var currentQuiz = MunhaeTestContent(testnumber: 0, id: 0, title: "", jimun: nil, example: "", result: "")

    var answerButtons : [UIButton] = []
    var answerButtonImages : [UIImageView] = []
    var progressBarloc: Float = 0
    
    var isBalwhaSound = true
    
    var testResult: [String: Int] = [
        "글자":0,
        "낱말":0,
        "문장":0,
        "문맥":0,
    ]
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paddingLabel.layer.cornerRadius = 12
        paddingLabel.layer.masksToBounds = true
        
        answerButtons = [exampleButton01, exampleButton02, exampleButton03, exampleButton04]
        answerButtonImages = [exampleButtonImage01, exampleButtonImage02, exampleButtonImage03, exampleButtonImage04]
        
        quizTextLabel.layer.cornerRadius = 12
        quizTextLabel.layer.masksToBounds = true
        
        quizContainerView.layer.cornerRadius = 12
        quizContainerView.layer.shadowOpacity = 1
        quizContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        quizContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        quizContainerView.layer.shadowRadius = 2
        quizContainerView.layer.masksToBounds = false
        
        quizTextLabel.text = ""
        // Do any additional setup after loading the view.
       
        currentQuiz = currentQuizPool[0]
        print("CurrentQuiz : \(currentQuiz)")
        
        quizProgressView.progress = 0.0
        quizProgressView.tintColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        //TODO: descTitle 과 descSubTitle을 이곳에서 설정해야 currentQuiz 참조
        
        descriptionTitle.font = UIFont(name: "NanumSquareEB", size: 20)
        
        descriptionTitle.font = UIFont(name: "NanumSquareB", size: 17)
        
        descriptionStartButton.layer.borderWidth = 1
        descriptionStartButton.layer.borderColor = UIColor.darkGray.cgColor
        descriptionStartButton.layer.cornerRadius = descriptionStartButton.frame.size.width / 2
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        munhaeDescriptionView.frame = view.frame
        view.addSubview(munhaeDescriptionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: - IBAction
    
    @IBAction func clickedContinueButton(_ sender: Any) {
        munhaeStopMessageView.removeFromSuperview()
    }
    
    @IBAction func clickedStopButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clickedStart(_ sender: Any) {
        quizTextLabel.text = currentQuiz.title
        paddingLabel.text = currentQuiz.jimun ?? ""
        
        progressBarloc = Float(currentQuizIndex + 1) / Float(currentQuizPool.count)
        quizProgressView.setProgress(progressBarloc, animated: true)
        
        print("clicked Start Mission")
        munhaeDescriptionView.removeFromSuperview()
        startTTS()
    }
    @IBAction func closedButton(_ sender: Any) {
        munhaeStopMessageView.frame.size.width = view.frame.size.width
        view.addSubview(munhaeStopMessageView)
//        dismiss(animated: true)
    }
    
    @IBAction func clickedSubmitButton(_ sender: Any) {
        let isChecked = checkValidation()
        if isChecked == false {
            let alert = AlertService().alert(title: "", body: "보기 중 하나를 선택하세요.", cancelTitle: "", confirTitle: "확인", thirdButtonCompletion:nil, fourthButtonCompletion: nil)
            present(alert, animated: true)
            return
        }
        for item in answerButtons {
            if item.isSelected == true {
                if item.titleLabel?.text == currentQuiz.result {
                    print("정답입니다")
                    if 0 <= currentQuiz.id && currentQuiz.id < 4 {
                        testResult["글자"] = testResult["글자"]! + 1
                    }else if 4 <= currentQuiz.id && currentQuiz.id < 8 {
                        testResult["낱말"] = testResult["낱말"]! + 1
                    }else if 8 <= currentQuiz.id && currentQuiz.id < 14 {
                        testResult["문장"] = testResult["문장"]! + 1
                    }else if 14 <= currentQuiz.id && currentQuiz.id < 20 {
                        testResult["문맥"] = testResult["문맥"]! + 1
                    }
                    
                }else {
                    print("오답")
                }
            }
        }
        if currentQuizIndex < currentQuizPool.count - 1 {
            currentQuizIndex += 1
            currentQuiz = currentQuizPool[currentQuizIndex]
        }else{
//            isCurrentMissionCompleted = true
            print("시험완료 : 결과 : \(testResult)")
            return
            //
        }
        updateUI()
    }
    
    func checkValidation() -> Bool {
        var isChecked = false
        for item in answerButtons {
            if item.isSelected == true {
                isChecked = true
            }
        }
        return isChecked
    }
    
    fileprivate func startTTS() { //TTS호출을 별도롤 분리, 미션을 설명하는 화면이 사라질 떄 호출할 예정
        
            let tts = TTS()
            //TTS가 시작시 버튼 비활성화
            changeButtonStatus(false)
            
            tts.setText(currentQuiz.title) {
                //TTS가 완료된 후 버튼 활성화
                self.changeButtonStatus(true)
        }
    }
    
    func setupUI(){
        
        for item in answerButtons {
            item.setTitleColor(.black, for: .normal)
            item.isSelected = false
        }
        for item in answerButtonImages {
            item.isHidden = true
        }

        quizTextLabel.text = currentQuiz.title
        if currentQuiz.jimun == "" {
            quizContainerView.isHidden = true
        }else {
            quizContainerView.isHidden = false
        }
        paddingLabel.text = currentQuiz.jimun ?? ""
        
        munhaeQuizProcessLabel.text = "\(currentQuizIndex + 1)/\(currentQuizPool.count)"
        munhaeQuizProcessLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        munhaeQuizProcessLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)

        
        let exampleArray = currentQuiz.example.components(separatedBy:"//")
        let exampleCount = exampleArray.count
        
        exampleButton01.setTitle(exampleArray[0].trimmingCharacters(in: .whitespaces)
                            , for: .normal)
        exampleButton01.layer.cornerRadius = 8
        exampleButton01.layer.borderWidth = 1
        exampleButton01.layer.borderColor = UIColor.lightGray.cgColor
        
        
        exampleButton02.setTitle(exampleArray[1].trimmingCharacters(in: .whitespaces), for: .normal)
        exampleButton02.layer.cornerRadius = 8
        exampleButton02.layer.borderWidth = 1
        exampleButton02.layer.borderColor = UIColor.lightGray.cgColor
        
        exampleButton03.isHidden = false
        exampleButton03.setTitle(exampleArray[2].trimmingCharacters(in: .whitespaces), for: .normal)
        exampleButton03.layer.cornerRadius = 8
        exampleButton03.layer.borderWidth = 1
        exampleButton03.layer.borderColor = UIColor.lightGray.cgColor
        
        if exampleCount == 3 {
            exampleButton04.isHidden = true
        }else {
            exampleButton04.isHidden = false
            exampleButton04.setTitle(exampleArray[3].trimmingCharacters(in: .whitespaces), for: .normal)
            exampleButton04.layer.cornerRadius = 8
            exampleButton04.layer.borderWidth = 1
            exampleButton04.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        
        
        munhaeQuestionTitle.text = currentQuiz.title

        quizTextLabel.layer.cornerRadius = 12
        quizTextLabel.layer.masksToBounds = true
        
     
        quizContainerView.layer.cornerRadius = 12
        quizContainerView.layer.shadowOpacity = 1
        quizContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        quizContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        quizContainerView.layer.shadowRadius = 2
        quizContainerView.layer.masksToBounds = false
        
    }
    
    @IBAction func clickedOptions(_ sender: UIButton) {
        print("clicked \(sender.tag) button")
        for item in answerButtons {
            if item.tag == sender.tag {
                item.setTitleColor(hexStringToUIColor(hex: Constants.primaryColor), for: .normal)
                item.isSelected = true
            }else {
                item.setTitleColor(.black, for: .normal)
                item.isSelected = false
        }
        for item in answerButtonImages {
            if item.tag == sender.tag {
                item.isHidden = false
            }else {
                item.isHidden = true
            }
        }
    }
        
//        if sender.titleLabel?.text == currentQuiz.result {
//
//        }else{
//
//        }
        

    }
    
    func updateUI(){
        progressBarloc = Float(currentQuizIndex + 1) / Float(currentQuizPool.count)
        quizProgressView.setProgress(progressBarloc, animated: true)
        
        setupUI()
        startTTS()
   
    }
    fileprivate func changeButtonStatus(_ isStatus: Bool) {
        exampleButton01.isUserInteractionEnabled = isStatus
        exampleButton02.isUserInteractionEnabled = isStatus
        exampleButton03.isUserInteractionEnabled = isStatus
        exampleButton04.isUserInteractionEnabled = isStatus
    }
}
