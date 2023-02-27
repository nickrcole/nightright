//
//  SettingsView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/30/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var config: Config
    let documentURL = Bundle.main.url(forResource: "privacypolicy", withExtension: "pdf")!
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    Group {
                        //Image("mindmap")
                        iconImage
                        Text("night right")
                            .foregroundColor(.gray)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(10)
                        Text("© 2023")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    List {
                        ColorPicker(selection: $config.accentColor, supportsOpacity: false) {
                            Text("app color")
                                .foregroundColor(.gray)
                        }
                        Link(destination: URL(string: "mailto:nickrcole2@gmail.com")!) {
                            HStack {
                                Text("contact")
                                Spacer()
                                // Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.gray)
                        }
                        NavigationLink(destination: sleepSettings) {
                            Text("sleep settings")
                                .foregroundColor(.gray)
                        }
                        NavigationLink(destination: privacyPolicy) {
                            Text("privacy policy")
                                .foregroundColor(.gray)
                        }
                        NavigationLink(destination: credits) {
                            Text("credits")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: height/3.25)
                    Group {
//                        Text(config.accentColor.description)
                        Text("about")
                            .foregroundColor(.gray)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("founded in 2023, night right is a free snore reduction app designed to train your body to reduce snoring. we utilize artificial intelligence to analyze your sleep and gently wake you up when we detect snoring.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Text("night right was developed by an independent software engineering student. feel free to reach out with comments and suggestions in the \"contact\" section.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
//                    NavigationLink(destination: donate) {
//                        HStack {
//                            Text("donate")
//                            Image(systemName: "chevron.right")
//                        }
//                    }
                }
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height)
            }
        }
    }
    
    var iconImage: some View {
        Image("moon.cloud")
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .padding(.bottom)
            .scaleEffect(1)
            .frame(width: width/6, height: height/15)
    }
    
    var privacyPolicy: some View {
        PDFKitRepresentedView(documentURL)
            .frame(width: width)
    }
    
    @State var bedtime: Date = createDate(date: "2022/1/12 23:00")
    @State var alarmTime: Date = createDate(date: "2022/1/12 8:00")
    var sleepSettings: some View {
        List {
            Section("sleep settings") {
                Toggle(isOn: $config.snooze) {
                    Text("allow snooze")
                        .foregroundColor(.gray)
                }
                NavigationLink(destination: snoreReductionInstructions) {
                    Text("snore reduction")
                        .foregroundColor(.gray)
                }
            }
            .tint(config.accentColor)
            Section("your sleep cycle") {
                Toggle(isOn: $config.bedtimeNotifications) {
                    Text("bedtime notifications")
                        .foregroundColor(.gray)
                }
                if config.bedtimeNotifications {
                    DatePicker(selection: $bedtime, displayedComponents: .hourAndMinute) {
                        Text("bedtime")
                            .foregroundColor(.gray)
                    }
                }
                Toggle(isOn: $config.alarm) {
                    Text("alarm")
                        .foregroundColor(.gray)
                }
                if config.alarm {
                    DatePicker(selection: $alarmTime, displayedComponents: .hourAndMinute) {
                        Text("alarm set")
                            .foregroundColor(.gray)
                    }
                }
            }
            .tint(config.accentColor)
        }
    }
    
    var snoreReductionInstructions: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
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
                    Toggle(isOn: $config.snoreReduction) {
                        Text("snore reduction")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .tint(config.accentColor)
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
                }
            }
        }
    }
    
    var credits: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            Text("nicholas cole")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("night right developer")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        Image("profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(1.25)
                            .frame(width: width/6)
                            .clipShape(Circle())
                    }
                    .foregroundColor(.gray)
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                    HStack {
                        VStack {
                            Text("jaime yaukey")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("app art")
                                .font(.subheadline)
                        }
                        .foregroundColor(.gray)
                        .padding(.trailing)
                        Link(destination: URL(string: "https://www.facebook.com/profile.php?id=100088246351477&mibextid=LQQJ4d")!) {
                            HStack {
                                Image("facebook")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width/15)
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                    HStack {
                        VStack {
                            Text("icons8")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("app icons")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        Link(destination: URL(string: "https://icons8.com")!) {
                            HStack {
                                Image(systemName: "link")
                                Text("visit icons8")
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom)
                    Spacer()
                }
                .padding()
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height)
            }
        }
    }
    
    var donate: some View {
        VStack {
            HStack {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(1.25)
                    .clipShape(Circle())
                    .frame(width: width/4)
                VStack(alignment: .leading) {
                    Text("nicholas cole")
                        .foregroundColor(.gray)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("night right developer")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            Text("i'm a student studying software engineering at the Pennsylvania State University. if night right has brought value to you, please consider donating at the link below")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
            Link(destination: URL(string: "https://account.venmo.com/u/nick_c_")!) {
                Text("venmo me")
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(config: Config()).sleepSettings
    }
}
