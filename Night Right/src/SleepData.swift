//
//  SleepData.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/20/22.
//

import Foundation

struct  SleepData: Hashable, Identifiable {
    var startTime: Date
    var endTime: Date
    var score: Int8
    var id = UUID()
    
    var asString: String {
        return "\(startTime.asDayString): score \(score)"
    }
    
}
