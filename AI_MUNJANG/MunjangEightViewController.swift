//
//  MunjangEightViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit

class MunjangEightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var eightCollectionView: UICollectionView!
    
    @IBOutlet var titleLabelTopHeight: NSLayoutConstraint!
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if self.view.frame.size.height < 1920 {
//            titleLabelTopHeight.constant = 20
//        }
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
        
        cell.digitTitle.text = "\(indexPath.row + 1)경"
        
        cell.mainTitle.text = munjangElements[indexPath.row]
        cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: 15)
        cell.subTitle.text = subElements[indexPath.row]
        
        if !Core.shared.isUserSubscription() {
            if indexPath.row != 0 {
                cell.lockImgView.image = UIImage(named: "icLock32Px")
            }
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 170, height: 80)
        let cellWidth = collectionView.frame.size.width - 40 - 20
        
        return CGSize(width: cellWidth / 2 , height: cellWidth / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !Core.shared.isUserSubscription() {
            if indexPath.row == 0 {
                changeNextPage(num: indexPath.row)
            }else {
                //알림창노출
                let alert = AlertService().alert(title: "구독", body: "구독 전이라 사용이 불가합니다.", cancelTitle: "확인", confirTitle: "구독하기") {
                    self.changeNextPage(num: indexPath.row)
                    // 사용자가 둘러보기 선택
                } fourthButtonCompletion: {
                    // 사용자가 구독하기 선택
                    guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                    subscriptionViewController.modalPresentationStyle = .fullScreen
                    self.present(subscriptionViewController, animated: true)
                    
                    print("cliocked subscribe")
                }
                present(alert, animated: true)
            }
        }else { //구독자들
            changeNextPage(num: indexPath.row)
        }
    }
    
    func changeNextPage(num: Int) {
        
        guard let munJangEightDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunJangEightDetailViewController")  as? MunJangEightDetailViewController else {return}
        if num + 1 != 1 {
                let toLearningMission = retrieveCurrentMission(gyung: "\(num + 1)경")
                munJangEightDetailViewController.toLearningMission = toLearningMission
            }
            munJangEightDetailViewController.naviTitle = "\(num + 1)경"
              munJangEightDetailViewController.mainTitleText = munjangElements[num]

              munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionTotal[num]
            print("😡😡😡 \(num + 1)경 선택")
        print("8경 메인에서의 사용자 정보:\(MyInfo.shared.learningProgress)")
            self.navigationController?.pushViewController(munJangEightDetailViewController, animated: true)
    }
}
