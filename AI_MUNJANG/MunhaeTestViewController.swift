//
//  MunhaeTestViewController.swift
//  AI_MUNJANG
//
//  Created by murba chovski on 2022/09/02.
//

import UIKit

class MunhaeTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet var munhaeTestTableView: UITableView!
    var groupedContents: [MunhaeTestContents] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        munhaeTestTableView.delegate = self
        munhaeTestTableView.dataSource = self
        
        let currentContents = MunhaeTestContentData.shared.munhaeTestTotal
        let grouped: [[MunhaeTestContent]] = currentContents.reduce(into: []) {
            $0.last?.last?.testnumber == $1.testnumber ?
            $0[$0.index(before: $0.endIndex)].append($1) :
            $0.append([$1])
        }
        
        print("grouped:\(grouped)")
        groupedContents = grouped
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MunhaeTestContentData.shared.munhaeTestTotal["TestNumber"]
        return groupedContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "예시\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let munhaeTestQuizViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeTestQuizViewController")  as? MunhaeTestQuizViewController else {return}
        munhaeTestQuizViewController.modalPresentationStyle = .fullScreen
        print("선택된 시험 \(indexPath.row)")
        print("선택된 시험 내용 : \(groupedContents[indexPath.row])")
        munhaeTestQuizViewController.currentQuizPool = groupedContents[indexPath.row]
        present(munhaeTestQuizViewController, animated: true)
    }
    
}