//
//  coupons.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/10/21.
//

import Foundation
import FirebaseFirestore

//MARK: - Coupone 생성
func generateCoupons(){
        let db = Firestore.firestore()
       // Write Data to Firestore(🙄🙄🙄🙄🙄생성- 쿠폰3000개를 기록)
       if let filepath = Bundle.main.path(forResource: "coupons_3000", ofType: "txt") {
           do {
               let contents = try String(contentsOfFile: filepath)
               
               let textList: [String] = contents.components(separatedBy: "\n")
               
               for i in 0 ..< textList.count-1{
                 let collection = db.collection("coupons")
                   let dic = ["usable":true] as [String : Any]
                   collection.document("\(textList[i])").setData(dic)
             }
               
           } catch {
               Swift.print("Fatal Error: \(error.localizedDescription)")

               // contents could not be loaded
           }
       } else {
           // example.txt not found!
           print("Not Fouund")
       }
       
}

//MARK: - 쿠폰 조회(KIMDONGCHEOL01) 및 업데이트(사용자, 적용시작일, 만료일)
func retrieveAndUpdateCoupone(docID:String){
    
      //쿠폰 조회(KIMDONGCHEOL01) 및 업데이트(사용자, 적용시작일, 만료일)
      let db = Firestore.firestore()
      let docRef = db.collection("coupons").document(docID)

      let currentTime = Date()
      let createdTimeString = dateToString(date: currentTime)
      let dueTime = Calendar.current.date(byAdding: .day, value: 180, to: currentTime)
      let dueTimeString = dateToString(date: dueTime!)
      docRef.getDocument { (document, error) in
          if let document = document, document.exists {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Document data: \(dataDescription)")
              
              if document.data()!["usable"] as! Bool == true {
                  print("쿠폰 사용가능")
              }else{
                  print("쿠폰 사용불가")
                  return
              }
              document.reference.updateData(["dueDate":dueTimeString,"createdDate":createdTimeString, "usable":false, "user":"flutter6675@gmail.com"])
          } else {
              print("Document does not exist")
          }
      }
}
//MARK: - 쿠폰결제후 사용자의의 유효기간 점검
//정상적인 쿠폰 사용자라 하더라도 앱이 로딩될때마다 유효기간이 만료되었는지 확인하는 소스 있어야한다.

//MARK: - 쿠폰 캠페인 운용중인지 여부확인
//쿠폰 캠페인 유효기간을 알아야 앱에서 쿠폰버튼을 활성화할 지 여부 판단
func retrieveCouponeCampaign(completionHandler: @escaping (Bool) -> Void){
    
    let db = Firestore.firestore()
    let docRef = db.collection("campaign").document("campaign")
    docRef.getDocument { (document, error) in
        var isUsable = false
        if let document = document, document.exists {
            
            if document.data()!["usable"] as! Bool == true {
                print("캠페인 행사중")
                isUsable = true
            }else{
                print("캠페인 행사 종료")
                 isUsable = false
            }
            
        } else {
            print("Document does not exist")
        }
        completionHandler(isUsable)
    }
}



//MARK: - Helper Method

func dateToString(date:Date)->String{
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm"

      //Using the dateFromString variable from before.
      let stringDate: String = formatter.string(from: date)
      return stringDate
}

func stringToDate(strDate:String)->Date{
   
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
       let dateFromString: Date? = dateFormatter.date(from: strDate)
    
       return dateFromString!
}
