//
//  SleepAnalysisView.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/12/23.
//

import SwiftUI
import AVFAudio
import SoundAnalysis

struct SleepAnalysisView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var config: Config
    @ObservedObject var audioAnalyzer: AudioAnalyzer
    @Binding var sleepMode: Bool
    @State var nightSummary: Bool = false
    @State var thisNight: NightDelegate = NightDelegate()
    @State var songURL = Bundle.main.url(forResource: "oceanlove", withExtension: "wav")!
    var snoringEventManager: SnoringEventManager = SnoringEventManager()
    var audioEngine: AVAudioEngine
    var inputBus: AVAudioNodeBus
    var inputFormat: AVAudioFormat
    var streamAnalyzer: SNAudioStreamAnalyzer
    var audioPlayer: AVAudioPlayer?
    let analysisQueue = DispatchQueue(label: "com.example.AnalysisQueue")
    
    init(config: Config, sleepMode: Binding<Bool>) {
        self.config = config
        self._sleepMode = sleepMode
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers, .allowBluetooth])
        } catch {
            print("unable to configure audio session")
        }
        
        self.audioEngine = AVAudioEngine()
        self.inputBus = AVAudioNodeBus(0)
        self.inputFormat = audioEngine.inputNode.inputFormat(forBus: inputBus)
        self.streamAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
        self.audioAnalyzer = AudioAnalyzer(config: config, snoringEventManager: snoringEventManager)
        self.audioPlayer = try? AVAudioPlayer(contentsOf: songURL, fileTypeHint: "wav")
    }
    
    private func alarm() {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    private func startNightEvent() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
        } catch {
            print("unable to start play and record audio session")
        }
        startAudioEngine()
        installAudioTap()
    }
    
    private func stopAndSaveNight() {
        let newNight = NightDelegate(context: viewContext)
        newNight.startDate = snoringEventManager.startDate
        newNight.endDate = Date()
        newNight.snoreReduction = config.snoreReduction
        newNight.snoringURLs = snoringEventManager.snoringURLs
        newNight.score = Int64(newNight.snoringURLs.count)
        thisNight = newNight
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func terminateNight() {
        print("stopping audio engine")
        stopAndSaveNight()
        streamAnalyzer.completeAnalysis()
        streamAnalyzer.removeAllRequests()
        audioEngine.disconnectNodeInput(audioEngine.inputNode)
        audioEngine.inputNode.removeTap(onBus: inputBus)
        audioEngine.stop()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient)
        } catch {
            print("unable to set ambient audio session")
        }
        nightSummary = true
    }
    
    private func startAudioEngine() {
        do {
            // start the stream of audio data
            print("starting audio engine")
            try audioEngine.start()
            let snoreClassifier = try? SnoringClassifier2_0().model
            let classifySoundRequest = try audioAnalyzer.makeRequest(snoreClassifier)
            try streamAnalyzer.add(classifySoundRequest,
                                   withObserver: self.audioAnalyzer)
        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    private func installAudioTap() {
        self.audioEngine.inputNode.installTap(onBus: self.inputBus,
                                         bufferSize: 8192,
                                         format: self.inputFormat,
                                         block: analyzeAudio(buffer:at:))
    }

    private func analyzeAudio(buffer: AVAudioBuffer, at: AVAudioTime) {
        analysisQueue.async {
            self.streamAnalyzer.analyze(buffer,
                                        atAudioFramePosition: at.sampleTime)
        }
    }
    
    @State var showAlarmSet: Bool = false
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .foregroundColor(.black)
                    .scaleEffect(5)
                    .onAppear {
                        if sleepMode {
                            startNightEvent()
                        }
                    }
                VStack {
                    Spacer()
                    Image(systemName: "sleep")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(0.25)
                    Button(action: {
                        withAnimation(.spring()) {
                            showAlarmSet.toggle()
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "alarm")
                            Text("alarm \(config.alarmTime.asTimeString)")
                        }
                        .padding()
                        .background(.white.opacity(0.1))
                        .clipShape(Capsule())
                    })
//                    Button("alarm") {
//                        alarm()
//                    }
                    if config.triggerAlarm {
                        Button("alarm!") {
                            config.triggerAlarm = false
                        }
                    }
                    Spacer()
                    footer
                }.foregroundColor(dullWhite)
                    .background(.black)
                    .highPriorityGesture(DragGesture(minimumDistance: 5, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.height < 0 {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                    terminateNight()
                                }
                            }
                        })
                VStack {
                    if showAlarmSet {
                        Color.clear
                            .contentShape(Rectangle())
                            .gesture(TapGesture()
                                .onEnded {
                                    withAnimation(.spring()) {
                                        showAlarmSet = false
                                    }
                                })
                        AlarmSetView(config: config)
                    }
                }
            }
            .onChange(of: config.triggerAlarm) { triggerAlarm in
                if triggerAlarm {
                    alarm()
                }
            }
            if nightSummary {
                NightSummaryView(sleepMode: $sleepMode, thisNight: thisNight)
                    .transition(.opacity)
            }
        }
    }
    
    var footer: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 1.5)) {
                    terminateNight()
                }
            }, label: {
                Image(systemName: "chevron.up")
            })
        }
    }
}
