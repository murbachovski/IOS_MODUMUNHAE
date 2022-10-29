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
    var senGrade = ""
    
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
        
        gradLabel.text = "문장 등급 : \(senGrade)"
        gradLabel.font = UIFont(name: "NanumSquareEB", size: UIDevice.current.userInterfaceIdiom == .pad ? 24: 20)
        gradLabel.textColor = hexStringToUIColor(hex: Constants.primaryColor)
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
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#F7F9FB")
        }else if indexPath.section == 1{
            cell.textLabel?.text = morphData[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#F7F9FB")
        }else{
            cell.textLabel?.text = phraseData[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = hexStringToUIColor(hex: "#F7F9FB")
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = hexStringToUIColor(hex: Constants.primaryColor)
            header.textLabel?.font = UIFont(name: "NanumSquareEB", size: 16)
            header.textLabel?.frame = header.bounds
            
        }
    }
}
