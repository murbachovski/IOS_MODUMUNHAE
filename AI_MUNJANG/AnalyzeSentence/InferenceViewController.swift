
import UIKit

class InferenceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contentsData: [[String : Any]] = [[:]]
//    var contentsDic: [String : Any] = [:]
    var sectionHeader: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.backButtonTitle = " "
        self.title = "문장추론"
        
      print(contentsData)
        for i in contentsData {
            sectionHeader.append(i["sen"] as! String)
        }
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
    }
    
    @objc func homeBtnTapped(){
        changeMainNC()
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

        return (contentsData[section]["infer_sen"] as! [String]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!

        cell.textLabel?.text = "- \((contentsData[indexPath.section]["infer_sen"] as! [String])[indexPath.row])"
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
