//
//  WelcomeView.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/12/23.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var config: Config
    let nightSky = Color(.sRGB, red: 0.041, green: 0.063, blue: 0.237)
    
    func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if error != nil {
                config.notificationsAllowed = false
                return
            }
            
            config.notificationsAllowed = true
        }
    }
    
    enum WelcomeScreenView {
        case landing, instructions
    }
    @State var welcomeScreenView: WelcomeScreenView = .landing
    var body: some View {
//        ZStack {
//            Image("backgroundimage")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .scaleEffect(1.25)
//                .opacity(0.5)
////                .blur(radius: 3)
        VStack {
            if welcomeScreenView == .landing {
                VStack {
                    GeometryReader { geo in
                        ScrollView(showsIndicators: false) {
                            VStack {
                                Spacer()
                                VStack {
                                    Image("moon.cloud.stars")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: width/2)
                                    Text("welcome to night right")
                                        .font(.title)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                    setup
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            welcomeScreenView = .instructions
                                            //UserDefaults.standard.set(false, forKey: "firstLaunch")
                                        }
                                    }, label: {
                                        Text("next")
                                            .font(.body)
                                            .fontWeight(.light)
                                    })
                                    .buttonStyle(.borderedProminent)
                                    .padding()
                                }
                                .padding()
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                Spacer()
                            }
                            .padding()
                            .animation(.spring(), value: config.bedtimeNotifications)
                            .animation(.spring(), value: config.alarm)
                            .frame(width: geo.size.width)
                            .frame(minHeight: geo.size.height, maxHeight: .infinity)
                        }
                    }
                }
                .transition(.offset(x: -width))
            } else {
                VStack {
                    instructions
                        .transition(.opacity)
                }
            }
        }
        .background(
            Image("nightsky")
                .overlay(.ultraThinMaterial)
        )
    }
    
    var instructions: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                    snoreReductionInstructions
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                .padding()
                .animation(.spring(), value: config.bedtimeNotifications)
                .animation(.spring(), value: config.alarm)
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height, maxHeight: .infinity)
            }
        }
    }
    
    var snoreReductionInstructions: some View {
        VStack {
            Image(systemName: "waveform.path")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width/5)
                .foregroundColor(config.accentColor)
            Text("night right snore reduction")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.bottom)
            Text("how it works")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: "moon.zzz.fill")
                        .padding(.trailing)
                    Text("tap the moon when you go to sleep to activate sleep tracking")
                }
                Text("\n")
                HStack(alignment: .center) {
                    Image(systemName: "table.furniture")
                        .padding(.trailing)
                    Text("keep your phone close by, like on a nightstand next to your bed")
                }
                Text("\n")
                HStack(alignment: .center) {
                    Image(systemName: "lock.iphone")
                        .padding(.trailing)
                    Text("lock your phone")
                }
                Text("\n")
                HStack(alignment: .center) {
                    Image("mindmap")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .scaleEffect(1.5)
                        .frame(width: width/25)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                    Text("night right will gently wake you when it detects snoring")
                }
                Text("\n")
                HStack(alignment: .center) {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .padding(.trailing)
                    Text("no need to interact with your phone. the snoring alarm will automatically stop")
                }
            }
            .padding()
            .foregroundColor(.gray)
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        welcomeScreenView = .landing
                    }
                }, label: {
                    Text("back")
                        .font(.body)
                        .fontWeight(.light)
                })
                Button(action: {
                    withAnimation(.spring()) {
                        UserDefaults.standard.set(false, forKey: "firstLaunch")
                    }
                }, label: {
                    Text("next")
                        .font(.body)
                        .fontWeight(.light)
                })
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
    
    @State var bedtime: Date = createDate(date: "2022/1/12 23:00")
    @State var alarmTime: Date = createDate(date: "2022/1/12 8:00")
    var setup: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $config.snoreReduction) {
                Text("snore reduction")
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            HStack {
                Image(systemName: "info.circle")
                Text("night right will gently wake you up when it detects snoring")
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: true)
            }
            .foregroundColor(secondary)
            .padding(.bottom)
            Toggle(isOn: $config.bedtimeNotifications) {
                Text("bedtime notifications")
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            if config.bedtimeNotifications {
                DatePicker(selection: $bedtime, displayedComponents: .hourAndMinute) {
                    Text("bedtime")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .onAppear {
                    configureNotifications()
                }
            }
            Toggle(isOn: $config.alarm) {
                Text("alarm")
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            if config.alarm {
                VStack {
                    DatePicker(selection: $alarmTime, displayedComponents: .hourAndMinute) {
                        Text("alarm set")
                            .foregroundColor(.gray)
                    }
                    Toggle(isOn: $config.snooze) {
                        Text("allow snooze")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    configureNotifications()
                }
            }
        }
        .tint(config.accentColor)
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(config: Config())
    }
}
