//
//  MainViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    
//
    

    var missionTotal :[QuizContents] = []
    var missionList: [QuizContent] = []
    var dataArray :Array<UIImage> = []
    
    var titles :Array<String> = []
    var nowPage: Int = 0
    
    var serverVersion = 0
    
    @IBOutlet weak var analyzeSenButton: UIButton!
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewEight: UICollectionView!
    @IBOutlet weak var analyzeContainer: UIView!
    @IBOutlet weak var searchImage: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        collectionViewEight.collectionViewLayout = layout
        layout.estimatedItemSize = CGSize(width: CGFloat(collectionViewEight.frame.size.width - 74).relativeToIphone8Width() , height: CGFloat(70).relativeToIphone8Width())
        collectionViewEight.delegate = self
        collectionViewEight.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        collectionViewEight.backgroundColor = .clear
        
        self.navigationItem.backButtonTitle = " "
        setupUI()
        
        analyzeContainer.layer.borderWidth = 1
        analyzeContainer.layer.borderColor = UIColor.darkGray.cgColor
        analyzeContainer.layer.cornerRadius = 8
        
        analyzeSenButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 15)
        analyzeSenButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        searchImage.isUserInteractionEnabled = true
        searchImage.addGestureRecognizer(tapGestureRecognizer)
        groupedBysortQuiz()
        
        self.collectionViewEight.register(UINib(nibName: "MunjangEightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")


        
    }
    
    func groupedBysortQuiz(){
        missionList = QuizContentData.shared.quizContentsList
        let grouped: [[QuizContent]] = missionList.reduce(into: []) {
            $0.last?.last?.mission == $1.mission ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        }

        missionTotal = grouped.sorted { (front, behind) -> Bool in
            
            return front.first!.mission < behind.first!.mission

        }
        print("sorted grouped: \(missionTotal)")
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        clickedAnalyzeButton(tappedImage)
        // Your action
    }
   
    
    
    func setupUI(){
        nowPage = 0
        dataArray = [UIImage(named: "illust1.png")!, UIImage(named: "illust2.png")!, UIImage(named: "illust3.png")!]
        titles = ["문해력의 출발은 \n문장력입니다!","문장공부 \n해야 합니다!", "꾸준하게 키워가는 \n나의 문해력"]
        
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
    
    @IBAction func clickedAnalyzeButton(_ sender: Any) {
        print("clicked analyze Btn")
        guard let analyzeViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeViewController")  as? AnalyzeViewController else {return}
        self.navigationController?.pushViewController(analyzeViewController, animated: true)
        
    }
    
    @IBAction func clickedTestButton(_ sender: Any) {
        guard let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")  as? TestViewController else {return}
        navigationController?.pushViewController(testViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == bannerCollectionView {
                return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }   else {
                return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
                return 3
        }   else {
            
            return missionTotal.count
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
            cell.digitTitle.text = "Mission \(indexPath.row + 1)"
            
            cell.mainTitle.text = missionTotal[indexPath.row][0].title
            cell.mainTitle.font = UIFont(name: "NanumSquareEB", size: 15)
//            cell.subTitle.text = subElements[indexPath.row]
            
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
        
        guard let munjangQuizViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangQuizViewController")  as? MunjangQuizViewController else {return}
        munjangQuizViewController.modalPresentationStyle = .fullScreen
        munjangQuizViewController.currentQuizPool = missionTotal[indexPath.row]
        present(munjangQuizViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(350).relativeToIphone8Width(), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 14 // Keep whatever fits for you
     }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }

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



