//
//  UserInfo.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/08/23.
//

import Foundation
import FirebaseFirestore

struct UserInfo: Codable {
    
    let displayName: String
    let learningProgress: Int
    let numberOfHearts: Int
    
}

class MyInfo {
    static let shared = MyInfo()

    var displayName: String = "홍길동"
    var learningProgress: Int = 0
    var numberOfHearts: Int = 0

    private init() { }
}

class DataFromFirestore {
    static let share = DataFromFirestore()
    let db = Firestore.firestore()
    
    
    func gettingDoc(userID:String, completionHandler: @escaping (UserInfo) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            
            var user :UserInfo = UserInfo(displayName: "", learningProgress: 0, numberOfHearts: 0)
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else {return}
                let decoder =  JSONDecoder()
                
                for document in documents {
                    if document.documentID == userID {
                        do {
                            let data = document.data()["userinfo"]
                            let jsonData = try JSONSerialization.data(withJSONObject:data!)
                            
                            let info = try decoder.decode(UserInfo.self, from: jsonData)
                            user = info
                            print(user)
                        } catch let err {
                            print("err: \(err)")
                        }
                    }
                }
                completionHandler(user)
            }
        }
    }
    
    func settingDoc(userID:String, userInfo:MyInfo) {
        
        // Document 이름 직접 만들기
        db.collection("users").document(userID).setData([:]) { err in
            if let err = err {
                print(err)
            } else {
                print("Success")
            }
        }
        
        let path = db.collection("users").document(userID)
        path.updateData(["userinfo": ["displayName":userInfo.displayName,
                                      "learningProgress":userInfo.learningProgress,
                                      "numberOfHearts":userInfo.numberOfHearts]])
    }
    
    
    func deleteDoc(userID:String) {
        db.collection("users").document(userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

    }
}
