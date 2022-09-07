//
//  ExampleAnotherMainViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit

class ExampleAnotherMainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var cellInLabel: UILabel!
    
    @IBOutlet var exampleCollectionView: UICollectionView!
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var exampleImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleCollectionView.delegate = self
        exampleCollectionView.dataSource = self
    }
    
    // MARK: - Navigation
    
    
    @IBAction func clickedBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SampleCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
        
        if indexPath.row == 0 {
            cell.cellInLabel.text = "문장분석"
            cell.sampleImage.image = UIImage(systemName: "wallet.pass")
        }else if indexPath.row == 1 {
            cell.cellInLabel.text = "기초 문해퀴즈"
            cell.sampleImage.image = UIImage(systemName: "phone.fill.connection")
        }else if indexPath.row == 2 {
            cell.cellInLabel.text = "실전 문해퀴즈"
            cell.sampleImage.image = UIImage(systemName: "wallet.pass")
        }else if indexPath.row == 3 {
            cell.cellInLabel.text = "문해영상 강의"
            cell.sampleImage.image = UIImage(systemName: "phone.fill.connection")
        }else if indexPath.row == 4 {
            cell.cellInLabel.text = "문해력 검사"
            cell.sampleImage.image = UIImage(systemName: "wallet.pass")
        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
}
