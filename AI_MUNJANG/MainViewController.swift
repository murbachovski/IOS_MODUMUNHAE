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
    

    @IBOutlet weak var topTitle: UILabel!
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
        collectionViewEight.backgroundColor = .clear
        
        self.navigationItem.backButtonTitle = " "
        setupUI()
        
      
        
//        guard let quizData = readLocalFile(forName: "quizContents") else { print("quizData is null"); return}
//        guard let quizContents = try? JSONDecoder().decode(QuizContents.self, from: quizData) else { print("quizContens is null");  return }
//
//        for  content in quizContents {
//
//            if content.section == "1경" {
//                sectionOne.append(content)
//            }
//            if content.section == "2경" {
//                sectionTwo.append(content)
//            }
//            if content.section == "3경" {
//                sectionThree.append(content)
//            }
//            if content.section == "4경" {
//                sectionFour.append(content)
//            }
//            if content.section == "5경" {
//                sectionFive.append(content)
//            }
//            if content.section == "6경" {
//                sectionSix.append(content)
//            }
//            if content.section == "7경" {
//                sectionSeven.append(content)
//            }
//            if content.section == "8경" {
//                sectionEight.append(content)
//            }
//
//            sectionTotal = [sectionOne, sectionTwo, sectionThree, sectionFour, sectionFive, sectionSix, sectionSeven, sectionEight]
//
//        }
//
//        print( "sectionOne.count : \(sectionOne.count)")
//        print("sectionTwo.count: \(sectionTwo.count)")
//        print("sectionThree.count: \(sectionThree.count)")
//        print("sectionFour.count: \(sectionFour.count)")
//
//        print("sectionFive.count: \(sectionFive.count)")
//        print("sectionSix.count: \(sectionSix.count)")
//        print("sectionSeven.count: \(sectionSeven.count)")
//        print("sectionEight.count: \(sectionEight.count)")

        
    }
    
//    private func readLocalFile(forName name: String) -> Data? {
//        do {
//            if let bundlePath = Bundle.main.path(forResource: name,
//                                                 ofType: "json"),
//                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//                return jsonData
//            }
//        } catch {
//            print(error)
//        }
//
//        return nil
//    }
    
    func setupUI(){
        topTitle.font = UIFont(name: "NanumSquareEB", size: 24)
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#F9F9F9")
        print("사용자가 구독 중인가? : \(Core.shared.isUserSubscription())")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .white
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
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return munjangElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}

