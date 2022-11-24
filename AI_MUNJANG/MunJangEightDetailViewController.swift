//
//  MunJangEightDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/04.
//

import UIKit

class MunJangEightDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EightDetailDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var subcontainer: UIView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var currentSectionCotents : QuizContents = []
    var currentMissionContents : [QuizContents] = []
    
    
    var naviTitle:String = ""
    var mainTitleText:String = ""
    var subTitleText:String = ""
    
    var toLearningMission = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        if UIDevice.current.userInterfaceIdiom == .pad {
            layout.estimatedItemSize = CGSize(width: 200, height: 160)
            
        }else{
            layout.estimatedItemSize = CGSize(width: CGFloat(100).relativeToIphone8Width() , height: CGFloat(80).relativeToIphone8Width())
            
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        
        setupUI()
        
        navigationItem.title = naviTitle
        
        mainTitle.text = mainTitleText
        subTitle.text = subTitleText
        
        print(currentSectionCotents.count)
        
        //다른 개발자 소스 카피함.
        let grouped: [[QuizContent]] = currentSectionCotents.reduce(into: []) {
            $0.last?.last?.mission == $1.mission ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        }

        currentMissionContents = grouped.sorted { (front, behind) -> Bool in
            
            return front.first!.mission < behind.first!.mission

        }
        
        displayHomeBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
        
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.rightBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: 265, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    
    func eightDetailDelegate() {

        toLearningMission = toLearningMission + 1
        print("eightdetaildelegate: \(toLearningMission)")
        collectionView.reloadData()
    }
    
    func setupUI(){
        subcontainer.layer.cornerRadius = 10
        
        mainContainer.clipsToBounds = true
        mainContainer.layer.cornerRadius = 20
        mainContainer.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        mainContainer.layer.shadowOpacity = 0.6
        mainContainer.layer.shadowColor = UIColor.lightGray.cgColor
        mainContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainContainer.layer.shadowRadius = 1
        mainContainer.layer.masksToBounds = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMissionContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MunjangEightDetailCollectionViewCell else {
               return UICollectionViewCell()
           }

        cell.numberTitle.text = "\(indexPath.row + 1)번"
            
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
            
            //둘러보기 사용자를 위한 것, //일반 구독자 구분 없이 1경에 한 해서만 UserDefaults에서 관리
        if naviTitle == "1" {
            let dataDic = UserDefaults.standard.object(forKey: "tourUserData") as! [String: Any]
            print("불러 온 dataDic:\(dataDic)")
            let completedMission = dataDic["1"] as! [Int]
            
            if completedMission.contains(indexPath.row + 1) {
                
                cell.isDoneImage.isHidden = false
            }else {
                cell.isDoneImage.isHidden = true
            }
        }else {
            if indexPath.row < self.toLearningMission { //학습이 완료된 인덱스
                cell.isUserInteractionEnabled = true
                cell.isDoneImage.isHidden = false
                print("😀학습완료:\(indexPath.row): \(cell)")
            }else if indexPath.row == self.toLearningMission {
                cell.isUserInteractionEnabled = true
                print("😀학습할:\(indexPath.row): \(cell)")
                cell.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
                cell.isDoneImage.image = UIImage(named: "icPlay32Px")
                cell.numberTitle.textColor = .white
                cell.border.backgroundColor = .white
                
                let l = CAGradientLayer()
                l.frame = cell.bounds
                l.colors = [hexStringToUIColor(hex: "#04BF55").cgColor, hexStringToUIColor(hex: "#11998E").cgColor]
                l.startPoint = CGPoint(x: 0, y: 0.5)
                l.endPoint = CGPoint(x: 1, y: 0.5)
                l.cornerRadius = 8
                
                cell.layer.insertSublayer(l, at: 0)
                
                cell.layer.cornerRadius = 10
                cell.layer.shadowOpacity = 0.8
                cell.layer.shadowColor = UIColor.lightGray.cgColor
                cell.layer.shadowOffset = CGSize(width: 1, height: 1)
                cell.layer.shadowRadius = 2
                cell.layer.masksToBounds = false
            }else {
                print("😀학습예정:\(indexPath.row): \(cell)")
                cell.isDoneImage.isHidden = true
                cell.backgroundColor = hexStringToUIColor(hex: "#f5f5f5")
                cell.isUserInteractionEnabled = false
                
            }
            
        }
//        cell.isDoneImage.isHidden = true
        //셀에 shadow추가

                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked : \(indexPath.row)")
        
        guard let munjangQuizViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangQuizViewController")  as? MunjangQuizViewController else {return}
        munjangQuizViewController.modalPresentationStyle = .fullScreen
        print("선택된 Mission \(indexPath.row + 1)")
        print("선택된 Mission 내용 : \(currentMissionContents[indexPath.row])")
        munjangQuizViewController.currentQuizPool = currentMissionContents[indexPath.row]
        munjangQuizViewController.descTitleLabel.text = currentMissionContents[indexPath.row][0].missionSubject
        munjangQuizViewController.delegate = self
        munjangQuizViewController.currentSection = naviTitle
        present(munjangQuizViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 30: 14 // Keep whatever fits for you
     }

}
