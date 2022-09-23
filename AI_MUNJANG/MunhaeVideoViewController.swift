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
    }
    
    
    //MARK: - TabelView DataSource, Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonVideoContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = jsonVideoContents[indexPath.row]
        cell.textLabel!.text = "\(item["No"]!)" + "   \(item["Title"]!)"
        if isMember == false {
            if indexPath.row > 3 {
                cell.imageView!.image = UIImage(named: "icLock32Px")
                cell.textLabel?.textColor = .lightGray
            }else {
                
                let image = UIImage(systemName: "lock.open.fill")?.withRenderingMode(.alwaysTemplate)
                cell.imageView!.image = image
                cell.imageView!.tintColor = hexStringToUIColor(hex: Constants.primaryColor)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMember == false {
            if indexPath.row > 3 {
                let alert = AlertService().alert(title: "", body: "동영상을 시청하기 위해서는 구독하셔야합니다", cancelTitle: "확인", confirTitle: "구독하러가기", thirdButtonCompletion: {
                    
                }, fourthButtonCompletion: {
                    guard let subscriptionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController")  as? SubscriptionViewController else {return}
                    subscriptionViewController.modalPresentationStyle = .fullScreen
                    self.present(subscriptionViewController, animated: true)
                    
                    print("cliocked subscribe")
                })
                present(alert, animated: true)
            }else {
                playTheVideo(urlString: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
            }
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
