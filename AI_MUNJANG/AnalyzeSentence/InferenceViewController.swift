
import UIKit

class InferenceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contentsDic: [String : Any] = [:]
    var sectionHeader: [String] = ["나는 학교에 가고", "엄마는 회사에 간다."]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.backButtonTitle = " "
        
        contentsDic = ["나는 학교에 가고" :["나는 가고", "나는 학교에 가고"],
                       "엄마는 회사에 간다." :["엄마는 가고", "엄마는 회사에 가고"]]
        
      

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

    // MARK: - Row Cell

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentsDic[sectionHeader[section]] as! [String]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        
        cell.textLabel?.text = (contentsDic[sectionHeader[indexPath.section]] as! [String])[indexPath.row]
        cell.contentView.backgroundColor = .lightGray

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
