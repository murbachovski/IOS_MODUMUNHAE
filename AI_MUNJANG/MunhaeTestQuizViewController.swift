//
//  MunjangQuizViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/05.
//

import UIKit
import AVFoundation
import Charts

enum TestQuizStatus {
    case NONE
    case CORRECT
    case INCORRECT
}

class MunhaeTestQuizViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var moreQuizButton: UIButton!
    @IBOutlet var resultContainerView: UIView!
    
    @IBOutlet var resultGuideLabel: UILabel!
    
    @IBOutlet var barChartView: BarChartView!
    
    @IBOutlet var testResultView: UIView!
    
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
    
    
    @IBOutlet var munhaeTestStartBackButton: UIButton!
    
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
    
//    var audioPlayer: AVAudioPlayer? // AVAudioPlayer 인스턴스 참조체 저장
    
    var quizStatus: TestQuizStatus = .NONE
    
    var currentQuizPool:MunhaeTestContents = []
    
    var currentQuizIndex = 0
    lazy var currentQuiz = MunhaeTestContent(testnumber: 0, id: 0, title: "", jimun: nil, example: "", result: "")

    var answerButtons : [UIButton] = []
    var answerButtonImages : [UIImageView] = []
    var progressBarloc: Float = 0
    
    var testResult: [String: Double] = [
        "글자":0.0,
        "낱말":0.0,
        "문장":0.0,
        "문맥":0.0,
    ]
    var testRecommendResult: [String: Double] = [:]
    var testRecommentFailResult:[String] = []
    var testFailResult: [String] = []
    
     var isRecommendPool = false
    
    var nonPassedRecommendSection = [String]()
    
    //MARK: - View Life Cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentQuiz = currentQuizPool[currentQuizIndex]
        
        resultContainerView.backgroundColor = .white
        resultContainerView.layer.cornerRadius = 10
        resultContainerView.layer.shadowOpacity = 0.8
        resultContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        resultContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        resultContainerView.layer.shadowRadius = 2
        resultContainerView.layer.masksToBounds = false
        
        
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
        
        
        
        quizProgressView.progress = 0.0
        quizProgressView.tintColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        //TODO: descTitle 과 descSubTitle을 이곳에서 설정해야 currentQuiz 참조
        if UIDevice.current.userInterfaceIdiom == .pad {
            descriptionTitle.font = UIFont(name: "NanumSquareEB", size: 22)
            descriptionSubTitle.font = UIFont(name: "NanumSquareB", size: 20)
            descriptionStartButton.layer.cornerRadius = 10
        }else {
            descriptionTitle.font = UIFont(name: "NanumSquareEB", size: 18)
            descriptionSubTitle.font = UIFont(name: "NanumSquareB", size: 14)
            descriptionStartButton.layer.cornerRadius = descriptionStartButton.frame.size.width / 7
        }
       
        
        initView()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        submitButton.layer.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor).cgColor
        submitButton.layer.cornerRadius = 10
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
    
    fileprivate func initView() {
        currentQuizIndex = 0
        testRecommentFailResult = []
        testRecommentFailResult = []
        setUpBarChart()
        quizTextLabel.text = ""
        nonPassedRecommendSection = []
        
        currentQuiz = currentQuizPool[0]
        print("CurrentQuiz : \(currentQuiz)")
        setupUI()
    }
    //MARK: - IBAction
    
    
    
    @IBAction func clickedMoreQuizButton(_ sender: Any) {
        //데이터 초기화
        
        currentQuizPool = setupRecommentTestPool(dataSection: nonPassedRecommendSection)
        initView()
        
        
        //결과화면 닫기
        testResultView.removeFromSuperview()
        completeView.removeFromSuperview()
        
    }
    @IBAction func clickedConfirmResult(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clickedPresentResult(_ sender: Any) {
        
        view.addSubview(testResultView)
        testResultView.frame = self.view.frame
        //일단 moreQuizbutton을 숨김
        moreQuizButton.isHidden = true
        var tmpKeyArray = [String]()
        var tmpValueArray = [Double]()
        if isRecommendPool == false {
            
            tmpKeyArray = ["글자", "낱말", "문장", "문맥"]
            tmpValueArray = [Double(testResult["글자"]!), Double(testResult["낱말"]!), Double(testResult["문장"]!), Double(testResult["문맥"]!)]
        }else{
            
            //정답을 하나도 맞추지 못한 영역이라도  0점이라도 주어 그래프에 표시되어야
            //(틀린영역 - 맞춘점수가 있는 영역)하여 기재되지 못한 영역을 찾는다
            
            let missingSection = testRecommentFailResult.filter { !(testRecommendResult.keys.contains($0)) }
            if missingSection.count > 0 {
                for k in 0..<missingSection.count{
                    testRecommendResult[missingSection[k]] = 0
                }
            }
            
            
            let sortedDic = testRecommendResult.sorted { $0.0 < $1.0 }
            for i in 0..<sortedDic.count {
                tmpKeyArray.append(sortedDic[i].key)
                tmpValueArray.append(sortedDic[i].value)
            }

        
        }
        setChart(dataPoints: tmpKeyArray, values: tmpValueArray)
        //TODO: 사용자의 시험결과에 대한 가이드로직 필요.
        print("호출clickedPresentResult")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.setUpResultGuideLabel()
        }
    }
    
    func setUpResultGuideLabel() {
        print("호출setUpResultGuideLabel")
        if isRecommendPool {
            
            let nonPassedSection = testRecommendResult.filter({$0.value <= 7.0}).keys.sorted()
            nonPassedRecommendSection = nonPassedSection //낙제받은 팔경의 문제를 나중에 재구성하기 위해
            
            
            let normalPassedSection = testRecommendResult.filter({$0.value <= 7.0 && $0.value < 9.0}).keys.sorted()

            if nonPassedSection.count > 0{ //낙제
                moreQuizButton.isHidden = false
                resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은 \(nonPassedSection.map{String($0)}.joined(separator: ",")) 영역에서  미진한 실력을 가지고 있습니다."
            }else{
                moreQuizButton.isHidden = true
                if normalPassedSection.count > 0 {
                    resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은  문장을 이해하는 보통의 실력을 가지고 있습니다."
                }else{
                    resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은  문장을 이해하는 좋은 실력을 가지고 있습니다."
                }
                

            }
            
        }else {
//            testResult = testResult.filter({$0.value <= 6.0})
            moreQuizButton.isHidden = true
            let nonPassedSection = testResult.filter({$0.value <= 7.0}).keys.sorted()
            let normalPassedSection = testResult.filter({$0.value >= 7.0 && $0.value <= 9.0}).keys.sorted()
//            let goodPassedSection = testRecommendResult.filter({$0.value >= 9.0}).keys.sorted()
            
            if nonPassedSection.count > 0 {
                resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은 \(nonPassedSection.map{String($0)}.joined(separator: ",")) 영역에서 다소 미진한 실력을 가지고 있습니다."
            }else{
                if normalPassedSection.count > 0 {
                    resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은 문해력을 이해하는 보통의 실력을 가지고 있습니다."
                }else{
                    resultGuideLabel.text = "\(MyInfo.shared.displayName) 님은 문해력을 이해하는 좋은 실력을 가지고 있습니다."
                }
            }
        }
        
    }
    
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
        //문제 읽어 주는 기능
//        startTTS()
    }
    @IBAction func closedButton(_ sender: Any) {
        munhaeStopMessageView.frame.size.width = view.frame.size.width
        view.addSubview(munhaeStopMessageView)
//        dismiss(animated: true)
    }
    
    @IBAction func munhaeTestStartBackButton(_ sender: Any) {
        dismiss(animated: true)
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
                    
                    
                    if isRecommendPool == false{
                        //currentQuiz의 1문제 점수, 서버에서 내려오는 값중 글자,낱말 등을 구분하기 어려워
                        //개별점수를 문제개수에 따라 하드코딩함
                        
                        let scorePerChar = 10.0 / Double(4)
                        let scorePerWord = 10.0 / Double(4)
                        let scorePerSen = 10.0 / Double(6)
                        let scorePerContext = 10.0 / Double(6)
                        
                        if 0 <= currentQuiz.id && currentQuiz.id < 4 { //4문제
                            testResult["글자"] = testResult["글자"]! + scorePerChar
                        }else if 4 <= currentQuiz.id && currentQuiz.id < 8 { //4문제
                            testResult["낱말"] = testResult["낱말"]! + scorePerWord
                        }else if 8 <= currentQuiz.id && currentQuiz.id < 14 { //6문제
                            testResult["문장"] = testResult["문장"]! + scorePerSen
                        }else if 14 <= currentQuiz.id && currentQuiz.id < 20 { //6문제
                            testResult["문맥"] = testResult["문맥"]! + scorePerContext
                        }
                    }else{ //추천 문제 풀이
                        
                        //currentQuiz의 1문제 점수
                        var currentQuizSectionCount = 0
                        var currentQuizSectionTotal = [MunhaeTestContent]()
                        for item in currentQuizPool {
                            if item.testnumber == currentQuiz.testnumber{
                                currentQuizSectionTotal.append(item)
                            }
                        }
                        currentQuizSectionCount = currentQuizSectionTotal.count
                        let scorePerQuiz = 10.0 / Double(currentQuizSectionCount)
                        
                        testRecommendResult["\(currentQuiz.testnumber)경"] = (testRecommendResult["\(currentQuiz.testnumber)경"] ?? 0.0) + 1.0 * scorePerQuiz
                        
                    }
                    
                    
                }else {
                    print("오답")
                    //한문제라도 틀리면 사용자 취약 부분으로 제시함
                    if isRecommendPool {
                        if !testRecommentFailResult.contains("\(currentQuiz.testnumber)경"){
                            testRecommentFailResult.append("\(currentQuiz.testnumber)경")
                        }
                        
                    }else{
                        if 0 <= currentQuiz.id && currentQuiz.id < 4 {
                            if !testFailResult.contains("글자"){
                                testFailResult.append("글자")
                            }
                        }else if 4 <= currentQuiz.id && currentQuiz.id < 8 {
                            if !testFailResult.contains("낱말"){
                                testFailResult.append("낱말")
                            }
                        }else if 8 <= currentQuiz.id && currentQuiz.id < 14 {
                            if !testFailResult.contains("문장"){
                                testFailResult.append("문장")
                            }
                        }else if 14 <= currentQuiz.id && currentQuiz.id < 20 {
                            if !testFailResult.contains("문맥"){
                                testFailResult.append("문맥")
                            }
                        }
                        
                        
                    }
                    
                    
                }
            }
        }
        if currentQuizIndex < currentQuizPool.count - 1 {
            currentQuizIndex += 1
            currentQuiz = currentQuizPool[currentQuizIndex]
        }else{
            if isRecommendPool == false {
                print("시험완료 : 결과 : \(testResult)")
            }else{
                print("시험완료 : 결과 : \(testRecommendResult)")
            }
            
            completeView.frame = view.frame
            view.addSubview(completeView)
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
        
//            let tts = TTS()
//            //TTS가 시작시 버튼 비활성화
//            changeButtonStatus(false)
//
//            tts.setText(currentQuiz.title) {
//                //TTS가 완료된 후 버튼 활성화
//                self.changeButtonStatus(true)
//        }
    }
    
    func setupUI(){
        
        print("😀현재문제😀: \(currentQuiz)")
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
        
        if exampleCount == 2 {
            exampleButton03.isHidden = true
            
        }else if exampleCount == 3 {
            exampleButton04.isHidden = true
            
            exampleButton03.isHidden = false
            exampleButton03.setTitle(exampleArray[2].trimmingCharacters(in: .whitespaces), for: .normal)
            exampleButton03.layer.cornerRadius = 8
            exampleButton03.layer.borderWidth = 1
            exampleButton03.layer.borderColor = UIColor.lightGray.cgColor
            
        }else {
            
            exampleButton03.isHidden = false
            exampleButton03.setTitle(exampleArray[2].trimmingCharacters(in: .whitespaces), for: .normal)
            exampleButton03.layer.cornerRadius = 8
            exampleButton03.layer.borderWidth = 1
            exampleButton03.layer.borderColor = UIColor.lightGray.cgColor
            
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
        
        

    }
    
    func updateUI(){
        progressBarloc = Float(currentQuizIndex + 1) / Float(currentQuizPool.count)
        quizProgressView.setProgress(progressBarloc, animated: true)
        
        setupUI()
//        startTTS()
   
    }
    fileprivate func changeButtonStatus(_ isStatus: Bool) {
        exampleButton01.isUserInteractionEnabled = isStatus
        exampleButton02.isUserInteractionEnabled = isStatus
        exampleButton03.isUserInteractionEnabled = isStatus
        exampleButton04.isUserInteractionEnabled = isStatus
    }
    //MARK: - Helper Method
    fileprivate func setUpBarChart() {
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "\(MyInfo.shared.displayName)님")
        
        // 선택 안되게
        chartDataSet.highlightEnabled = false
        // 줌 안되게
        barChartView.doubleTapToZoomEnabled = false
        
        // X축 레이블 위치 조정
        barChartView.xAxis.labelPosition = .bottom
        // X축 레이블 포맷 지정
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 오른쪽 레이블 제거
        barChartView.rightAxis.enabled = false
        // 왼쪽 레이블 제거
        barChartView.leftAxis.enabled = false
        
        //기본 애니메이션
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        //옵션 애니메이션
        //barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        // 맥시멈
        barChartView.leftAxis.axisMaximum = 12
        // 미니멈
        barChartView.leftAxis.axisMinimum = 0
        
        //background grid
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.gridColor = .clear
        barChartView.rightAxis.gridColor = .clear
        
        // 차트 컬러
        chartDataSet.colors = [hexStringToUIColor(hex: "#b7ecff"),
                               hexStringToUIColor(hex: "#eeb7ff"),
                               hexStringToUIColor(hex: "#ffcab7"),
                               hexStringToUIColor(hex: "#c8ffb7")]
        

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        //추후 수정가능 막대기 위에 숫자 표시 관련
        barChartView.barData?.maxEntryCountSet?.drawValuesEnabled = false
        
        //legend숨김
        barChartView.legend.enabled = false
        
        //width size
        barChartView.barData?.barWidth = 0.5
    }
    
    
    func setupRecommentTestPool(dataSection:[String])-> MunhaeTestContents{
        
        
        //1. tmpContent를 quizContents에서 발췌 24
        
        //2. quizContents의 유형을 MunhaeTestContent로 전환
        
        //3 .MunhaeTestContents를 반환
        let listStringToSetup = dataSection.map({$0.replacingOccurrences(of: "경", with: "")})
        let listIntToSetup = listStringToSetup.map({Int($0)})
        var tmpListTt = [QuizContent]()
        for k in 0..<8{
            if listIntToSetup.contains(k+1){
                var tmpList = [QuizContent]()
                let tmp = QuizContentData.shared.sectionTotal[k]
                
                for i in tmp {
                    if i.type == "글"{
                        tmpList.append(i)
                    }
                }
                tmpListTt += tmpList.shuffled().prefix(Int(24/(listIntToSetup.count)))
            }
            
        }
        
        print(tmpListTt)
        print(tmpListTt.count)
        var recommendPool: MunhaeTestContents = [MunhaeTestContent]()
        for (index, element) in tmpListTt.enumerated() {
            //element.section을 testnumber로 치환(경)하여 틀린문제를 추적한다.
            let tmpContent = MunhaeTestContent(testnumber:element.section , id: index + 1, title: element.title, jimun: element.jimun, example: element.example, result: element.result!)
            recommendPool.append(tmpContent)
        }
        
        print("recommentPool : \(recommendPool)")
        return recommendPool
        
    }
}
