//
//  MunhaeBeforeVideoViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/07.
//

import UIKit

class MunhaeBeforeVideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var beforeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beforeTableView.delegate = self
        beforeTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var userType = ""
        if indexPath.row == 0 {
            userType = "학부모"
        }else {
            userType = "학생용"
        }
        cell.textLabel!.text = userType
        
        return cell
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
