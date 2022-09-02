//
//  MunhaeTestViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/02.
//

import UIKit

class MunhaeTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet var munhaeTestTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        munhaeTestTableView.delegate = self
        munhaeTestTableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "예시\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
