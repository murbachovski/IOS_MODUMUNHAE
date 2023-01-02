//
//  MunhaeVideoViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit
import AVKit
class BaksaMunhaeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var munhaeVideoStartBackButton: UIButton!
    @IBOutlet var descriptionTitle: UILabel!
    
    @IBOutlet var descriptionSubTitle: UILabel!
    
    @IBOutlet var descriptionStartButton: UIButton!
    @IBOutlet var munhaeVideoDescription: UIView!
    
    @IBOutlet var videoTableView: UITableView!
    var jsonVideoMunjangContents: [Dictionary<String, Any>] = [[:]]
    var isMember = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            descriptionTitle.font = UIFont(name: "NanumSquareEB", size: 22)
            descriptionSubTitle.font = UIFont(name: "NanumSquareB", size: 20)
            descriptionStartButton.layer.cornerRadius = 10
        }else {
            descriptionTitle.font = UIFont(name: "NanumSquareEB", size: 18)
            descriptionSubTitle.font = UIFont(name: "NanumSquareB", size: 14)
            descriptionStartButton.layer.cornerRadius = descriptionStartButton.frame.size.width / 7
        }
        
        isMember = Core.shared.isUserSubscription()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        
        guard let path = Bundle.main.path(forResource: "videoBaksaMunhaeContents", ofType: "json") else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: fileURL)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? [Dictionary<String, Any>]{
                       print(jsonResult)
                      jsonVideoMunjangContents = jsonResult
                  }
              } catch {
                   // handle error
              }
        
        // Do any additional setup after loading the view.
        
        
        videoTableView.separatorStyle = .none
//        navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title  = ""
//        displayHomeBtn()
    }
    
//    fileprivate func displayHomeBtn() {
//        //백버튼의 타이틀을 지우기위해
//        navigationItem.backButtonTitle = ""
////        self.navigationController?.navigationBar.tintColor = UIColor.white
//        //백버튼외에 추가적으로 홈버튼을 채우기 위해
//        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
//        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
//        navigationItem.leftBarButtonItem = homeButtonItem
////        navigationItem.titleView?.tintColor = .white
//        navigationItem.leftItemsSupplementBackButton = true
//        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: -25, bottom: 0, right: 0)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        munhaeVideoDescription.frame = view.frame
        view.addSubview(munhaeVideoDescription)
    }
    
    //MARK: - TabelView DataSource, Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonVideoMunjangContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
        let item = jsonVideoMunjangContents[indexPath.row]
        cell.indexLabel.text = item["No"] as? String
        cell.titleLabel.text = item["Title"] as! String?
        
        cell.videoImageView.clipsToBounds = true
        cell.videoImageView.layer.cornerRadius = 8
        
        

        cell.indexLabel.font = UIFont(name: "NanumSquareR", size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 13)
        cell.indexLabel.textColor = hexStringToUIColor(hex: "#333333")
        cell.titleLabel.font = UIFont(name: "NanumSquareB", size: UIDevice.current.userInterfaceIdiom == .pad ? 24: 14)

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
        let item = jsonVideoMunjangContents[indexPath.row]
        
        if isMember == false {
            if indexPath.row > 2 {
                let alert = AlertService().alert(title: "", body: "동영상 시청에 제한이 있습니다.\n 자유롭게 사용하려면 구독해 주세요.", cancelTitle: "확인", confirTitle: "구독하러가기", thirdButtonCompletion: {
                    
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

//    @objc func homeBtnTapped(){
//        changeMainNC()
//    }
    
    @IBAction func clickedStart(_ sender: Any) {
        print("clicked Start TEST")
        munhaeVideoDescription.removeFromSuperview()
        //문제 읽어 주는 기능
//        startTTS()
    }
    
    @IBAction func munhaeVideoStartBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clickedBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
