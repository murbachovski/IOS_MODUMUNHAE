//
//  DownloadViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/08/18.
//

import UIKit
import Zip
import NVActivityIndicatorView

class DownloadViewController: UIViewController, URLSessionDataDelegate {
    @IBOutlet var guideLabel: UILabel!
    @IBOutlet var indicator: NVActivityIndicatorView!
    
    var curVersion = UserDefaults.standard.integer(forKey: "version_number")
    var serverVersion = 0
    
    private lazy var urlSession = URLSession(configuration: .default,
                                             delegate: self,
                                             delegateQueue: nil)
    
    var downloadTask = URLSession.shared.downloadTask(with: URL(string: "http://118.67.133.8/download_json")!) {
        urlOrNil, responseOrNil, errorOrNil in
        // check for and handle errors:
        // * errorOrNil should be nil
        // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299

        guard let fileURL = urlOrNil else { return }
        do {
            print("fileURL: \(fileURL)")
            guard let res = responseOrNil else {return}
            print("responseOrNil: \(res.url!)")
            let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            print("documentsURL: \(documentsURL)")
            print("lastPathComponent: \(fileURL.lastPathComponent)")
            let savedURL = documentsURL.appendingPathComponent("quizContents.json")
            if FileManager.default.fileExists(atPath: savedURL.path) {
                try! FileManager.default.removeItem(at: savedURL)
            }
            
            
            print("savedURL: \(savedURL)")
            try FileManager.default.moveItem(at: fileURL, to: savedURL)
        } catch {
            print ("file error: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.curVersion = UserDefaults.standard.integer(forKey: "version_number")
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task{
            await checkToFowardScreen()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if indicator.isAnimating {
            indicator.stopAnimating()
        }
    }
    
 
    
    func checkToFowardScreen() async  {
        await checkTheVersion(completion: { needs in
            DispatchQueue.main.async {
                if needs == true{
                    print("업데이트 필요")
                    self.updateContens()
                }else{
                    print("업데이트 불필요")
                    
                    self.setupContents()
                    self.changeViewController()
                }
            }
        })
    }
        
    
    func updateContens(){
        guideLabel.isHidden = false
        indicator.startAnimating()
        //contens json을 다운로드 한다.
        self.downloadTask.resume()
        
        //contents img를 다운로드 한다.
        clickedZipDownload()
        
        
        
    }
  
    func checkTheVersion(completion: @escaping (Bool)->Void )  async{
        
        let urlString = "http://118.67.133.8/version_number"
        var request = URLRequest(url: URL(string: urlString)! )
            
        request.httpMethod = "GET"
        
        let task =  URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))

            return
          }

            let str = String(decoding: data, as: UTF8.self)
                   print("serverVersion: \(str)")
            
            var dicData : Dictionary<String, Int> = [String : Int]()
                    do {
                        // 딕셔너리에 데이터 저장 실시
                        dicData = try JSONSerialization.jsonObject(with: Data(str.utf8), options: []) as! [String:Int]
                        print("version_number_res: \(dicData["version_number"]! )")
                        self.serverVersion = dicData["version_number"]!
                        
                        if self.curVersion < self.serverVersion {
                            completion(true)
                        }else{
                            completion(false)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                             
        }
        task.resume()
    }
    
    fileprivate func changeViewController() {

        let boardName = whichStoryBoard()
        if Core.shared.isNewUser(){
            let vc = UIStoryboard(name: boardName, bundle: .main).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
            
        }else{
            let nc = UIStoryboard(name: boardName, bundle: .main).instantiateViewController(withIdentifier: "mainNavigationController") as! UINavigationController
            nc.modalPresentationStyle = .fullScreen
            nc.modalTransitionStyle = .crossDissolve
            self.present(nc, animated: true)
        }
    }
    
    private func startDownload(url: URL) {
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    //        self.downloadTask = downloadTask
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
         if downloadTask == self.downloadTask {
            let calculatedProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            DispatchQueue.main.async {
                print("progress: \(calculatedProgress)")
                
            }
         }
    }


        func urlSession(_ session: URLSession,
                        downloadTask: URLSessionDownloadTask,
                        didFinishDownloadingTo location: URL) {
            // check for and handle errors:
            // * downloadTask.response should be an HTTPURLResponse with statusCode in 200..<299

            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(
                    location.lastPathComponent)
                try FileManager.default.moveItem(at: location, to: savedURL)
            } catch {
                // handle filesystem error
            }
        }
        
        func clickedJsonRead() {
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "quizContents.json", relativeTo: directoryURL)

        do {
                  let data = try Data(contentsOf:fileURL, options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? [Dictionary<String, Any>]{
                       print(jsonResult)
                  }
              } catch {
                   // handle error
              }
    }

    func clickedZipDownload() {
        print("🥶🥶clickedZipDownload is called started🥶🥶")
        var savedURL:URL = URL(string: "http:")!
        
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: "http://118.67.133.8/download_image")!) {
            urlOrNil, responseOrNil, errorOrNil in

            guard let fileURL = urlOrNil else { return }
            do {
                print("fileURL: \(fileURL)")
                guard let res = responseOrNil else {return}
                print("responseOrNil: \(res.url!)")
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                print("documentsURL: \(documentsURL)")
                print("lastPathComponent: \(fileURL.lastPathComponent)")
                savedURL = documentsURL.appendingPathComponent("image.zip")
                if FileManager.default.fileExists(atPath: savedURL.path) {
                    try! FileManager.default.removeItem(at: savedURL)
                }
                
                //서버에서 다운로드 받은 zip파일의 저장 경로
                print("savedURL: \(savedURL)")
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                
              
                
            } catch {
                print ("file error: \(error)")
            }
            
            do {
                //zip파일 경로를 한번 unzip하면 폴더 생성,
                let unzipDirectory = try Zip.quickUnzipFile(savedURL)
                //폴더내에 위치한 zip파일을 개별 이미지 파일로 unzip
    //                let unzipFileDirectory = try Zip.quickUnzipFile(unzipDirectory.appendingPathComponent("image.zip"))
                
                let unzipFileDirectory =  try Zip.quickUnzipFile(unzipDirectory.appendingPathComponent("image.zip")) { progress in
                    
                    DispatchQueue.main.async {
                        //UI화면과 연동 필요.
                        print(progress)
                        if progress == 1.0 {
                            self.indicator.stopAnimating()
                            self.guideLabel.isHidden = true
                            
                            UserDefaults.standard.set(self.serverVersion, forKey: "version_number")
                            self.curVersion = UserDefaults.standard.integer(forKey: "version_number")
                            //Quiz와 관련된 json 콘텐츠 설정
                            self.setupContents()
                            
                            print("🥶🥶clickedZipDownload is called Finished🥶🥶")
                            
                            if Core.shared.isNewUser(){
                                let vc = UIStoryboard(name: whichStoryBoard(), bundle: .main).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
                                vc.modalPresentationStyle = .fullScreen
                                vc.modalTransitionStyle = .crossDissolve
                                self.present(vc, animated: true)
                                
                            }else{
                                //화면 전환
                                changeMainNC()
                            }
                           
                            
                            
                        }
                    }
                    
                    
                }
                
                //다운로드 받은 image.zip을 삭제
                try! FileManager.default.removeItem(at: savedURL)
                //unzipDirectory내에 생성된 image.zip파일 삭제
                try! FileManager.default.removeItem(at: unzipFileDirectory.appendingPathComponent("image.zip"))
                
            }
            catch{
                print ("file error: \(error)")
            }

    }
    downloadTask.resume()

        
       
    }
    
    func setupContents() {
        //image파일 contents 조회, 앱 구동시마다. QuizContentData.shared 호출하여 데이터를 파일에서 읽어들인다.
        _ = QuizContentData.shared.sectionTotal
    }
}


