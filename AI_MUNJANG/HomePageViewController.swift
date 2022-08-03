//
//  HomePageViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/01.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class HomePageViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                            type: .lineSpinFadeLoader,
                                            color: hexStringToUIColor(hex: "#f7f9fb"),
                                            padding: 0)
    
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
