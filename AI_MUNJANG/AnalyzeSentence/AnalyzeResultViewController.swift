//
//  AnalyzeResultViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/26.
//

import UIKit

class AnalyzeResultViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var buttonIndex: UIButton!
    @IBOutlet var buttonCorrection: UIButton!
    @IBOutlet var buttonInference: UIButton!
    
    @IBOutlet weak var labelAnalyze: UILabel!
    
    @IBOutlet weak var analyzeCollectionView: UICollectionView!
    @IBOutlet weak var originSentenceLabel: UILabel!
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    
    var arr:[String] = []
    var analyzedData : [String: Any] = [:]
    var dividedSentences : [String] = []
    var originalSentence = ""
    var analyzedEights : [String: Any] = [:]
    var analyzedDataEights : [[String : Any]] = [[:]]
    var pureSentence = ""
    var titleArray: [String] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalSentence = (analyzedData["sen"] as! String)
        pureSentence = (analyzedData["sen"] as! String).replacingOccurrences(of: "VV", with: " ")
        dividedSentences = originalSentence.components(separatedBy: "VV")

        guard let temp = analyzedData["eight_div_sen"] as? [[String : Any]] else {return}
        analyzedDataEights = temp
        print("analyzedDataEights:\(analyzedDataEights)")
        // Do any additional setup after loading the view.
        analyzeCollectionView.delegate = self
        analyzeCollectionView.dataSource = self
        
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        originSentenceLabel.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ?  20 : 17)
        originSentenceLabel.text = originalSentence.replacingOccurrences(of: "VV", with: "  ✓ ")
        arr = pureSentence.components(separatedBy: " ")
        for i in arr {
            if i == "" {
                arr.remove(at: arr.firstIndex(of: i)!)
            }
        }
        
        
        buttonInference.layer.cornerRadius = buttonInference.frame.size.height / 2
        buttonInference.layer.shadowOpacity = 0.8
        buttonInference.layer.shadowColor = UIColor.lightGray.cgColor
        buttonInference.layer.shadowOffset = CGSize(width: 1, height: 1)
        buttonInference.layer.shadowRadius = 2
        buttonInference.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        buttonCorrection.layer.cornerRadius = buttonCorrection.frame.size.height / 2
        buttonCorrection.layer.shadowOpacity = 0.8
        buttonCorrection.layer.shadowColor = UIColor.lightGray.cgColor
        buttonCorrection.layer.shadowOffset = CGSize(width: 1, height: 1)
        buttonCorrection.layer.shadowRadius = 2
        buttonCorrection.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        buttonIndex.layer.cornerRadius = buttonIndex.frame.size.height / 2
        buttonIndex.layer.shadowOpacity = 0.8
        buttonIndex.layer.shadowColor = UIColor.lightGray.cgColor
        buttonIndex.layer.shadowOffset = CGSize(width: 1, height: 1)
        buttonIndex.layer.shadowRadius = 2
        buttonIndex.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
       
        
        
        displayHomeBtn()
    }
  
    @IBAction func clickedInferenceButton(_ sender: Any) {
        
        let url = "http://118.67.133.8/sen_infer/m" //문장 추론 접근용
        let sen = titleArray.joined(separator: " VV ")
        requestByInfer(url: url, sen: sen) { dicData in
            DispatchQueue.main.async {
                guard let inferenceViewController = self.storyboard?.instantiateViewController(withIdentifier: "InferenceViewController")  as? InferenceViewController else {return}
                inferenceViewController.contentsData = dicData
                self.navigationController?.pushViewController(inferenceViewController, animated: true)
            }
        }
        
    }
    
    @IBAction func clickedCorrectionButton(_ sender: Any) {
        let url = "http://118.67.133.8/sen_correction/m"
//        let url = "http://127.0.0.1:5000/sen_correction/m"
//        let sen = "나는 학교에 가고 엄마와 회사에 간다."
        let sen = titleArray.joined(separator: " ")
        
        requestByCorrection(url: url, sen: sen) { dicData in
            DispatchQueue.main.async {
                guard let correctionViewController = self.storyboard?.instantiateViewController(withIdentifier: "CorrectionViewController")  as? CorrectionViewController else {return}
                correctionViewController.dicData = dicData
                correctionViewController.originSentence = sen
                self.navigationController?.pushViewController(correctionViewController, animated: true)
            }
        }
    }
    
    @IBAction func clickedIndexButton(_ sender: Any) {
        let url = "http://118.67.133.8/sen_index/m"
//        let url = "http://127.0.0.1:5000/sen_index/m"
//        let sen = "나는 학교에 가고 엄마와 회사에 간다."
        let sen = titleArray.joined(separator: " ")
        
        requestByIndex(url: url, sen: sen) { dicData in
            DispatchQueue.main.async {
                guard let senIndexViewController = self.storyboard?.instantiateViewController(withIdentifier: "SenIndexViewController")  as? SenIndexViewController else {return}
//                senIndexViewController.dicData = dicData
                senIndexViewController.originSentence = sen
                senIndexViewController.senGrade = dicData["grade"] as! Int
                
                // 낱말지수 구하기
                var tmpWordData:[String] = []
                let part_lex_grade_dic = dicData["part_lex_grade"] as! [String:Any]
                
                for (k, v) in  part_lex_grade_dic{
                    let value = "\(v)"
                    if value == "1" {
                        tmpWordData.append("\(k) - 초급")
                    }else if value == "2" {
                        tmpWordData.append("\(k) - 중급")
                    }else if value == "3" {
                        tmpWordData.append("\(k) - 고급")
                    }else{
                        tmpWordData.append("\(k) - 전문")
                    }
                }
                tmpWordData.sort()
                
                //형태소 지수 구하기
                var tmpMorphsData:[String] = []
                let tmpKorTag = dicData["kor_tag"] as! [String:String]
                let totalLexTag = dicData["total_lex_tag"] as! [String:String]
                for (k,v) in totalLexTag{
                    let value = tmpKorTag[v]!
                    tmpMorphsData.append("\(k) - \(value)")
                }
                tmpMorphsData.sort()
                
                
                senIndexViewController.wordData = tmpWordData
                senIndexViewController.morphData = tmpMorphsData
                senIndexViewController.phraseData = dicData["phrases"] as! [String]
                self.navigationController?.pushViewController(senIndexViewController, animated: true)
            }
        }
    }
    
    
    
    @IBAction func clickedClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - HELPER
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
        
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.leftBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -4, left: -5, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == wordCollectionView {
            return arr.count
        }else{
            return analyzedDataEights.count
        }
        
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == wordCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
            cell.titleLabel.text = arr[indexPath.row]
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.cornerRadius = cell.frame.size.height / 2
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowRadius = 2
            cell.layer.masksToBounds = false
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnalyzeCollectionViewCell
            cell.contentView.layer.cornerRadius = 16
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowRadius = 2
            cell.layer.masksToBounds = false

            
            titleArray = ((originSentenceLabel.text)?.components(separatedBy: "  ✓ "))!
            cell.senTitleLabel.text = titleArray[indexPath.row]
            cell.senAdverbLabel.text = analyzedDataEights[indexPath.row]["문장확장"] as? String
            
            //관형사의 경우는 앞정보확장과 대상확장의 결합임
            let beforeInfoExtension:String = analyzedDataEights[indexPath.row]["앞정보확장"] as? String ?? ""
            let subjectExtension:String =  analyzedDataEights[indexPath.row]["대상확장"] as? String ?? ""
            cell.adjectiveLabel.text = beforeInfoExtension + subjectExtension
            
            cell.subjectLabel.text = analyzedDataEights[indexPath.row]["대상"] as? String
            cell.josaLabel.text = analyzedDataEights[indexPath.row]["대상알림"] as? String
            cell.adverbLabel.text = analyzedDataEights[indexPath.row]["뒤정보확장"] as? String
            cell.predicateLabel.text = analyzedDataEights[indexPath.row]["정보"] as? String
            cell.eomiLabel.text = analyzedDataEights[indexPath.row]["정보알림"] as? String
            cell.endSignLabel.text = analyzedDataEights[indexPath.row]["마침표"] as? String
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == wordCollectionView {
            
            //😍아래의 코드 4줄이 아이폰XR에서는 정상, 아이폰XS, 6s에서 Crash 유발😍
            //collectionView.dequeueReusableCell에서 인덱스 초과에 따른 Crash발생
            
            
            //            guard let cell = collectionView.dequeueReusableCell(
            //                withReuseIdentifier: "wordCell", for: indexPath
            //            ) as? WordCollectionViewCell else { return .zero }
            //            return cell.adjustCellSize(height: 40, label: arr[indexPath.item])
            
            
            
            
            //😍일단 Crash를 피하기위해 셀에 들어오는 문자열의 길이에 따라 라벨의 width를 결정😍
            return CGSize(width: CGFloat(15).relativeToIphone8Width() * CGFloat(arr[indexPath.row].count) + CGFloat(40).relativeToIphone8Width(), height: 40)

        }else{
            return CGSize(width: CGFloat(240).relativeToIphone8Height(), height: 420)
        }
        
    }
    
   

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == wordCollectionView {
            return 12
        }
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(arr[indexPath.row])
        
        //사파리로 링크열기
        if collectionView == wordCollectionView {
            let queryStr = arr[indexPath.row]
            let urlString = queryStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

            if let url = URL(string: "https://ko.dict.naver.com/#/search?query=\(urlString)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        

    }

}



class WordCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
