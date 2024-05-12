//
//  Date.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import Foundation

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
