//
//  DebugInfo.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/14/23.
//

import Foundation

public class DebugInfo: NSObject, Identifiable {
    
    
    init(recordingTime: Date?, resultChain: [Bool], audioSaveFilename: URL) {
        self.recordingTime = recordingTime
        self.resultChain = resultChain
        self.audioSaveFilename = audioSaveFilename
    }
    
    var recordingTime: Date?
    var resultChain: [Bool]
    var audioSaveFilename: URL
    
    var toString: String {
        return "\(recordingTime?.formatted())\n\(resultChain)\n\(audioSaveFilename)"
    }
    
}
