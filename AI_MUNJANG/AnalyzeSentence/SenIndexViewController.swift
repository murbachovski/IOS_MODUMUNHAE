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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTableView.dataSource = self
        indexTableView.delegate = self
        originLabel.text = originSentence
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    // MARK: - Row Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell")!
        
        cell.textLabel?.text = "TEST"
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = hexStringToUIColor(hex: "#F7F9FB")
        
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
