//
//  HomeViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/10/13.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var labelContents: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var searchImage: UIImageView!
    
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        searchImage.isUserInteractionEnabled = true
        searchImage.addGestureRecognizer(tapGestureRecognizer)
    }
        
     @objc func clickedUserIcon() {
         guard let myPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyPageViewController")  as? MyPageViewController else {return}
         navigationController?.pushViewController(myPageViewController, animated: true)
     }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        clickedAnalyzeButton(tappedImage)
        clickedAnalyze(tappedImage)
    }
    
    @IBAction func clickedContents(_ sender: UIButton) {
        guard let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")  as? MainViewController else {return}
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    @IBAction func clickedAnalyze(_ sender: Any) {
        guard let analyzeViewController = self.storyboard?.instantiateViewController(withIdentifier: "AnalyzeViewController")  as? AnalyzeViewController else {return}
        navigationController?.pushViewController(analyzeViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
