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
        
        self.navigationItem.title = "문해력 테스트"
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MunhaeTestContentData.shared.munhaeTestTotal["TestNumber"]
//        return groupedContents.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel!.text = "1. 당신의 문해력은?"
        }else if indexPath.row == 1 {
            cell.textLabel!.text = "2. 오답유형의 문제를 반복 추천"
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.textLabel?.font = UIFont(name: "NanumSquare", size: 20)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        guard let munhaeTestQuizViewController = self.storyboard?.instantiateViewController(withIdentifier: "MunhaeTestQuizViewController")  as? MunhaeTestQuizViewController else {return}
        munhaeTestQuizViewController.modalPresentationStyle = .fullScreen
        if indexPath.row == 0 {
            
            print("선택된 시험 \(indexPath.row)")
            print("선택된 시험 내용 : \(groupedContents[indexPath.row])")
            munhaeTestQuizViewController.currentQuizPool = groupedContents[indexPath.row]
            munhaeTestQuizViewController.isRecommendPool = false
        }else if indexPath.row == 1 {
            
            print("😀선택된 시험은 문장8경 추천문제풀")
            munhaeTestQuizViewController.currentQuizPool = setupRecommentTestPool()
            munhaeTestQuizViewController.isRecommendPool = true
        }
        present(munhaeTestQuizViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 60: 44
    }
    
    
    func setupRecommentTestPool()-> MunhaeTestContents{
        
        //1. tmpContent를 quizContents에서 발췌 24
        
        //2. quizContents의 유형을 MunhaeTestContent로 전환
        
        //3 .MunhaeTestContents를 반환
        
    //    return
        var tmpListTt = [QuizContent]()
        for k in 0..<8{
            var tmpList = [QuizContent]()
            let tmp = QuizContentData.shared.sectionTotal[k]
            
            for i in tmp {
                if i.type == "글"{
                    tmpList.append(i)
                }
            }
            tmpListTt += tmpList.shuffled().prefix(3)
        }
        
        print(tmpListTt)
        print(tmpListTt.count)
        var recommendPool: MunhaeTestContents = [MunhaeTestContent]()
        for (index, element) in tmpListTt.enumerated() {
            //element.section을 testnumber로 치환하여 틀린문제를 추적한다.
            let tmpContent = MunhaeTestContent(testnumber:element.section , id: index + 1, title: element.title, jimun: element.jimun, example: element.example, result: element.result!)
            recommendPool.append(tmpContent)
        }
        
        print("recommentPool : \(recommendPool)")
        return recommendPool
        
    }
    
}

