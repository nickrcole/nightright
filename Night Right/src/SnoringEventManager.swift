//
//  SnoringEventManager.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/3/23.

import Foundation
import AVFAudio
import SwiftUI

class SnoringEventManager {
    
    var resultChain: [Bool] = [] // true represents a snoring detection and false represents non-snoring
    var snoringChain: Int = 0
    var nonSnoringChain: Int = 0
    var snoring: Bool = false
    var audioFilename: URL?
    var audioSaveFilename: URL?
    var audioRecorder: AVAudioRecorder?
    var startDate: Date = Date()
    var idnum: Int = 0
    var snoringURLs: [URL] = []
    var debugEntries: [DebugInfo] = []
    var startTime: Date?
    
    let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    func resetSnoringValues() {
        resultChain.removeAll()
        snoringChain = 0
        nonSnoringChain = 0
        snoring = false
    }
    
    func snoringDetected() {
        resultChain.append(true)
        nonSnoringChain = 0
        snoringChain += 1
        if !snoring {
            if snoringChain > 1 {
                snoring = true
                initializeRecorder()
            }
        }
    }
    
    func nonSnoringDetected() {
        if snoring {
            nonSnoringChain += 1
            resultChain.append(false)
            if nonSnoringChain > 5 {
                terminateSnoringEvent()
            }
        }
    }
    
    func initializeRecorder() {
        startTime = Date()
        let nightFolderURL = getDocumentsDirectory().appendingPathComponent(startDate.asFullDateStringForDirectory)
        do {
            try FileManager.default.createDirectory(atPath: nightFolderURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print("Unable to create directory")
        }
        audioFilename = nightFolderURL.appendingPathComponent("\(idnum).m4a")
        let baseURLForSave = URL(string: "\(startDate.asFullDateStringForDirectory)")
        audioSaveFilename = baseURLForSave?.appendingPathComponent("\(idnum).m4a")
        do {
            audioRecorder = try AVAudioRecorder(url: self.audioFilename!, settings: self.settings)
        } catch {
            print(error)
        }
        // recordingSession.requestRecordPermission() { [unowned self] allowed in
        initializeSnoringEvent()
    }
    
    func initializeSnoringEvent() {
        if audioRecorder == nil {
            print("unable to initialize audio recording session")
            return
        }
        print("starting snoring event")
        audioRecorder!.record()
    }
    
    func terminateSnoringEvent() {
        idnum += 1
        print("terminating snoring event")
        resetSnoringValues()
        audioRecorder!.stop()
        debugEntries.append(DebugInfo(recordingTime: startTime, resultChain: resultChain, audioSaveFilename: audioSaveFilename!))
        snoringURLs.append(audioSaveFilename!)
    }
}
