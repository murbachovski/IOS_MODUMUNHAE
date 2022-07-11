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
    
    let titles = ["Apple","Banana", "Orange"]
    
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
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
     
    }
    
    
    private func configureFrame(){
        
        //set up scroll
        scrollView.frame =  holderView.bounds
        holderView.addSubview(scrollView)
        
        for x in 0 ..< 3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height - 110))
            scrollView.addSubview(pageView)
            
            //Title, image, button
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 20, height: 60))
            let imageView = UIImageView(frame: CGRect(x: 10, y:70, width: pageView.frame.size.width - 20, height: pageView.frame.size.height - 70 - 110))
            
            //label 지정
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 32)
            pageView.addSubview(label)
            label.text = titles[x]
            
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
        }
        
        if currentPageNumber == 3 {
            Core.shared.setIsNotUser()
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPageNumber = Int(floor(scrollView.contentOffset.x / holderView.frame.size.width))
        
        pageControl.currentPage = currentPageNumber //pageControl 업데이트
        print("pageCurrentNum: \(pageControl.currentPage)")
        
        if currentPageNumber == 2 { //버튼의 타이틀 업데이트
            button.setTitle("시작하기", for: .normal)
        }else{
            button.setTitle("계속보기", for: .normal)
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
