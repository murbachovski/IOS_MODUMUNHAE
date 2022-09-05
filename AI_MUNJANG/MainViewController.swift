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
    var downloadTask :URLSessionDownloadTask?

    
    var sectionTotal :[QuizContents] = []
//    var missionList: [QuizContent] = []
    //    var missionTotal :[QuizContents] = []
    var dataArray :Array<UIImage> = []
    
    var titles :Array<String> = []
    var nowPage: Int = 0
    var serverVersion = 0
    
    @IBOutlet weak var analyzeSenButton: UIButton!
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewEight: UICollectionView!
    @IBOutlet weak var analyzeContainer: UIView!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet var munhaeTestButton: UIButton!
    
    
    let munjangElements:[String] = ["문장","주어", "서술어","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    let subElements: [String] = ["문장","대상", "정보","조사", "어미","관형어","부사어","문장부사어","마침부호"]
    
    
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
        
        analyzeContainer.layer.borderWidth = 1
        analyzeContainer.layer.borderColor = UIColor.darkGray.cgColor
        analyzeContainer.layer.cornerRadius = 8
        
        analyzeSenButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 15)
        analyzeSenButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        
        munhaeTestButton.layer.borderWidth = 1
        munhaeTestButton.layer.borderColor = UIColor.darkGray.cgColor
        munhaeTestButton.layer.cornerRadius = 8
        
        munhaeTestButton.titleLabel?.font = UIFont(name: "NanumSquareEB", size: 15)
        munhaeTestButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        searchImage.isUserInteractionEnabled = true
        searchImage.addGestureRecognizer(tapGestureRecognizer)

        
        self.collectionViewEight.register(UINib(nibName: "MunjangEightCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")


        
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
    @IBAction func clickedmunhaeTest(_ sender: Any) {
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
        
        
//        guard let munhaeTestViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeTestViewController")  as? MunhaeTestViewController else {return}
//        navigationController?.pushViewController(munhaeTestViewController, animated: true)
    }
    
     func changeMunhaeTestPage() {
        guard let munhaeTestViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeTestViewController")  as? MunhaeTestViewController else {return}
        navigationController?.pushViewController(munhaeTestViewController, animated: true)
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
                return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
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
            cell.digitTitle.text = "\(indexPath.row)경"
            
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
              munJangEightDetailViewController.naviTitle = "\(indexPath.row )경"
              munJangEightDetailViewController.mainTitleText = munjangElements[indexPath.row]
              
              munJangEightDetailViewController.currentSectionCotents = QuizContentData.shared.sectionTotal[indexPath.row]
            print("😡😡😡 \(indexPath.row)경 선택")
            
            self.navigationController?.pushViewController(munJangEightDetailViewController, animated: true)
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
}



