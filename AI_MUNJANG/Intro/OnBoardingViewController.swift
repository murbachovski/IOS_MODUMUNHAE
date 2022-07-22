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
    @IBOutlet weak var tourButton: UIButton!
    var nextButtonClicked: ()->Void = {}
    
    let titles = ["문장력을 키웁시다!","문장퀴즈", "문장분석"]
    let subTitles = ["10문장 중 8문장은 어려운 복무.\n꾸준한 문장 학습이 필요한 이유입니다.",
                     "문장의 8가지 성분,\n다양한 퀴즈로 탄탄하게 익혀보세요.",
                     "길고 어려운 복문도 단문으로 싹둑!잘라\n 8가지 성분으로 분석해드릴게요."]
    
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
        
        tourButton.isHidden = true
        getFontName()
    }
    
    
    private func configureFrame(){
        
        //set up scroll
        scrollView.frame =  holderView.bounds
        holderView.addSubview(scrollView)
        
        for x in 0 ..< 3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height - 110))
            scrollView.addSubview(pageView)
            
            //Title, image, button
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 60))
            
            let subTitleLabel = UILabel(frame: CGRect(x: 10, y: 70, width: pageView.frame.size.width - 20, height: 60))
            
            let imageView = UIImageView(frame: CGRect(x: 10, y:150, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 70 - 110))
            
            //label 지정
            titleLabel.textAlignment = .left

            titleLabel.font = UIFont(name: "NanumSquareB", size: 20)
            pageView.addSubview(titleLabel)
            titleLabel.text = titles[x]
            titleLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
            
            subTitleLabel.textAlignment = .left
            subTitleLabel.font = UIFont(name: "NanumSquareR", size: 17)
            subTitleLabel.numberOfLines = 0
            pageView.addSubview(subTitleLabel)
            
            subTitleLabel.text = subTitles[x]
            
            //imageView 지정
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "welcome_\(x+1)")
            pageView.addSubview(imageView)
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
            tourButton.isHidden = true
        }
        
        if currentPageNumber == 3 {

            enterLoginPage()
       
        }
    }
    
    func enterLoginPage(){
        guard let nc = storyboard?.instantiateViewController(identifier: "LoginNavigationController") as? UINavigationController else { return }

        nc.modalPresentationStyle = .fullScreen
        nc.modalTransitionStyle = .crossDissolve
        present(nc, animated: true)
    }
    
    
  
    
    
    @IBAction func clickedTourButton(_ sender: UIButton) {
        //회원가입 페이지 대신 Main화면으로 전환
        Core.shared.setIsNotUser()
        dismiss(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageNumber = Int(floor(scrollView.contentOffset.x / holderView.frame.size.width))
        
        pageControl.currentPage = currentPageNumber //pageControl 업데이트
        
        
        if currentPageNumber == 2 { //버튼의 타이틀 업데이트
            button.setTitle("시작하기", for: .normal)
            tourButton.isHidden = true
        }else{
            button.setTitle("다음", for: .normal)
            tourButton.isHidden = true
        }
    }


}


class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
