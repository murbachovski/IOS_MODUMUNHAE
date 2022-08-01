//
//  HomePageViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/01.
//

import UIKit
import WebKit

class HomePageViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.navigationItem.title = "서감문해"
        
        loadWebPage("https://blog.naver.com/seogammoonhae")
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
        indicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
