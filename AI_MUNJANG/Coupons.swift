//
//  coupons.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/10/21.
//

import Foundation
import FirebaseFirestore

//MARK: - Coupone ์์ฑ
func generateCoupons(){
        let db = Firestore.firestore()
       // Write Data to Firestore(๐๐๐๐๐์์ฑ- ์ฟ ํฐ3000๊ฐ๋ฅผ ๊ธฐ๋ก)
       if let filepath = Bundle.main.path(forResource: "coupon4000", ofType: "txt") {
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

//MARK: - ์ฟ ํฐ ์กฐํ(KIMDONGCHEOL01) ๋ฐ ์๋ฐ์ดํธ(์ฌ์ฉ์, ์ ์ฉ์์์ผ, ๋ง๋ฃ์ผ)
func retrieveCoupon(docID:String, completionHandler: @escaping (Bool) -> Void){
    
      //์ฟ ํฐ ์กฐํ(KIMDONGCHEOL01) ๋ฐ ์๋ฐ์ดํธ(์ฌ์ฉ์, ์ ์ฉ์์์ผ, ๋ง๋ฃ์ผ)
      let db = Firestore.firestore()
      let docRef = db.collection("coupons").document(docID)
    
      docRef.getDocument { (document, error) in
          var isUsable = false
          if let document = document, document.exists {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Document data: \(dataDescription)")
              
              if document.data()!["usable"] as! Bool == true {
                  print("์ฟ ํฐ ์ฌ์ฉ๊ฐ๋ฅ")
                  isUsable = true
              }else{
                  print("์ฟ ํฐ ์ฌ์ฉ๋ถ๊ฐ")
                  isUsable = false
              }
             
          } else {
              print("Document does not exist")
              isUsable = false
          }
          completionHandler(isUsable)
      }
}
            
//MARK: - ์ฟ ํฐ ์๋ฐ์ดํธ
func setUpCouponRecord(docID:String, completionHandler: @escaping (Bool) -> Void){
    let db = Firestore.firestore()
    let docRef = db.collection("coupons").document(docID)

    let currentTime = Date()
    let createdTimeString = dateToString(date: currentTime)
    var validDuringDays = 0
    let tmpMonth = docID.components(separatedBy: "#")[0] //์ฟ ํฐ์ ์) 1#SEO0_O6IDWP51ENAK
    validDuringDays = Int(tmpMonth)! * 30 // 1๊ฐ์๋ง๋ค * 30์ผ, ํฅํ ์์์ ๊ฐ์์ด ์ค๋๋ผ๋
    let dueTime = Calendar.current.date(byAdding: .day, value: validDuringDays, to: currentTime)
    let dueTimeString = dateToString(date: dueTime!)
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let userID = UserDefaults.standard.value(forKey: "userID") as! String
            document.reference.updateData(["dueDate":dueTimeString,"createdDate":createdTimeString, "usable":false, "user":userID])
            //์ฟ ํฐ์ด ์ ์์ ์ผ๋ก ๋ฑ๋ก๋์์ผ๋ฏ๋ก ๊ตฌ๋์๋ก ์ค์ 
            Core.shared.setUserSubscription()
            MyInfo.shared.couponID = docID
            
           completionHandler(true)
        } else {
            print("Document does not exist")
            completionHandler(false)
        }
    
    }
    
    
}
            
//MARK: - ์ฟ ํฐ๊ฒฐ์ ํ ์ฌ์ฉ์์์ ์ ํจ๊ธฐ๊ฐ ์ ๊ฒ
//์ ์์ ์ธ ์ฟ ํฐ ์ฌ์ฉ์๋ผ ํ๋๋ผ๋ ์ฑ์ด ๋ก๋ฉ๋ ๋๋ง๋ค ์ ํจ๊ธฐ๊ฐ์ด ๋ง๋ฃ๋์๋์ง ํ์ธํ๋ ์์ค ์์ด์ผํ๋ค.
//์ ํจ๊ธฐ๊ฐ์ด ๋ง๋ฃ์, setUserCancelSubscription ์ค์ 
func checkTheValidateCouponUser(docID:String){
    print(docID)
    let db = Firestore.firestore()
    let docRef = db.collection("coupons").document(docID)
    docRef.getDocument { (document, error) in
        
        if let document = document, document.exists {
            
            guard let dueDate = document.data()!["dueDate"] as? String else{ return}
            print(dueDate)
            let due:Date = stringToDate(strDate: dueDate)
            if due < Date() { //ํ์ฌ ๋ ์ง๋ณด๋ค ์๋ค๋ฉด ์ ํจ๊ธฐ๊ฐ์ด ๋ง๋ฃ๋ ๊ฒ
                print("์ฟ ํฐ ์ ํจ๊ธฐ๊ฐ ๋ง๋ฃ๋จ")
                Core.shared.setUserCancelSubscription()
                //๋ง๋ฃ์ firebase DB์ couponID์ญ์ , ์ฌ์ฉ์์ DB์์ couponID์ญ์ 
                 guard let userID = document.data()!["user"] as? String else{ return}
                 deleteCouponID(userID)
            }else{
                print("์ฟ ํฐ ์ ํจ๊ธฐ๊ฐ ์ ํจํจ")
            }
            print(due)
            
        } else {
            print("Document does not exist")
        }
    }
}

func deleteCouponID(_ userID:String){
        let db = Firestore.firestore()
        
        let path = db.collection("users")
        
        path.getDocuments { (snapshot, err) in
            if let err = err {
                print(err)
            } else {
                guard let snapshot = snapshot else { return }
                for document in snapshot.documents {
                    if document.documentID == userID {
                        // ๋์๋๋ฆฌ ๋ฐ์ดํฐ๋ฅผ ๊ฐ์ ธ์จ๋ค.
                        guard var data = document["userinfo"] as? [String:Any] else { return }

                        data.updateValue("", forKey: "couponID")
                        
                        
                        // ์๋ฒ์ ๋์๋๋ฆฌ ๋ฐ์ดํฐ๋ฅผ ์์ ๋ ๋ฐ์ดํฐ๋ก ์์ ํ๋ค.
                        path.document(userID).updateData(["userinfo" : data])
                    }
                }
            }
        }
    }

//MARK: - ์ฟ ํฐ ์บ ํ์ธ ์ด์ฉ์ค์ธ์ง ์ฌ๋ถํ์ธ
//์ฟ ํฐ ์บ ํ์ธ ์ด์์ฌ๋ถ๋ฅผ ์์์ผ ์ฑ์์ ์ฟ ํฐ๋ฒํผ์ ํ์ฑํํ  ์ง ์ฌ๋ถ ํ๋จ
func retrieveCouponeCampaign(completionHandler: @escaping (Bool) -> Void){
    
    let db = Firestore.firestore()
    let docRef = db.collection("campaign").document("campaign")
    docRef.getDocument { (document, error) in
        var isUsable = false
        if let document = document, document.exists {
            
            if document.data()!["usable"] as! Bool == true {
                print("์บ ํ์ธ ํ์ฌ์ค")
                isUsable = true
            }else{
                print("์บ ํ์ธ ํ์ฌ ์ข๋ฃ")
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
