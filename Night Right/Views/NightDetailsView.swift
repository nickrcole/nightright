//
//  NightDetailsView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/21/22.
//

import SwiftUI
import AVFAudio
import DSWaveformImage
import DSWaveformImageViews

struct NightDetailsView: View {
    @ObservedObject var config: Config
    @ObservedObject var night: NightDelegate
    let waveformColor: Color = .blue
    @State var audioURL = Bundle.main.url(forResource: "snoring343", withExtension: "wav")!
    @State var configuration: Waveform.Configuration = Waveform.Configuration(style: .striped(Waveform.Style.StripeConfig(color: UIColor(Color.blue), width: 4)))
    @State var dreamNotes: [String] = Array(0..<5).map { num in String(num) }
    var audioPlayer: AVAudioPlayer?
    
    init(config: Config, nightDelegate: NightDelegate) {
        self.config = config
        self.night = nightDelegate
        self.audioPlayer = try? AVAudioPlayer(contentsOf: audioURL, fileTypeHint: "wav")
        self.audioPlayer?.prepareToPlay()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("night of \(night.startDate?.asMonthDayString ?? "")")
                    .padding()
                    .font(.title)
                    .foregroundColor(primary)
                    .fontWeight(.bold)
                VStack {
                    HStack {
                        timeAsleep
                        scoreCard
                    }
                    Spacer()
                    audioEvents
                    Spacer()
                    dreams
                }
                Spacer()
            }
        }
//        }
    }
    
    var timeAsleep: some View {
        VStack {
            if night.startDate != nil && night.endDate != nil {
                ClockView(config: config, startTime: night.startDate!, endTime: night.endDate!)
                    .scaleEffect(0.5)
                    .frame(width: width/2.1, height: width/2.1)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                EmptyView()
            }
        }
    }
    
    var scoreCard: some View {
        VStack {
            Text("score")
                .foregroundColor(primary)
                .font(.title)
                .fontWeight(.bold)
            Text(String(night.score))
                .font(.system(size: 100))
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
        }
        .frame(width: width/2.1, height: width/2.1)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var audioEvents: some View {
        ZStack {
//            Rectangle()
//                .frame(width: width, height: width/2.1)
//                .foregroundColor(Color(UIColor(named: "darkBackground")!))
//                .cornerRadius(30)
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
                        if self.audioPlayer!.isPlaying {
                            self.audioPlayer?.stop()
                        } else {
                            self.audioPlayer?.play()
                        }
                    }, label: {
                        Image(systemName: "playpause.fill")
                            .foregroundColor(primary)
                            .padding(.trailing)
                    })
                }
                WaveformView(audioURL: audioURL, configuration: configuration)
                NavigationLink(destination: {
                    AudioEventsView(config: config, nightDelegate: night)
                },
                               label: {
                    HStack {
                        Spacer()
                        Text("view all")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(primary)
                })
            }
            .padding()
            .frame(width: width/1.03, height: width/2.1)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    var dreams: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("dreams")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(primary)
                    Text("light dreaming")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(secondary)
                }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(config.accentColor)
                    .scaleEffect(1.25)
                    .padding([.vertical, .trailing])
            }
            ScrollView {
                ForEach(0..<dreamNotes.count) { i in
                    HStack {
                        Circle()
                            .foregroundColor(primary)
                            .frame(width: width/65)
                        TextField(dreamNotes[i], text: $dreamNotes[i], axis: .vertical)
                            .lineLimit(10)
                            .font(.title3)
                            .foregroundColor(primary)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .frame(width: width/1.03, height: width/2.1)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var dream: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                Color.yellow.opacity(0.8)
                    .frame(height: height/40)
                Spacer()
            }
        }
        
    }
}

struct DreamPreview: View {
    @State var dream: String
    var body: some View {
        Text(dream)
    }
}

struct CardView<Content: View>: View {
    @Binding var selectThisView: Bool
    var leftSide: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
//        FlippableView(flipView: $selectThisView, primary: {
        content()
            .frame(width: width/2.1, height: width/2.1)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
//        }, secondary: {
//            content()
//                .frame(width: width/2.1, height: width/2.1)
//                .background(.regularMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//        }, leftSide: leftSide)
//        .zIndex(selectThisView ? 6 : 0)
//        // .scaleEffect(selectThisView ? 1.5 : 1)
//        // .offset(x: selectThisView ? leftSide ? width/4 : -width/4 : 0, y: selectThisView ? 0 : 0)
//        .gesture(TapGesture()
//            .onEnded {
//                withAnimation(.spring()) {
//                    selectThisView.toggle()
//                }
//            })
    }
}

struct NightDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NightDetailsView(config: Config(), nightDelegate: NightDelegate())
    }
}
