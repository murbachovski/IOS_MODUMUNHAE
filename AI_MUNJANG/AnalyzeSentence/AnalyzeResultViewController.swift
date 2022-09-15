//
//  AnalyzeResultViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/26.
//

import UIKit

class AnalyzeResultViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    
    @IBOutlet weak var analyzeCollectionView: UICollectionView!
    @IBOutlet weak var originSentenceLabel: UILabel!
    
    @IBOutlet weak var wordCollectionView: UICollectionView!
    
    let samples = "이 나는 아침에 어디까지 맘고생하면 서서히우리는 학교에 간다."
    var arr:[String] = []
    var analyzedData : [String: Any] = [:]
    var dividedSentences : [String] = []
    var originalSentence = ""
    var analyzedEights : [String: Any] = [:]
    var analyzedDataEights : [[String : Any]] = [[:]]
    var pureSentence = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalSentence = (analyzedData["sen"] as! String)
        pureSentence = (analyzedData["sen"] as! String).replacingOccurrences(of: "VV", with: " ")
        dividedSentences = originalSentence.components(separatedBy: "VV")
//        analyzedEights = analyzedData["eight_div_sen"] as! [String:Any]
//        print("analyzedData_eight_div_sen:\(analyzedData["eight_div_sen"])")
        analyzedDataEights = analyzedData["eight_div_sen"] as! [[String : Any]]
        print("analyzedDataEights:\(analyzedDataEights)")
        // Do any additional setup after loading the view.
        analyzeCollectionView.delegate = self
        analyzeCollectionView.dataSource = self
        
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        originSentenceLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        originSentenceLabel.text = originalSentence.replacingOccurrences(of: "VV", with: "  ✓ ")
        arr = pureSentence.components(separatedBy: " ")
        for i in arr {
            if i == "" {
                arr.remove(at: arr.firstIndex(of: i)!)
            }
        }
        
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
//            analyzedDataEights[indexPath.row]["대상확장"] as? String
            
            let titleArray = (originSentenceLabel.text)?.components(separatedBy: "  ✓ ")
            cell.senTitleLabel.text = titleArray![indexPath.row]
            cell.senAdverbLabel.text = analyzedDataEights[indexPath.row]["문장확장"] as? String
            cell.adjectiveLabel.text = analyzedDataEights[indexPath.row]["대상확장"] as? String
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
