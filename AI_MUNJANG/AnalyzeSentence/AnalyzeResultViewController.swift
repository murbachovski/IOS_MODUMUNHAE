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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analyzeCollectionView.delegate = self
        analyzeCollectionView.dataSource = self
        
        
        originSentenceLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        
        
    }
  

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(240).relativeToIphone8Height(), height: 420)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}
