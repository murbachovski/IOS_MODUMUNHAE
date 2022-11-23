//
//  MunhaeVideoListViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/11/22.
//

import UIKit

class MunhaeVideoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet var munhaeVideoListTableView: UITableView!
    var groupedContents: [MunhaeTestContents] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        munhaeVideoListTableView.delegate = self
        munhaeVideoListTableView.dataSource = self
        
        let currentContents = MunhaeTestContentData.shared.munhaeTestTotal
        let grouped: [[MunhaeTestContent]] = currentContents.reduce(into: []) {
            $0.last?.last?.testnumber == $1.testnumber ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        }
        
        print("grouped:\(grouped)")
        groupedContents = grouped
        
//        self.navigationItem.title = ""
        displayHomeBtn()
    }
    
    
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        navigationItem.leftBarButtonItem = homeButtonItem
//        navigationItem.titleView?.tintColor = .white
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -6, left: -25, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MunhaeTestContentData.shared.munhaeTestTotal["TestNumber"]
//        return groupedContents.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel!.text = "1. 문맥 읽기의 짜릿함"
        }else if indexPath.row == 1 {
            cell.textLabel!.text = "2. 문장박사"
        }else if indexPath.row == 2 {
            cell.textLabel!.text = "3. 문맥박사"
        }else if indexPath.row == 3 {
            cell.textLabel!.text = "4. 문해박사"
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = UIFont(name: "NanumSquare", size: 20)
        }else {
            cell.textLabel?.font = UIFont(name: "NanumSquareR", size: 15)
        }
        munhaeVideoListTableView.frame = munhaeVideoListTableView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
//        cell.textLabel?.textColor = .white
        cell.textLabel?.textColor = .black
//        cell.contentView.backgroundColor = hexStringToUIColor(hex: "04BF83")
//        cell.contentView.layer.borderWidth = 2
//        cell.contentView.layer.borderColor = UIColor.red.cgColor
//        cell.contentView.backgroundColor = UIColor.systemGray6
//        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let munhaeVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeVideoViewController")  as? MunhaeVideoViewController else {return}
        munhaeVideoViewController.modalPresentationStyle = .fullScreen
        if indexPath.row == 0 {
            //기존문해박사
        }else if indexPath.row == 1 {
            //문장박사
            guard let munjangVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunjangVideoViewController")  as? MunjangVideoViewController else {return}
            munjangVideoViewController.modalPresentationStyle = .fullScreen
            self.present(munjangVideoViewController, animated: true)
        }else if indexPath.row == 2 {
            //문맥박사
            guard let munmaekViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunmaekViewController")  as? MunmaekViewController else {return}
            munmaekViewController.modalPresentationStyle = .fullScreen
            self.present(munmaekViewController, animated: true)
        }else if indexPath.row == 3 {
            //문해박사
            guard let baksaMunhaeViewController = self.storyboard?.instantiateViewController(withIdentifier: "BaksaMunhaeViewController")  as? BaksaMunhaeViewController else {return}
            baksaMunhaeViewController.modalPresentationStyle = .fullScreen
            self.present(baksaMunhaeViewController, animated: true)
        }
        present(munhaeVideoViewController, animated: true)
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            guard let munhaeVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeVideoViewController")  as? MunhaeVideoViewController else {return}
//            navigationController?.pushViewController(munhaeVideoViewController, animated: true)
//        }else if indexPath.row == 1 {
//            guard let munhaeVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeVideoViewController")  as? MunhaeVideoViewController else {return}
//            navigationController?.pushViewController(munhaeVideoViewController, animated: true)
//        }else if indexPath.row == 2 {
//            guard let munhaeVideoViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeVideoViewController")  as? MunhaeVideoViewController else {return}
//            navigationController?.pushViewController(munhaeVideoViewController, animated: true)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 60: 44
    }
    class ViewController: UIViewController {

    }
    
}
