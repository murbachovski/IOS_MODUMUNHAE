//
//  SenIndexViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/10/28.
//

import UIKit

class SenIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var indexTableView: UITableView!
    @IBOutlet var gradLabel: UILabel!
    @IBOutlet var originLabel: UILabel!
    let sectionHeader = ["낱말 지수", "형태소 지수", "절 지수"]
    var originSentence = ""
    var senGrade = 0
    
    var wordData:[String] = []
    var morphData:[String] = []
    var phraseData:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "문장지수"
        
        indexTableView.dataSource = self
        indexTableView.delegate = self
        
        originLabel.text = originSentence
        originLabel.backgroundColor = .white
        originLabel.layer.cornerRadius = 10
        originLabel.layer.shadowOpacity = 0.8
        originLabel.layer.shadowColor = UIColor.lightGray.cgColor
        originLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        originLabel.layer.shadowRadius = 2
        originLabel.layer.masksToBounds = false
        originLabel.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 24: 17)
        
        var scoreGrade = ""
        
        if senGrade < 15000 {
            scoreGrade = "초급"
        }else if senGrade >= 15000 && senGrade < 30000{
            scoreGrade = "중급"
        }else if senGrade >= 30000 && senGrade < 50000 {
            scoreGrade = "고급"
        }else {
            scoreGrade = "전문"
        }
        gradLabel.text = "문장 지수 : \(senGrade)(\(scoreGrade))"
        gradLabel.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 24: 20)
        gradLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
        
        displayHomeBtn()
    }
    
    
    fileprivate func displayHomeBtn() {
        //백버튼의 타이틀을 지우기위해
        navigationItem.backButtonTitle = ""
        
        //백버튼외에 추가적으로 홈버튼을 채우기 위해
        let imgIcon = UIImage(named: "icHome32Px")?.withRenderingMode(.alwaysOriginal)
        let homeButtonItem = UIBarButtonItem(image: imgIcon, style: .plain, target: self, action: #selector(homeBtnTapped))
        
        navigationItem.leftBarButtonItem = homeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        homeButtonItem.imageInsets = UIEdgeInsets(top: -4, left: -5, bottom: 0, right: 0)
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    // MARK: - Row Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //낱말 지수
            return wordData.count
        }else if section == 1 {//형태소 지수
            return morphData.count
        }else { //절 지수
            return phraseData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell")!
        
        if indexPath.section == 0{
            cell.textLabel?.text = wordData[indexPath.row]
            
        }else if indexPath.section == 1{
            cell.textLabel?.text = morphData[indexPath.row]
            
        }else{
            cell.textLabel?.text = phraseData[indexPath.row]
            
        }
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = hexStringToUIColor(hex: "#F7F9FB")
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = UIFont(name: "NanumSquareR", size: 20)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 10
        var corners: UIRectCorner = []
        
        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 60: 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = hexStringToUIColor(hex: Constants.primaryColor)
            header.textLabel?.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 20: 16)
            header.textLabel?.frame = header.bounds
            
        }
    }
}
