//
//  MainViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    
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
    
    var titles :Array<String> = []
    var nowPage: Int = 0
    
    var serverVersion = 0
    
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewEight: UICollectionView!
    
    let munjangElements:[String] = ["주어", "서술어","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    let subElements: [String] = ["대상", "정보","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        collectionViewEight.collectionViewLayout = layout
        layout.estimatedItemSize = CGSize(width: CGFloat(162).relativeToIphone8Width() , height: CGFloat(80).relativeToIphone8Width())
        collectionViewEight.delegate = self
        collectionViewEight.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        collectionViewEight.backgroundColor = .clear
        
        self.navigationItem.backButtonTitle = " "
        setupUI()
        
    }

    
    
   
    
    
    func setupUI(){
        nowPage = 0
        dataArray = [UIImage(named: "illust1.png")!, UIImage(named: "illust2.png")!, UIImage(named: "illust3.png")!]
        titles = ["문해력의 출발은 \n문장력입니다!","문장공부 \n해야 합니다!", "꾸준하게 키워가는 \n나의 문해력"]
//        topTitle.font = UIFont(name: "NanumSquareEB", size: 24)
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#F9F9F9")
        print("사용자가 구독 중인가? : \(Core.shared.isUserSubscription())")
        
        bannerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .white
        timer?.invalidate()
        
    }

    //사용자가 구독 페이지 누른 경우 MainViewCotnroller는 그것을 인지하고 회원가입페이지를 띄어야 한다.
    @IBAction func clickedUserIcon(_ sender: UIBarButtonItem) {
        guard let myPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController")  as? MyPageViewController else {return}
        navigationController?.pushViewController(myPageViewController, animated: true)
    }
    
    @IBAction func clickedTestButton(_ sender: Any) {
        guard let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")  as? TestViewController else {return}
        navigationController?.pushViewController(testViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == bannerCollectionView {
                return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }   else {
                return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
                return 3
        }   else {
                return munjangElements.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
                    cell.bannerImg.image = dataArray[indexPath.row]
            cell.title.text = titles[indexPath.row]
                    return cell
        }   else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MunjangEightCollectionViewCell else {
                   return UICollectionViewCell()
               }
            
            //셀의 내용 채우기
            cell.digitTitle.text = "\(indexPath.row + 1)경"
            
            cell.mainTitle.text = munjangElements[indexPath.row]
            cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: 15)
            cell.subTitle.text = subElements[indexPath.row]
            
            //셀에 shadow추가
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 10
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
            cell.layer.shadowRadius = 2
            cell.layer.masksToBounds = false
            
            
                    
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked : \(indexPath.row)")
        
        guard let munJangEightDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunJangEightDetailViewController")  as? MunJangEightDetailViewController else {return}
        munJangEightDetailViewController.naviTitle = "\(indexPath.row + 1 )경"
        munJangEightDetailViewController.mainTitleText = munjangElements[indexPath.row]
        munJangEightDetailViewController.subTitleText = "(\(subElements[indexPath.row]))"
        
        munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionTotal[indexPath.row]
        self.navigationController?.pushViewController(munJangEightDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 14 // Keep whatever fits for you
     }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == bannerCollectionView
            nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == bannerCollectionView {
//            return CGSize(width: bannerCollectionView.frame.size.width  , height:  bannerCollectionView.frame.height)
//        }
//        return CGSize.zero
//    }
    
    // 2초마다 실행되는 타이머
    var timer :Timer?
    func bannerTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
                self.bannerMove()
            }
        }
        // 배너 움직이는 매서드
        func bannerMove() {
            print("nowPage: \(nowPage)")
            // 현재페이지가 마지막 페이지일 경우
            if nowPage == dataArray.count-1 {
            // 맨 처음 페이지로 돌아감
                bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
                nowPage = 0
                return
            }
            // 다음 페이지로 전환
            nowPage += 1
            bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        }
}



