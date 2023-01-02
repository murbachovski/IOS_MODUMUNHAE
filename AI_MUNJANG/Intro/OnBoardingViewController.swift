//
//  OnBoardingViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/11.
//

import UIKit

class OnBoardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var holderView:UIView!
    @IBOutlet var button:UIButton!
    @IBOutlet var pageControl:UIPageControl!
    
    var nextButtonClicked: ()->Void = {}
    
    let titles = ["문해력의 출발은 문장력입니다!","문장공부 해야 합니다!", "모두의 문해력으로 당신의 \n문해력을 UP하세요!"]
    let subTitles = ["",
                     "10명 중 1명만이 스스로 공부할 수 있는 \n문해력을 갖고 있다고 합니다. \n-EBS 당신의 문해력 중-",
                     ""]
    
    let scrollView = UIScrollView()
    var currentPageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configureView()
    }

  
 
    override func viewDidLayoutSubviews() { //개별 요소들의 Frame 구성시 출발점
        super.viewDidLayoutSubviews()
        configureFrame()
    }
    
    
    private func configureView(){

        //pageControl 지정
        pageControl.numberOfPages = titles.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
    
        //button 지정
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = hexStringToUIColor(hex: Constants.primaryColor)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
      

    }
    
    
    private func configureFrame(){
        
        //set up scroll
        scrollView.frame =  holderView.bounds
        holderView.addSubview(scrollView)
        
        for x in 0 ..< 3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height - 110))
            scrollView.addSubview(pageView)
            
            //Title, image, button
            let titleLabel = UILabel(frame: CGRect(x: 10, y: holderView.frame.size.height * 0.15, width: pageView.frame.size.width, height: 60))
            
            let subTitleLabel = UILabel(frame: CGRect(x: 10, y: holderView.frame.size.height * 0.20, width: pageView.frame.size.width - 20, height: 120))
            
            let imageView = UIImageView(frame: CGRect(x: 10, y:0, width: pageView.frame.size.width, height: pageView.frame.size.height * 5/8))
            
            //label 지정
            

            titleLabel.font = UIFont(name: "NanumSquareEB", size: 23)
            pageView.addSubview(titleLabel)
            titleLabel.text = titles[x]
            titleLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: titleLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            titleLabel.attributedText = attrString
            
            titleLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
            titleLabel.textAlignment = .center
            
            subTitleLabel.font = UIFont(name: "NanumSquareR", size: 15)
            subTitleLabel.numberOfLines = 0
            pageView.addSubview(subTitleLabel)
            
            subTitleLabel.text = subTitles[x]
            subTitleLabel.textColor = hexStringToUIColor(hex: "#999999")
            let attStringSub = NSMutableAttributedString(string: subTitleLabel.text!)
            let paragraphStyleSub = NSMutableParagraphStyle()
            paragraphStyleSub.lineSpacing = 6
            attStringSub.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyleSub, range: NSMakeRange(0, attStringSub.length))
            subTitleLabel.attributedText = attStringSub
            
            subTitleLabel.textAlignment = .center
            //imageView 지정
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "illust\(x+1)")
            pageView.addSubview(imageView)
            imageView.center = holderView.center
        }
        
        //scrollView 지정
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true

    }
    
    
    @objc func didTapButton(_ button:UIButton){

        //scrolllView 업데이트
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(currentPageNumber + 1), y: 0), animated: true)
        currentPageNumber += 1
        pageControl.currentPage = currentPageNumber //pageControl 업데이트
        if currentPageNumber == 2 {
            button.setTitle("시작하기", for: .normal) //버튼의 타이틀 업데이트
        
        }
        
        if currentPageNumber == 3 {

            enterMainPage()
       
        }
    }
    
    func enterMainPage(){
        Core.shared.setIsNotUser()
        
        changeMainNC()
        
//        guard let nc = storyboard?.instantiateViewController(identifier: "mainNavigationController") as? UINavigationController else { return }
//        nc.modalPresentationStyle = .fullScreen
//        nc.modalTransitionStyle = .crossDissolve
//        present(nc, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageNumber = Int(floor(scrollView.contentOffset.x / holderView.frame.size.width))
        
        pageControl.currentPage = currentPageNumber //pageControl 업데이트
        
        
        if currentPageNumber == 2 { //버튼의 타이틀 업데이트
            button.setTitle("시작하기", for: .normal)
            
        }else{
            button.setTitle("다음", for: .normal)
            
        }
    }


}


