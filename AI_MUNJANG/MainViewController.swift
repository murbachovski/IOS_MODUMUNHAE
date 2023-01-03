//
//  MainViewController.swift
//  AI_MUNJANG
//
//  Created by DONG CHEOL KIM on 2022/07/06.
//
import UIKit
import CoreMedia

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var mainCollectionView: UICollectionView!
    
    
    @IBOutlet var collectionViewTopHeight: NSLayoutConstraint!
    @IBOutlet var bannerBottomHeight: NSLayoutConstraint!
    //
    var mainTitleList = ["문해력 테스트", "기초문해 미션", "실질문해 미션", "문해학습 동영상"]
    //문해력테스트에서 사용중
    var downloadTask :URLSessionDownloadTask?

    var dataArray :Array<UIImage> = []
    
    var titles :Array<String> = []
    var nowPage: Int = 0
    

    @IBOutlet var bannerCollectionView: UICollectionView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "문장학습"
        //RELEASE 모드에서 테스트 버튼이 보이지 않도록
#if DEBUG
#else
        self.navigationItem.rightBarButtonItem =  nil;

#endif
        let layout = UICollectionViewFlowLayout()
        
        mainCollectionView.collectionViewLayout = layout
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
//        bannerCollectionView.delegate = self
//        bannerCollectionView.dataSource = self
        
        self.navigationItem.backButtonTitle = " "
        setupUI()
  

        self.setBackButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.view.frame.size.height < 1920 {
//            bannerBottomHeight.constant = 0
//            collectionViewTopHeight.constant = 0
        }
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        clickedAnalyzeButton(tappedImage)
    }
   
    
    
    func setupUI(){
        nowPage = 0
        dataArray = [UIImage(named: "illust1.png")!, UIImage(named: "illust2.png")!, UIImage(named: "illust3.png")!]
        titles = ["문해력의 출발은 \n문장력입니다!","문장공부 \n해야 합니다!", "꾸준하게 키워가는 \n나의 문해력"]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainCollectionView.reloadData()
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#F9F9F9")
        print("사용자가 구독 중인가? : \(Core.shared.isUserSubscription())")
//        bannerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .white
//        timer?.invalidate()
        
    }

    
    @IBAction func clickedUserIcon(_ sender: UIBarButtonItem) {
        guard let myPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController")  as? MyPageViewController else {return}
        navigationController?.pushViewController(myPageViewController, animated: true)
    }
    
    
    @IBAction func clickedAnalyzeButton(_ sender: Any) {
            
            let alert = AlertService().alert(title: "", body: "사용자께서는 아직 구독 전이라 \n10회 사용 제한이 있습니다. \n 자유롭게 사용하려면 \n구독해 주세요.", cancelTitle: "둘러볼게요.", confirTitle: "구독하기"){
                // 사용자가 둘러보기 선택
                
                print("clicked analyze Btn")
                guard let analyzeViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeViewController")  as? AnalyzeViewController else {return}
                self.navigationController?.pushViewController(analyzeViewController, animated: true)
            } fourthButtonCompletion: {
                // 사용자가 구독하기 선택
                
                guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                subscriptionViewController.modalPresentationStyle = .fullScreen
                self.present(subscriptionViewController, animated: true)
                
                print("cliocked subscribe")
            }
            present(alert, animated: true)
        
        
    }
    
    
    @IBAction func clickedTestButton(_ sender: Any) {
        guard let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController")  as? TestViewController else {return}
        navigationController?.pushViewController(testViewController, animated: true)
    }
    
    //MARK: -CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == bannerCollectionView {
                return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }   else {
                if UIDevice.current.userInterfaceIdiom == .pad{
                    return UIEdgeInsets(top: 50, left: 80, bottom: 0, right: 80)
                }
            return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
                return 3
        }   else {
            
            return mainTitleList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
                    cell.bannerImg.image = dataArray[indexPath.row]
            cell.title.text = titles[indexPath.row]
                    return cell
        }   else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MainCollectionViewCell else {
                   return UICollectionViewCell()
               }
            
//            셀의 내용 채우기  pencil scribble.variable pencil.and.outline play.rectangle
            cell.labelInContentView.text = mainTitleList[indexPath.row]
            if indexPath.row == 0 {
                cell.imgViewInContentView.image = UIImage(named: "cell1")
                cell.lockImg.image = UIImage(named: "icTest40Px")
                if !Core.shared.isUserSubscription(){
//                    if indexPath.row == 0 {
//                        cell.labelInContentView.textColor = UIColor.lightGray
//                    }
                }
            }else if indexPath.row == 1 {
                cell.imgViewInContentView.image = UIImage(named: "cell2")
                cell.lockImg.image = UIImage(named: "ic8K40Px")
            }else if indexPath.row == 2 {
                cell.imgViewInContentView.image = UIImage(named: "cell3")
                cell.lockImg.image = UIImage(named: "icLight40Px")
            }else {
                cell.imgViewInContentView.image = UIImage(named: "cell4")
                cell.lockImg.image = UIImage(named: "icVideo40Px")
            }
            
            
            
            //셀에 shadow추가
//            cell.backgroundColor = .white
//            cell.layer.cornerRadius = 10
//            cell.layer.shadowOpacity = 0.8
//            cell.layer.shadowColor = UIColor.lightGray.cgColor
//            cell.layer.shadowOffset = CGSize(width: 1, height: 1)
//            cell.layer.shadowRadius = 2
//            cell.layer.masksToBounds = false
            
        
            return cell
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked : \(indexPath.row)")
        
        if !Core.shared.isUserSubscription(){
            var bodyMessage = "문제 풀이 제한이 있습니다.\n자유롭게 사용하려면 구독해 주세요."
            var cancelMessage = "둘러보기"
            
            if indexPath.row == 0 {
                
                bodyMessage = "자유롭게 사용하려면 구독해 주세요."
                cancelMessage = "돌아가기"
                
            }
            
            if indexPath.row == 3 {
                bodyMessage = "동영상 시청에 제한이 있습니다.\n자유롭게 사용하려면 구독해 주세요."
                cancelMessage = "둘러보기"
                
            }
            
            
            let alert = AlertService().alert(title: "", body: bodyMessage, cancelTitle: cancelMessage, confirTitle: "구독하기") {
                // 사용자가 둘러보기 선택
                if indexPath.row == 0 {
                    
                }else if indexPath.row == 1 {//기초문해
                    guard let munjangEightViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangEightViewController")  as? MunjangEightViewController else {return}
                    munjangEightViewController.currentLevel = "Basic"
                    self.navigationController?.pushViewController(munjangEightViewController, animated: true)
                }else if indexPath.row == 2 {//실질문해
                    guard let munjangEightViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangEightViewController")  as? MunjangEightViewController else {return}
                    munjangEightViewController.currentLevel = "Advanced"
                    self.navigationController?.pushViewController(munjangEightViewController, animated: true)
                }else {
                    self.clickedMunhaeVideo()
                }
                
            } fourthButtonCompletion: {
                // 사용자가 구독하기 선택
                
                guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                subscriptionViewController.modalPresentationStyle = .fullScreen
                self.present(subscriptionViewController, animated: true)
                
                print("cliocked subscribe")
            }
            present(alert, animated: true)
        
        }else{ //사용자가 구독중일 때
            
            if indexPath.row == 0 {
    
                self.clickedmunhaeTest()
                
            }else if indexPath.row == 1 {
                guard let munjangEightViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangEightViewController")  as? MunjangEightViewController else {return}
                self.navigationController?.pushViewController(munjangEightViewController, animated: true)
                
            }else if indexPath.row == 2 {
                guard let munjangEightViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangEightViewController")  as? MunjangEightViewController else {return}
                munjangEightViewController.currentLevel = "Advanced"
                self.navigationController?.pushViewController(munjangEightViewController, animated: true)
            }else {
                self.clickedMunhaeVideo()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 40
        }else {
            return 20
        }
        
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollectionView {
//            return CGSize(width: CGFloat(140).relativeToIphone8Width(), height: CGFloat(140).relativeToIphone8Width())
            let cellWidth = collectionView.frame.size.width - 40 - 20
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return CGSize(width: cellWidth / 2.5 , height: cellWidth / 4.5)
            }else {
                return CGSize(width: cellWidth / 2 , height: cellWidth / 2.8)
            }
        }
        return CGSize(width: collectionView.frame.size.width, height: 140)
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
//MARK: -Helper Method
//    // 2초마다 실행되는 타이머
//    var timer :Timer?
//    func bannerTimer() {
//            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (Timer) in
//                self.bannerMove()
//            }
//        }
        // 배너 움직이는 매서드
//        func bannerMove() {
//            print("nowPage: \(nowPage)")
//            // 현재페이지가 마지막 페이지일 경우
//            if nowPage == dataArray.count-1 {
//            // 맨 처음 페이지로 돌아감
//                bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
//                nowPage = 0
//                return
//            }
//            // 다음 페이지로 전환
//            nowPage += 1
//            bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
//        }
    
   //MARK: -문해력테스트
    func clickedmunhaeTest() {
        downloadTask = URLSession.shared.downloadTask(with: URL(string: "http://118.67.133.8/download_munhaeTest_json")!) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299

            guard let fileURL = urlOrNil else { return }
            do {
                print("fileURL: \(fileURL)")
                guard let res = responseOrNil else {return}
                print("responseOrNil: \(res.url!)")
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                print("documentsURL: \(documentsURL)")
                print("lastPathComponent: \(fileURL.lastPathComponent)")
                let savedURL = documentsURL.appendingPathComponent("munhaeTestContents.json")
                if FileManager.default.fileExists(atPath: savedURL.path) {
                    try! FileManager.default.removeItem(at: savedURL)
                }
                
                print("savedURL: \(savedURL)")
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                self.fetchJson(filename: "munhaeTestContents.json") {
                    print("fetchJson완료")
                    DispatchQueue.main.async {
                        self.changeMunhaeTestPage()
                    }
                    
                }
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask?.resume()
    }
    
    func fetchJson(filename: String, completion: () -> Void) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: filename, relativeTo: directoryURL)
        do {
                  let data = try Data(contentsOf:fileURL, options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? [Dictionary<String, Any>]{
                       print(jsonResult)
                      let contents =  MunhaeTestContentData.shared.munhaeTestTotal
                      print(contents)
                      completion()
                  }
              } catch {
                   // handle error
              }
    }
    
     func changeMunhaeTestPage() {
        guard let munhaeTestViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeTestViewController")  as? MunhaeTestViewController else {return}
        navigationController?.pushViewController(munhaeTestViewController, animated: true)
    }
    
    //MARK: -문장 8경 미션
    
    //MARK: -실질문해 미션
    
    //MARK: -문해학습 동영상
    func clickedMunhaeVideo() {
        guard let munhaeVideoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeVideoListViewController")  as? MunhaeVideoListViewController else {return}
        self.navigationController?.pushViewController(munhaeVideoListViewController, animated: true)
    }
    

}



