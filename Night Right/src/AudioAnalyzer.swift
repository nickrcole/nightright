//
//  AudioAnalyzer.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/25/22.
//

import Foundation
import SoundAnalysis
import SwiftUI

enum AudioAnalysisErrors: Error {
    case ModelInterpretationError
    case AnalysisError(error: String)
}

class AudioAnalyzer: NSObject, SNResultsObserving, ObservableObject {
    @ObservedObject var config: Config
    var prediction: String?
    var confidence: Double?
    let snoringEventManager: SnoringEventManager
    
    internal init(config: Config, prediction: String? = nil, confidence: Double? = nil, snoringEventManager: SnoringEventManager) {
        self.config = config
        self.prediction = prediction
        self.confidence = confidence
        self.snoringEventManager = snoringEventManager
    }
    
    func makeRequest(_ customModel: MLModel? = nil) throws -> SNClassifySoundRequest {
        if let model = customModel {
            let customRequest = try SNClassifySoundRequest(mlModel: model)
            return customRequest
        } else {
            throw AudioAnalysisErrors.ModelInterpretationError
        }
    }
    
    func request(_ request: SNRequest, didProduce: SNResult) {
        if config.alarmTime.forAlarmComparison == Date().forAlarmComparison {
            DispatchQueue.main.async {
                self.config.triggerAlarm = true
            }
        }
        guard let classificationResult = didProduce as? SNClassificationResult else { return }
        let topClassification = classificationResult.classifications.first
        let timeRange = classificationResult.timeRange
        self.prediction = topClassification?.identifier
        self.confidence = topClassification?.confidence
        if self.prediction! == "snoring" {
            self.snoringEventManager.snoringDetected()
        } else {
            self.snoringEventManager.nonSnoringDetected()
        }
    }
    
    func request(_ request: SNRequest, didFailWithError: Error) {
        print("audio classification ended with error \(didFailWithError)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("audio classification stopped")
    }
}
