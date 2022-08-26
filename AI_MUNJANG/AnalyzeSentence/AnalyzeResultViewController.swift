//
//  AnalyzeResultViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/26.
//

import UIKit

class AnalyzeResultViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Any else {
                   return UICollectionViewCell()
               
            
            //셀의 내용 채우기
//            cell.digitTitle.text = "Mission \(indexPath.row + 1)"
//
//            cell.mainTitle.text = munjangElements[indexPath.row]
//            cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: 15)
//            cell.subTitle.text = subElements[indexPath.row]
            
//            //셀에 shadow추가
//            cell.backgroundColor = .white
//            cell.layer.cornerRadius = 10
//            cell.layer.shadowOpacity = 0.8
//            cell.layer.shadowColor = UIColor.lightGray.cgColor
//            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
//            cell.layer.shadowRadius = 2
//            cell.layer.masksToBounds = false
            
            
                    
            return cell
    }
    
    @IBOutlet weak var analyzeCollectionView: UICollectionView!
    
    @IBOutlet weak var originSentenceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analyzeCollectionView.delegate = self
        analyzeCollectionView.dataSource = self
        
        
        originSentenceLabel.font = UIFont(name: "NanumSquareEB", size: 17)
        
        
    }
  

}
