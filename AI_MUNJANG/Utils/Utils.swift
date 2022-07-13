//
//  Utils.swift
//  AI_MUNJANG
//
//  Created by admin on 2022/07/13.
//

import Foundation

public func isValidPassword(password:String) -> Bool {
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{7,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}
