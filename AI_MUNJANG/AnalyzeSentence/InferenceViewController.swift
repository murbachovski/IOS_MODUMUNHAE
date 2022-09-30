
import UIKit

class InferenceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contentsDic: [String : Any] = [:]
    var sectionHeader: [String] = []
    var cellDataSource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        contentsDic = ["나는 학교에 가고" :["나는", "학교에", "가고"],
                       "엄마는 회사에 간다." :["엄마는", "회사에", "간다."]]
//        sectionHeader = contentsDic.keys as! [String]
        for i in contentsDic.keys {
            sectionHeader.append(i)
        }
        cellDataSource = Array((contentsDic.values))
//        for i in contentsDic.values {
//            cellDataSource.append(i as! [String])
//        }
    }
}

extension InferenceViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Section

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }

//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return sectionFooter[section]
//    }

    // MARK: - Row Cell

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        let content = cellDataSource[indexPath.section] as! [String]
        cell.textLabel?.text = content[indexPath.row] as! String
        cell.contentView.backgroundColor = .lightGray
   
//        cell.layer.cornerRadius=10 //set corner radius here
//        cell.layer.borderColor = UIColor.lightGray.cgColor  // set cell border color here
//        cell.layer.borderWidth = 2 // set border width here
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
}
