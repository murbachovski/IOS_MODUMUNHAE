//
//  MunjangEightViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit

class MunjangEightViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var subImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var eightCollectionView: UICollectionView!
    
//    @IBOutlet var titleLabelTopHeight: NSLayoutConstraint!
    
    var sectionTotal :[QuizContents] = []
    
    var dataArray :Array<UIImage> = []
    
    var currentLevel = "Basic"
    let munjangElements:[String] = ["주어", "서술어","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    let subElements: [String] = ["대상", "정보","대상알림", "정보알림","대상에 뜻 추가","정보에 뜻 추가","문장에 뜻 추가","문장알림"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eightCollectionView.delegate = self
        eightCollectionView.dataSource = self
        
        self.eightCollectionView.register(UINib(nibName: "MunjangEightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        if currentLevel == "Basic"{
//            self.navigationItem.title = ""
        }else{
//            self.navigationItem.title = ""
                self.imgView.image = UIImage(named: "bg6")
                self.titleLabel?.text = "실질문해 미션"
                self.subTitleLabel?.text = "문해를 통해 문제를 해결하기"
        }
        
        displayHomeBtn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if self.view.frame.size.height < 1920 {
//            titleLabelTopHeight.constant = 20
//        }
    }
    
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.rightBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    // MARK: - Navigation
    
    
    @IBAction func clickedBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentLevel == "Basic" {
            return munjangElements.count
        }else if currentLevel == "Advanced" {
            return QuizContentData.shared.sectionAdvancedTotal.count
        }
            return 1
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
        if currentLevel == "Basic" {
            cell.digitTitle.text = "\(indexPath.row + 1)"
            
            cell.mainTitle.text = munjangElements[indexPath.row]
            cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 26:  15)
            cell.subTitle.text = subElements[indexPath.row]
            cell.subTitle.font = UIFont(name: "NanumSquareB", size: UIDevice.current.userInterfaceIdiom == .pad ? 22:  11)
            
            if !Core.shared.isUserSubscription() {
                if indexPath.row != 0 {
                    cell.lockImgView.image = UIImage(named: "icLock32Px")
                }
            }
        }else {
            if indexPath.row == 0 {
                cell.digitTitle.text = "\(indexPath.row + 1)."
                
                cell.mainTitle.text = "사실과 의견"
                cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 26:  15)
                
                cell.subTitle.text = "구별하기"
                cell.subTitle.font = UIFont(name: "NanumSquareB", size: UIDevice.current.userInterfaceIdiom == .pad ? 22:  11)
                
                if !Core.shared.isUserSubscription() {
                    if indexPath.row != 0 {
                        cell.lockImgView.image = UIImage(named: "icLock32Px")
                    }
                }
            }
            if indexPath.row == 1{
                cell.digitTitle.text = "\(indexPath.row + 1)."
                
                cell.mainTitle.text = "문제 해결"
                cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 26:  15)
                
                cell.subTitle.text = "사고력 키우기"
                cell.subTitle.font = UIFont(name: "NanumSquareB", size: UIDevice.current.userInterfaceIdiom == .pad ? 22:  11)
                
                if !Core.shared.isUserSubscription() {
                    if indexPath.row != 0 {
                        cell.lockImgView.image = UIImage(named: "icLock32Px")
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 170, height: 80)
        let cellWidth = collectionView.frame.size.width - 40 - 20
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: cellWidth / 2.5 , height: cellWidth / 5)
        }else{
            return CGSize(width: cellWidth / 2 , height: cellWidth / 4)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !Core.shared.isUserSubscription() {
            if indexPath.row == 0 {
                changeNextPage(num: indexPath.row)
            }else {
                //알림창노출
                let alert = AlertService().alert(title: "", body: "문제 풀이 제한이 있습니다.\n자유롭게 사용하려면 구독해 주세요.", cancelTitle: "확인", confirTitle: "구독하기") {

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
            
            if !Core.shared.isUserLogin() {
                if indexPath.row == 0 {
                    changeNextPage(num: indexPath.row)
                }else {
                    let alert = AlertService().alert(title: "", body: "앱의 원활한 사용을 위해 \n로그인이 필요합니다.", cancelTitle: "취소", confirTitle: "확인",thirdButtonCompletion: nil, fourthButtonCompletion: {
                        changeLoginNC()
                    })
                    self.present(alert, animated: true)
                }
                
            }else{
                print("clicked \(indexPath.row+1)경 클릭")
                changeNextPage(num: indexPath.row)
            }
            
        }
    }
    
    func changeNextPage(num: Int) {
        
        guard let munJangEightDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunJangEightDetailViewController")  as? MunJangEightDetailViewController else {return}
        if num + 1 != 1 {
            let toLearningMission = retrieveCurrentMission(section: "\(num+1)", level: currentLevel)
                munJangEightDetailViewController.toLearningMission = toLearningMission
            }
        if currentLevel == "Basic" {
            munJangEightDetailViewController.naviTitle = "\(num + 1)"
              munJangEightDetailViewController.mainTitleText = munjangElements[num]
            munJangEightDetailViewController.recievedSectionIndex = num + 1
            munJangEightDetailViewController.currentLevel = currentLevel
              munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionTotal[num]
        }else {
            munJangEightDetailViewController.naviTitle = "사실"
              munJangEightDetailViewController.mainTitleText = "사실"
              munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionAdvancedTotal[num]
            print(munJangEightDetailViewController.currentSectionCotents.count)
            munJangEightDetailViewController.recievedSectionIndex = num + 1
            munJangEightDetailViewController.currentLevel = currentLevel
        }
            print("😡😡😡 \(num + 1) 선택")
        print("8 메인에서의 사용자 정보:\(MyInfo.shared.learningProgress)")
            self.navigationController?.pushViewController(munJangEightDetailViewController, animated: true)
    }
}
