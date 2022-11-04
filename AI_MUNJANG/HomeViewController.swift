//
//  HomeViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/10/13.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var middleTitleLabel: UILabel!
    
    @IBOutlet weak var bottomTitleLabel: UILabel!
    
    @IBOutlet weak var bottomTitleContainerView: UIView!
    
    var test = ""
    var testTwo = ""
    
    @IBOutlet weak var homeSenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backButtonTitle = " "
        
        var image = UIImage(named: "icUser32Px")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(clickedUserIcon))
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.masksToBounds = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedAnalyze))
        bottomTitleContainerView.isUserInteractionEnabled = true
        bottomTitleContainerView.addGestureRecognizer(tapRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickedContents))
        homeSenImageView.isUserInteractionEnabled = true
        homeSenImageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        //캠페인 활성화 여부 판단
        retrieveCouponeCampaign { usable in
            if usable == true {
                Core.shared.setCouponeCampaign()
            }else{
                Core.shared.setCouponeCampaignNo()
            }
        }
        
        bottomTitleContainerView.layer.cornerRadius = 12
   
        
        let attrString = NSMutableAttributedString(string: topTitleLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        topTitleLabel.attributedText = attrString
        topTitleLabel.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 30: 24)
        topTitleLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        middleTitleLabel.font = UIFont(name: "NanumSquareEB", size: 18)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            bottomTitleLabel.font = UIFont(name: "NanumSquareB", size: 18)
        }
        
    }
        
     @objc func clickedUserIcon() {
         
         
         guard let myPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController")  as? MyPageViewController else {return}
         navigationController?.pushViewController(myPageViewController, animated: true)
     }
    
   
    
    @objc func clickedContents() {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")  as? MainViewController else {return}
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @objc func clickedAnalyze() {
        guard let analyzeViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeViewController")  as? AnalyzeViewController else {return}
        navigationController?.pushViewController(analyzeViewController, animated: true)
    }
    

}
