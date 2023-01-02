//
//  TermsDetailViewController.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/18.
//

import UIKit

import PDFKit
class TermsDetailViewController: UIViewController {

    @IBOutlet weak var titleOfTerms: UILabel!
    
    @IBOutlet var containerView: UIView!
    
    var titleOfLabel:String = ""
    var fileName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleOfTerms.text = titleOfLabel
        titleOfTerms.font = UIFont(name: "NanumSquareB", size: 17)
        

        
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        pdfView.maxScaleFactor = 4.0;
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit;
        pdfView.autoScales = true;
        
        let fileURL = Bundle.main.url(forResource: fileName, withExtension: "pdf")
        pdfView.document = PDFDocument(url:fileURL!)
        
    }
    


    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}

//약관 상세보기는 추가적인 작업 필요
