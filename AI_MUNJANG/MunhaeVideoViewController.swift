//
//  MunhaeVideoViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit
import AVKit
class MunhaeVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var videoTableView: UITableView!
    var jsonVideoContents: [Dictionary<String, Any>] = [[:]]
    var isMember = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMember = Core.shared.isUserSubscription()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        
        guard let path = Bundle.main.path(forResource: "videoContents", ofType: "json") else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileURL)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? [Dictionary<String, Any>]{
                       print(jsonResult)
                      jsonVideoContents = jsonResult
                  }
              } catch {
                   // handle error
              }
        
        // Do any additional setup after loading the view.
        displayHomeBtn()
        
        videoTableView.separatorStyle = .none
        navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title  = ""
    }
    
    
    //MARK: - TabelView DataSource, Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonVideoContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
        let item = jsonVideoContents[indexPath.row]
        cell.indexLabel.text = item["No"] as? String
        cell.titleLabel.text = item["Title"] as! String?
        
        cell.videoImageView.clipsToBounds = true
        cell.videoImageView.layer.cornerRadius = 8
        
        

        cell.indexLabel.font = UIFont(name: "NanumSquareR", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 15)
        cell.indexLabel.textColor = hexStringToUIColor(hex: "#333333")
        cell.titleLabel.font = UIFont(name: "NanumSquareB", size: UIDevice.current.userInterfaceIdiom == .pad ? 24: 16)

        if isMember == false {
            if indexPath.row > 2 {
                cell.videoImageView!.image = UIImage(named: "thumnail_lock")
            }else {
                
                let unlockImage = UIImage(named: "thumnail_unlock")
                cell.videoImageView!.image = unlockImage
                
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = jsonVideoContents[indexPath.row]
        
        if isMember == false {
            if indexPath.row > 2 {
                let alert = AlertService().alert(title: "", body: "동영상을 시청하기 위해서는 \n구독하셔야합니다", cancelTitle: "확인", confirTitle: "구독하러가기", thirdButtonCompletion: {
                    
                }, fourthButtonCompletion: {
                    guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                    subscriptionViewController.modalPresentationStyle = .fullScreen
                    self.present(subscriptionViewController, animated: true)
                    
                    print("cliocked subscribe")
                })
                present(alert, animated: true)
            }else {
                playTheVideo(urlString: item["UrlName"] as! String)
            }
        }else {
            playTheVideo(urlString: item["UrlName"] as! String)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 110: 90
    }
    
    
    func playTheVideo(urlString: String) {
        
        let videoURL = URL(string: urlString)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
      
        present(playerViewController, animated: true) {
          player.play()
        }
    }
   
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.leftBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: -25, bottom: 0, right: 0)
    }
    @objc func homeBtnTapped(){
        changeMainNC()
    }
}
