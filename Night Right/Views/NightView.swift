//
//  NightView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/20/22.
//

import SwiftUI

struct NightView: View {
    @ObservedObject var config: Config = Config()
//    @StateObject var nightDelegate: NightDelegate = NightDelegate()
    @State var sleepMode: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \NightDelegate.startDate, ascending: true)]) private var nights: FetchedResults<NightDelegate>
    
    var body: some View {
        NavigationStack {
            ZStack {
                if sleepMode {
                    SleepAnalysisView(config: config, sleepMode: $sleepMode)
                        .transition(.scale)
                } else {
                    TabView {
                        SleepView(sleepMode: $sleepMode)
                            .tabItem {
                                Label("sleep", systemImage: "moon")
                            }
                            .onAppear {
                                print(nights)
                            }
//                            .background(backgroundColor)
                            
//                            .toolbarBackground(.gray, for: .tabBar)
                            .toolbar(sleepMode ? .hidden : .visible, for: .tabBar)
                            .animation(.spring(), value: sleepMode)
                        StatsView(config: config, nights: nights)
                            .tabItem {
                                Label("progress", systemImage: "arrow.up.forward")
                            }
//                            .offset(y: -height/6)
                            .frame(height: height)
                            // .background(backgroundColor)
//                            .toolbarBackground(.clear, for: .tabBar)
                        SettingsView(config: config)
                            .tabItem {
                                Label("settings", systemImage: "gear")
                            }
                        DebugView()
                            .tabItem {
                                Label("debug", systemImage: "ant")
                            }
//                        DebugDataView()
//                            .tabItem {
//                                Label("debug", systemImage: "ant")
//                            }
//                            .toolbarBackground(.orange, for: .tabBar)
//                            .toolbar(sleepMode ? .hidden : .visible, for: .tabBar)
                    }
                    .transition(.opacity)
                }
            }
            .navigationDestination(for: NightDelegate.self) { night in
                NightDetailsView(config: config, nightDelegate: night)
            }
            .navigationDestination(for: Int.self) { num in
                HistoryView(config: config, nights: nights)
            }
        }
        .accentColor(config.accentColor)
//        .onAppear {
//            for night in nights {
//                config.nights.append(night)
//            }
//        }
    }
}

struct SleepView: View {
    @State var imageSize: Double = 0.6
    @Binding var sleepMode: Bool
    var body: some View {
        ZStack {
            SleepLanding
                .padding()
                .transition(.opacity)
        }
    }
    
    var SleepLanding: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1.5)) {
                            sleepMode.toggle()
                        }
                    }, label: {
                        Image("moon.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(imageSize)
                            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: imageSize)
                            .onAppear {
                                imageSize = 0.65
                            }
                    })
                    Text("tap to sleep")
                        .foregroundColor(primary)
                        .font(.callout)
                        .fontWeight(.light)
                }
                .background(
                    Image("nightsky2")
                        .overlay(.ultraThinMaterial)
                )
                Spacer()
            }
            //.foregroundColor(dullWhite)
        }
    }
    
}

struct StatsView: View {
    @ObservedObject var config: Config
    @State var nights: FetchedResults<NightDelegate>
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        //            Image("profile")
                        //                .resizable()
                        //                .aspectRatio(contentMode: .fit)
                        if nights.count >= 0 {
                            VStack(alignment: .center) {
                                Spacer()
                                VStack {
                                    VStack {
                                        HStack {
                                            Text("your sleep cycle")
                                                .font(.title)
                                                .foregroundColor(primary.opacity(0.8))
                                                .fontWeight(.bold)
                                            Spacer()
                                        }
                                        sleepCycle
                                    }
                                    .padding()
                                    .background(.thickMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    HStack {
                                        Text("your progress")
                                            .foregroundColor(primary.opacity(0.8))
                                            .fontWeight(.bold)
                                        Spacer()
                                        NavigationLink(destination: HistoryView(config: config, nights: nights)) {
                                            HStack {
                                                Text("see all")
                                                Image(systemName: "chevron.right")
                                            }
                                        }
                                    }
                                    .padding()
                                    //                    .frame(minWidth: ((Double(width)/7) * Double(nights.suffix(7).count)))
                                    .background(.thickMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                                .padding(.horizontal)
                                Spacer()
                                if nights.count > 0 {
                                    ChartView(config: config, nights: nights)
                                        .frame(width: width)
                                } else {
                                    GeometryReader { geo in
                                        ScrollView {
                                            VStack {
                                                HStack {
                                                    Image(systemName: "chart.bar.fill")
                                                    Text("no data to display")
                                                        .fontWeight(.bold)
                                                    Spacer()
                                                }
                                                .padding()
                                                .foregroundColor(.gray)
                                            Spacer()
                                            }
                                            .frame(width: geo.size.width)
                                            .frame(minHeight: geo.size.height - height/6)
                                        }
                                    }
                                    .padding()
                                    .background(.thickMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding()
                                }
                            }
                        }
                    }
                    .frame(height: height / 1.25)
                    .background(
                        Image("nightsky2")
                            .overlay(.ultraThinMaterial)
                    )
                }
                .frame(height: geo.size.height)
            }
        }
    }
    
    var sleepCycle: some View {
        ScrollView {
            VStack {
                Toggle(isOn: $config.alarm) {
                    Text("alarm")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
                .tint(config.accentColor)
                if config.alarm {
                    VStack {
                        DatePicker(selection: $config.alarmTime, displayedComponents: .hourAndMinute) {
                            Text("alarm set")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)            }
                Toggle(isOn: $config.bedtimeNotifications) {
                    Text("bedtime notifications")
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                }
                .tint(config.accentColor)
                if config.bedtimeNotifications {
                    DatePicker(selection: $config.bedtime, displayedComponents: .hourAndMinute) {
                        Text("bedtime")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
            .animation(.spring(), value: config.alarm)
            .animation(.spring(), value: config.bedtimeNotifications)
        }
    }
}

struct DebugView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var nights: FetchedResults<NightDelegate>
    var body: some View {
        VStack {
            Button("reset welcome screen") {
                UserDefaults.standard.set(true, forKey: "firstLaunch")
            }
//            List {
//                ForEach(nights, id: \.self) { night in
//                    Text("night of: \(night.startDate!.asMonthDayString)")
//                    if night.debugEntries != nil {
//                        ForEach(night.debugEntries!) { debugEntry in
//                            Text(debugEntry.toString)
//                        }
//                    }
//                }
//            }
        }
//        ForEach(nights) { night in
//            List {
//                VStack {
//                    HStack {
//                        Text(night.startDate!.formatted())
//                        Spacer()
//                        Text(night.endDate!.formatted())
//                    }
//                    .padding()
//                    ForEach(night.snoringURLs, id: \.self) { url in
//                        Text(url.absoluteString)
//                    }
//                }
//                .padding()
//            }
//        }
    }
}

struct AlarmSetView: View {
    @ObservedObject var config: Config
    var body: some View {
        VStack {
            Text("set alarm time")
                .font(.headline)
                .foregroundColor(dullWhite)
            HStack {
                Spacer()
                DatePicker("set time", selection: $config.alarmTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .padding()
        .background(config.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .transition(.offset(y: height))
    }
}

struct NightView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NightView()
        }
    }
}
