//
//  MunJangEightDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/04.
//

import UIKit

class MunJangEightDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
  
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        layout.estimatedItemSize = CGSize(width: CGFloat(100).relativeToIphone8Width() , height: CGFloat(80).relativeToIphone8Width())
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
        print("sorted grouped: \(currentMissionContents)")
        
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
        
        guard let munjangQuizViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangQuizViewController")  as? MunjangQuizViewController else {return}
        munjangQuizViewController.modalPresentationStyle = .fullScreen
        munjangQuizViewController.currentQuizPool = currentMissionContents[indexPath.row]
        present(munjangQuizViewController, animated: true)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 14 // Keep whatever fits for you
     }

}
