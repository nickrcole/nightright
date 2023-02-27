//
//  NightSummaryView.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/16/23.
//

import SwiftUI

struct NightSummaryView: View {
//    @ObservedObject var nightDelegate: NightDelegate
    @Binding var sleepMode: Bool
    var thisNight: NightDelegate
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    
    init(sleepMode: Binding<Bool>, thisNight: NightDelegate) {
        self._sleepMode = sleepMode
        self.thisNight = thisNight
        timeFormatter.dateFormat = "h:mm"
        dateFormatter.dateFormat = "EEEE, MMMM d"
    }
    
    @State var showDreamLogEntry: Bool = false
    var body: some View {
        ZStack {
            Image("sunrise")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.25)
//                .blur(radius: 8)
                .overlay(.ultraThinMaterial)
//            ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    Image(systemName: "sun.haze.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: height/20)
                    VStack {
                        Text(timeFormatter.string(from: Date()))
                            .font(.largeTitle)
                            .scaleEffect(2)
                            .fontWeight(.light)
                            .padding(.bottom)
                        Text(dateFormatter.string(from: Date()).lowercased())
                            .font(.title2)
                    }
                    Text("good morning")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    HStack {
                        Text("you slept")
                            .font(.title3)
                        if thisNight.startDate != nil && thisNight.endDate != nil {
                            Text(String(diffMinutes(start: thisNight.startDate!, end: thisNight.endDate!) / 12))
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        Text("hours")
                            .font(.title3)
                    }
                    HStack {
                        Text(String(thisNight.snoringURLs.count))
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("snoring events detected")
                            .font(.title3)
                    }
                    VStack {
                        Button(action: { showDreamLogEntry = true },
                               label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .scaleEffect(1.25)
                                Text("log dream")
                            }
                            .foregroundColor(orangeColor)
                        })
                        .padding(.bottom)
                        NavigationLink(value: thisNight) {
                            Text("next")
                                .foregroundColor(orangeColor)
                        }
                    }
                    .padding()
                }
            }
//            }
        }
        .onDisappear {
            sleepMode = false
        }
    }
}

//struct NightSummaryBuffer: View {
//    @State var sleepMode: Bool = false
//    var body: some View {
//        NightSummaryView(sleepMode: $sleepMode, thisNight: NightDelegate())
//    }
//}
//
//struct NightSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        NightSummaryBuffer()
//    }
//}
