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
    
    let samples = "이 나는 아침에 어디까지 맘고생하면 서서히우리는 학교에 간다.이 나는 아침에 어디까지 맘고생하면 서서히우리는 학교에 간다.이 나는 아침에 어디까지 맘고생하면 서서히우리는 학교에 간다.이 나는 아침에 어디까지 맘고생하면 서서히우리는 학교에 간다."
    var arr:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analyzeCollectionView.delegate = self
        analyzeCollectionView.dataSource = self
        
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        originSentenceLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        
        arr = samples.components(separatedBy: " ")
        
//        wordCollectionView.register(wordCollectionView.self, forCellWithReuseIdentifier: "wordCell")
    }
  

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == wordCollectionView {
            return arr.count
        }else{
            return 3
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
            
            if indexPath.row == 1 {
                cell.senTitleLabel.text = "나무가 부러질 것 같다."
                cell.senAdverbLabel.text = "-"
                cell.adjectiveLabel.text = "_"
                cell.subjectLabel.text = "바람"
                cell.josaLabel.text = "이"
                cell.adverbLabel.text = "강하게"
                cell.predicateLabel.text = "불"
                cell.eomiLabel.text = "어서"
                cell.endSignLabel.text = "-"
            }
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == wordCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "wordCell", for: indexPath
            ) as? WordCollectionViewCell else { return .zero }
            return cell.adjustCellSize(height: 40, label: arr[indexPath.item])
        }else{
            return CGSize(width: CGFloat(240).relativeToIphone8Height(), height: 420)
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
