//
//  HomePageViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/01.
//

import UIKit
import WebKit
//import NVActivityIndicatorView

class HomePageViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
//    let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
//                                            type: .lineSpinFadeLoader,
//                                            color: hexStringToUIColor(hex: "#f7f9fb"),
//                                            padding: 0)
    
    lazy var indicator: UIActivityIndicatorView = {
            // 해당 클로저에서 나중에 indicator 를 반환해주기 위해 상수형태로 선언
            let activityIndicator = UIActivityIndicatorView()
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            
            activityIndicator.center = self.view.center
            
            // 기타 옵션
            activityIndicator.color = hexStringToUIColor(hex: Constants.primaryColor)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .medium
            
            // stopAnimating을 걸어주는 이유는, 최초에 해당 indicator가 선언되었을 때, 멈춘 상태로 있기 위해서
            activityIndicator.stopAnimating()
            
            return activityIndicator
            
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.navigationItem.title = "서감문해"
        
        loadWebPage("https://blog.naver.com/seogammoonhae")
        self.view.addSubview(indicator)
        indicator.center = view.center
    }
    
    private func loadWebPage(_ url: String) {
           guard let myUrl = URL(string: url) else {
               return
           }
           let request = URLRequest(url: myUrl)
           webView.load(request)
       }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.startAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        
    }
}
