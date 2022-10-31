//
//  TermsDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit
import WebKit
import PDFKit
class TermsDetailViewController: UIViewController {

    @IBOutlet weak var titleOfTerms: UILabel!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var containerView: UIView!
    
    var titleOfLabel:String = ""
    var fileName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfTerms.text = titleOfLabel
        
        let pdfView = PDFView(frame: self.view.bounds)
        
//        let pdfView = PDFView(frame: self.containerView.bounds)
        containerView = pdfView
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)

        pdfView.autoScales = true

        let fileURL = Bundle.main.url(forResource: fileName, withExtension: "pdf")
        pdfView.document = PDFDocument(url:fileURL!)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        //        let pdfView = PDFView(frame: self.view.bounds)
//
//                let pdfView = PDFView(frame: self.containerView.bounds)
//                containerView = pdfView
//                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        //        self.view.addSubview(pdfView)
//
//                pdfView.autoScales = true
//
//                let fileURL = Bundle.main.url(forResource: "useTerms", withExtension: "pdf")
//                pdfView.document = PDFDocument(url:fileURL!)
//    }

    

    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

//약관 상세보기는 추가적인 작업 필요
