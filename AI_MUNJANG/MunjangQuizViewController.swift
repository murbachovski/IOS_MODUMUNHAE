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

protocol EightDetailDelegate: AnyObject {
    func eightDetailDelegate()
}

class MunjangQuizViewController: UIViewController, AVAudioPlayerDelegate {
    
    var currentSection = ""
    
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
    
    @IBOutlet weak var displayUsernameOnMissionClear: UILabel!
    
    @IBOutlet var descriptionView: UIView!
    
    @IBOutlet weak var descTitleLabel: UILabel!
    @IBOutlet weak var descSubTitleLabel: UILabel!
    @IBOutlet weak var startMissionButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    
    weak var delegate: EightDetailDelegate?
    
    var audioPlayer: AVAudioPlayer? // AVAudioPlayer 인스턴스 참조체 저장
    
    var quizStatus:QuizStatus = .NONE
    
    var currentQuizPool:QuizContents = []
    
    var currentQuizIndex = 0
    var isCurrentMissionCompleted = false
    lazy var currentQuiz = QuizContent(level: "", id: "", type: "", section: 0, missionSubject: nil, mission: 0, title: "", jimun: "", example: "", result: nil, imageName: nil)

    var answerButtons : [UIButton] = []
    var answerButtonImages : [UIImageView] = []
    var progressBarloc: Float = 0
    
    var isCompletedTypeAnimation = true
    
    let runLoop = CFRunLoopGetCurrent()
    
    var runloopStop = false
//    var isBalwhaSound = true
    
    
    @IBOutlet weak var balwhaButton: UIButton!
    
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
        let tmpLevel = currentQuizPool[0].level
        // Do any additional setup after loading the view.
        if currentSection != "1" {
            
            
            if tmpLevel == "Basic" {
                currentQuizIndex = retrieveStopStep(section: currentSection, level: "Basic")
                descTitleLabel.text = "기초문해 미션"
            }else if tmpLevel == "Advanced"{
                currentQuizIndex = retrieveStopStep(section: "1", level: "Advanced")
                descTitleLabel.text = "실질문해 미션"
                descSubTitleLabel.text = "기초문해력으로 문제를 해결합니다."
            }
        }
        currentQuiz = currentQuizPool[currentQuizIndex]
        
        print("CurrentQuiz : \(currentQuiz)")
        
        quizProgressView.progress = 0.0
        quizProgressView.tintColor = hexStringToUIColor(hex: Constants.primaryColor)
        if currentQuiz.type == "Text" {
            isCompletedTypeAnimation = false
        }
        
        
        
        //TODO: descTitle 과 descSubTitle을 이곳에서 설정해야 currentQuiz 참조
        if UIDevice.current.userInterfaceIdiom == .pad {
            descTitleLabel.font = UIFont(name: "NanumSquareEB", size: 22)
            descSubTitleLabel.font = UIFont(name: "NanumSquareB", size: 20)
        }else {
            descTitleLabel.font = UIFont(name: "NanumSquareEB", size: 18)
            descSubTitleLabel.font = UIFont(name: "NanumSquareB", size: 14)
        }
        
        let ttmpLevel = currentQuizPool[0].level
        if ttmpLevel == "Basic" {
            descTitleLabel.text = "기초문해 미션"
        }else if ttmpLevel == "Advanced"{
            descTitleLabel.text = "실질문해 미션"
        }
        
//        startMissionButton.layer.borderWidth = 1
//        startMissionButton.layer.borderColor = UIColor.darkGray.cgColor
        if UIDevice.current.userInterfaceIdiom == .pad {
            startMissionButton.layer.cornerRadius = 10
        }else {
            startMissionButton.layer.cornerRadius = startMissionButton.frame.size.width / 7
        }
        

        hintButton.layer.cornerRadius = 8
        hintButton.layer.borderWidth = 1
        hintButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //문제 읽어 주는 사운드
//        isBalwhaSound = UserDefaults.standard.bool(forKey: "balwhaSound")
//        if isBalwhaSound == true{
//            balwhaButton.setTitle("퀴즈 음성 ON", for: .normal)
//        }else{
//            balwhaButton.setTitle("퀴즈 음성 OFF", for: .normal)
//        }
//        setupUI()
        progressBarloc = Float(currentQuizIndex + 1) / Float(currentQuizPool.count)
        quizProgressView.setProgress(progressBarloc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        descriptionView.frame = view.frame
        view.addSubview(descriptionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        runloopStop = true
    }
    
    @IBAction func clickedStartMission(_ sender: Any) {
        
        print("clicked Start Mission")
        descriptionView.removeFromSuperview()
//        startTTS()
    }
    
    
    @IBAction func clickedHintButton(_ sender: Any) {
        print("clicked the hint")
        var bodyMessage = ""
        let tmpLevel = currentQuizPool[0].level
        let tmpSection = currentQuizPool[0].section
        print(currentQuizPool)
        //기초문해영역
        if tmpLevel == "Basic" {
            if tmpSection == 1{
                bodyMessage = "주어를 확인하세요."
            }else if tmpSection == 2{
                bodyMessage = "서술어를 확인하세요."
            }else if tmpSection == 3{
                bodyMessage = "조사를 확인하세요."
            }else if tmpSection == 4{
                bodyMessage = "어미를 확인하세요."
            }else if tmpSection == 5{
                bodyMessage = "관형어를 확인하세요."
            }else if tmpSection == 6{
                bodyMessage = "부사어를 확인하세요."
            }else if tmpSection == 7{
                bodyMessage = "문장부사어를 확인하세요."
            }else if tmpSection == 8{
                bodyMessage = "마침부호를 확인하세요."
            }
        }
        
        //실질문해영역
        if tmpLevel == "Advanced" {
            if tmpSection == 1{
                bodyMessage = "사실은 객관적 근거가 있어야 합니다."
            }else if tmpSection == 2{
                bodyMessage = "문제가 해결되었는지 확인하세요."
            }
        }
        let alert = AlertService().alert(title: "", body: bodyMessage, cancelTitle: "", confirTitle: "확인", thirdButtonCompletion:nil, fourthButtonCompletion: nil)
        present(alert, animated: true)
    }
    
    fileprivate func startTTS() { //TTS호출을 별도롤 분리, 미션을 설명하는 화면이 사라질 떄 호출할 예정
        
   
            
        self.typeAnimate(label: self.quizTextLabel, str : self.currentQuiz.jimun!, isBalwhaOn: false)
//        if isBalwhaSound == true {
//            let tts = TTS()
//            //TTS가 시작시 버튼 비활성화
//            changeButtonStatus(false)
//
//            tts.setText(currentQuiz.title) {
//                //TTS가 완료된 후 버튼 활성화
//                self.changeButtonStatus(true)
//
//                if self.currentQuiz.type == "글" {
//                    self.typeAnimate(label: self.quizTextLabel, str : self.currentQuiz.jimun!, isBalwhaOn: true)
//                }
//
//            }
//        }else{
//            self.typeAnimate(label: self.quizTextLabel, str : self.currentQuiz.jimun!, isBalwhaOn: false)
//        }
        
        
        
    }
    
    func setupUI(){
        runloopStop = false

        
        if currentQuiz.type == "Text" {
            changeButtonStatus(false)
        }
        
        quizProcessLabel.text = "\(currentQuizIndex + 1)/\(currentQuizPool.count)"
        quizProcessLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        quizProcessLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)

        
        let exampleArray = currentQuiz.example.components(separatedBy:"//")
        let exampleCount = exampleArray.count
        
        answer01Button.setTitle(exampleArray[0].trimmingCharacters(in: .whitespaces)
                            , for: .normal)
        answer01Button.layer.cornerRadius = 8
        answer01Button.layer.borderWidth = 1
        answer01Button.layer.borderColor = UIColor.lightGray.cgColor
        
        
        answer02Button.setTitle(exampleArray[1].trimmingCharacters(in: .whitespaces)
                            , for: .normal)
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
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let getImagePath = paths.appendingPathComponent("image/total/\(currentQuiz.imageName!)")

        if currentQuiz.type == "그림"{
            quizTextLabel.isHidden = true
            quizImage.isHidden = false
            quizImage.image = UIImage(contentsOfFile: getImagePath)
            quizImage.layer.cornerRadius = 12
            quizImage.layer.masksToBounds = true

        }else{
            quizTextLabel.isHidden = false
            quizImage.isHidden = true
            //ex) "마지막 하나 남은 방울토마토마저 썩어버렸다. #& 마저"
            
            if let isUnderline = currentQuiz.jimun?.contains("#&"){
                if isUnderline {
                    let splitTexts = currentQuiz.jimun?.components(separatedBy: "#&")
                    let tmpJimun = splitTexts?[0].trimmingCharacters(in: .whitespaces)
                    let tmpUnderline = splitTexts?[1].trimmingCharacters(in: .whitespaces)

                    
                    let tmpJimunAttributed = NSMutableAttributedString.init(string: tmpJimun!)
                    let originStr = NSString(string: tmpJimun!)
                    let theRange = originStr.range(of: tmpUnderline!)
                    tmpJimunAttributed.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:theRange)
                    
                    quizTextLabel.attributedText = tmpJimunAttributed
                    
                }else{
                    quizTextLabel.text = currentQuiz.jimun
                }
            }
            
            
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
    

        //문제 읽어 주는 사운드
//    @IBAction func clickedBalwhaButton(_ sender: Any) {
//        isBalwhaSound = !isBalwhaSound
//        if isBalwhaSound == true{
//            balwhaButton.setImage(UIImage(systemName: "speaker"), for: .normal)
//            balwhaButton.setTitle("퀴즈 음성 ON", for: .normal)
//        }else{
//            balwhaButton.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
//            balwhaButton.setTitle("퀴즈 음성 OFF", for: .normal)
//        }
//        UserDefaults.standard.set(isBalwhaSound, forKey: "balwhaSound")
//    }
    
    @IBAction func clickedBack(_ sender: Any) {
        dismiss(animated: true)
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
//        startTTS()
   
    }
    
    @IBAction func clickedTrueOrNotButton(_ sender: Any) {

        correctOrNotView.removeFromSuperview()
        for item in answerButtonImages {
            item.isHidden = true
        }
        
        if isCurrentMissionCompleted {
            print("MIssion Completed")
            completeView.frame = self.view.frame
            self.view.addSubview(completeView)
            
            //미션클리어시 사용자의 정보를 업데이트
            //앱이 background 진입시 Firebase로 전송됨.
            MyInfo.shared.numberOfHearts = MyInfo.shared.numberOfHearts + 1
//            MyInfo.shared.learningProgress = currentQuiz.mission
            
            //completeView의 사용자이름과 하트수 수정
            displayUsernameOnMissionClear.text = "\(MyInfo.shared.displayName)님은 총 \(MyInfo.shared.numberOfHearts)개의 하트를 모았어요!"
            
            
            
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.updateUI()
            }
            
        }
        
    }
    

    @IBAction func clickedMissionCompleted(_ sender: Any) {
        
            let currentMission = currentQuiz.mission
            if currentQuiz.section == 1 { // 1경에 데이터는 UserDefaults가 관리!!
                var dataDic = UserDefaults.standard.object(forKey: "tourUserData") as! [String: Any]
                print(dataDic)
                var completedMission = dataDic["1"] as! [Int]
                completedMission.append(currentMission)
                dataDic = ["1": completedMission ]
                UserDefaults.standard.set(dataDic, forKey: "tourUserData")
            }else {// 그 와에 데이터는 fireStore연동!!
                saveCurrentMission(section: "\(currentQuiz.section)" , level: currentQuiz.level, missionNum: currentQuiz.mission)
                saveStopStep(section: "\(currentQuiz.section)", level: currentQuiz.level, step: 0)
            }
        dismiss(animated: true) {
            self.delegate?.eightDetailDelegate()
        }
        
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
        if currentSection == "1" {
//            dismiss(animated: true)
        }else {
            let completedMission = retrieveCurrentMission(section: "\(currentQuiz.section)", level: currentQuiz.level)
            if currentQuiz.mission > completedMission {
                saveStopStep(section: "\(currentQuiz.section)", level: currentQuiz.level, step: currentQuizIndex)
                print("조회된: \(retrieveStopStep(section: "\(currentQuiz.section)", level: currentQuiz.level))")
            }
        }
        

        dismiss(animated: true)
    }
    
    func typeAnimate(label: UILabel, str:String, isBalwhaOn:Bool) {
        if quizStatus == .INCORRECT {
            changeButtonStatus(true)
            return
        }
        label.text = ""
        for i in str {
            if runloopStop == true {return}
            if isBalwhaOn == true {
                AudioServicesPlaySystemSound(1306)
            }
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
