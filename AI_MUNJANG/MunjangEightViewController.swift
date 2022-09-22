//
//  MunjangEightViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit

class MunjangEightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var eightCollectionView: UICollectionView!
    
    //
    var sectionOne :QuizContents = []
    var sectionTwo :QuizContents = []
    var sectionThree :QuizContents = []
    var sectionFour :QuizContents = []
    var sectionFive :QuizContents = []
    var sectionSix :QuizContents = []
    var sectionSeven :QuizContents = []
    var sectionEight :QuizContents = []
    
    var sectionTotal :[QuizContents] = []
    
    var dataArray :Array<UIImage> = []
    //
    
    
    let munjangElements:[String] = ["주어", "서술어","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    let subElements: [String] = ["대상", "정보","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eightCollectionView.delegate = self
        eightCollectionView.dataSource = self
        
        self.eightCollectionView.register(UINib(nibName: "MunjangEightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.navigationItem.backButtonTitle = " "
    }
    
    // MARK: - Navigation
    
    
    @IBAction func clickedBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return munjangElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MunjangEightCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
        
        cell.digitTitle.text = "\(indexPath.row)경"
        
        cell.mainTitle.text = munjangElements[indexPath.row]
        cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: 15)
        cell.subTitle.text = subElements[indexPath.row]
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let munJangEightDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunJangEightDetailViewController")  as? MunJangEightDetailViewController else {return}
              munJangEightDetailViewController.naviTitle = "\(indexPath.row )경"
              munJangEightDetailViewController.mainTitleText = munjangElements[indexPath.row]

              munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionTotal[indexPath.row]
            print("😡😡😡 \(indexPath.row)경 선택")

            self.navigationController?.pushViewController(munJangEightDetailViewController, animated: true)
    }
}
