//
//  AudioEventsView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/27/22.
//

import SwiftUI
import DSWaveformImage
import DSWaveformImageViews
import AVFAudio
import CoreData

struct AudioEventsView: View {
    @ObservedObject var config: Config
    @ObservedObject var nightDelegate: NightDelegate
    @State var showInfoView: Bool = false
    @State var eventType: EventTypes = .snoring
    enum EventTypes {
        case snoring, speaking, coughing
    }
    var nightString: String
    
    init(config: Config, nightDelegate: NightDelegate) {
        self.config = config
        self.nightDelegate = nightDelegate
        nightString = nightDelegate.startDate?.asMonthDayString ?? ""
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Picker("type", selection: $eventType) {
                    Text("snoring")
                        .tag(EventTypes.snoring)
                    Text("speaking")
                        .tag(EventTypes.speaking)
                    Text("coughing")
                        .tag(EventTypes.coughing)
                }.pickerStyle(.segmented)
                HStack {
                    Text("help improve our analysis")
                        .font(.headline)
                        .foregroundColor(primary)
                    Button(action: {
                        withAnimation(.spring()) {
                            self.showInfoView.toggle()
                        }
                    },
                           label: {
                        Text("learn more...")
                    })
                }
                .padding([.top, .horizontal])
                switch(eventType) {
                case .snoring:
                    snoring
                case .speaking:
                    speaking
                case .coughing:
                    coughing
                }
                Spacer()
            }
            if showInfoView {
                InfoView(config: config, showInfoView: $showInfoView)
                    .transition(.offset(y: height))
            }
        }
    }
    
    var snoring: some View {
        VStack {
            if nightDelegate.snoringURLs.count == 0 {
                VStack {
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(0.5)
                        .frame(width: width/5, height: height/10)
                    HStack {
                        Spacer()
                        Text("no snoring events detected")
                        Spacer()
                    }
                    .padding()
                    Spacer()
                }
                .padding()
                .foregroundColor(primary)
            } else {
                ScrollView {
                    eventView
                }
            }
        }
    }
    
    var speaking: some View {
        EmptyView()
    }
    
    var coughing: some View {
        EmptyView()
    }

    var eventView: some View {
        VStack {
            ForEach((0..<nightDelegate.snoringURLs.count), id: \.self) { num in
                SnoringEventView(nightDelegate: nightDelegate, index: num)
            }
            .padding()
            .frame(width: width, height: width/2.1)
        }
    }
}

struct SnoringEventView: View {
    var nightDelegate: NightDelegate
    var index: Int
    var audioPlayer: AVAudioPlayer?
    var configuration: Waveform.Configuration = Waveform.Configuration(style: .striped(Waveform.Style.StripeConfig(color: UIColor(Color.blue), width: 4)))
    
    init(nightDelegate: NightDelegate, index: Int) {
        self.nightDelegate = nightDelegate
        self.index = index
//        do {
//            let session = AVAudioSession.sharedInstance()
//            try session.setCategory(.ambient, options: [.mixWithOthers])
//            try session.setActive(true)
//        } catch {
//            print("unable to configure or start audio session")
//        }
        self.audioPlayer = try? AVAudioPlayer(contentsOf: buildAudioURL(nightDelegate.snoringURLs[index]))
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer?.volume = 10.0
    }
    
    func buildAudioURL(_ snoringURL: URL) -> URL {
        return getDocumentsDirectory().appendingPathComponent(snoringURL.absoluteString)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("you snored")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(primary)
                    Text("at 5:35 AM: ")
                        .font(.headline)
                        .foregroundColor(secondary)
                }
                Spacer()
                Button(action: {
                    if audioPlayer!.isPlaying {
                        audioPlayer?.stop()
                    } else {
                        audioPlayer?.play()
                    }
                }, label: {
                    Image(systemName: "playpause.fill")
                        .foregroundColor(primary)
                        .padding(.trailing)
                })
            }
            WaveformView(audioURL: buildAudioURL(nightDelegate.snoringURLs[index]), configuration: configuration)
        }
        .onDisappear {
            let session = AVAudioSession.sharedInstance()
//            do {
//                try session.setActive(false)
//            } catch {
//                print("unable to deactivate ambient audio session \(error)")
//            }
        }
    }
}

struct InfoView: View {
    @ObservedObject var config: Config
    @Binding var showInfoView: Bool
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .gesture(TapGesture()
                    .onEnded({ _ in
                        withAnimation(.spring()) {
                            showInfoView.toggle()
                        }
                    }))
            VStack {
                VStack {
                    Image("mindmap")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .scaleEffect(0.8)
                        .frame(width: width/8, height: height/15)
                        .foregroundColor(config.accentColor)
                    Text("help us improve")
                        .foregroundColor(.gray)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                }
                Text("night right uses artificial intelligence to recognize snoring, speaking and coughing. help improve our analysis by marking recordings incorrect. you can also review low confidence labels and mark them as correct or incorrect.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                HStack {
                    Image(systemName: "exclamationmark.circle")
                    Text("by providing feedback you cosent to night right processing recordings")
                        .font(.footnote)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.gray)
                .padding(.bottom)
                Divider()
                Button("close") {
                    withAnimation(.spring()) {
                        showInfoView.toggle()
                    }
                }
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: width/1.25)
            .gesture(DragGesture(minimumDistance: 5, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 0 {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            withAnimation(.spring()) {
                                showInfoView.toggle()
                            }
                        }
                    }
                })
        }
    }
}

struct AudioEventsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioEventsView(config: Config(), nightDelegate: NightDelegate())
    }
}
