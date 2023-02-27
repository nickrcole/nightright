//
//  ChartView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/20/22.
//

import SwiftUI

struct BarChartCell: View {
    @Binding var currentValue: String
    @GestureState var selected = false
    var value: Double
    var barColor: Color
    
    init(currentValue: Binding<String>, value: Double) {
        self._currentValue = currentValue
        self.value = value
        if 0 <= value && value < 0.26 {
            self.barColor = .green.opacity(0.75)
        } else if value < 0.51 {
            self.barColor = .yellow.opacity(0.75)
        } else if value < 0.76 {
            self.barColor = .orange.opacity(0.75)
        } else {
            self.barColor = .red.opacity(0.75)
        }
    }
                         
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(barColor)
            .frame(width: height / 50, height: max(0.01, value)*height / 3.5)
    }
}

struct ChartView: View {
    @ObservedObject var config: Config
    var nights: FetchedResults<NightDelegate>
//    @State var nights: [NightDelegate] = []
    @State private var currentValue: String = "" {
        didSet {
            newBarTouch()
        }
    }
    @State private var touchIndex: CGFloat = -1
    @State private var touchLocationX: CGFloat = -1
    @State private var touchLocationY: CGFloat = -1
    @State private var labelLocX: CGFloat = -1
    @State private var labelLocY: CGFloat = -1
    
//    internal init(config: Config, fetchedNights: FetchedResults<NightDelegate>) {
//        self.config = config
//        self.fetchedNights = fetchedNights
//        let nightsArray = fetchedNights.map { $0 }
//        nights = nightsArray.suffix(7)
//    }
    
    func barIsTouched(index: Int) -> Bool {
        touchIndex > CGFloat(index)/CGFloat(nights.suffix(6).count) && touchIndex < CGFloat(index+1)/CGFloat(nights.suffix(6).count)
    }
    
    func updateCurrentValue()    {
        let index = Int(touchIndex * CGFloat(nights.suffix(6).count))
        guard index < nights.suffix(6).count && index >= 0 else {
            currentValue = ""
            return
        }
        if currentValue != "\(nights[index + max(0, nights.count-6)].score)" {
            withAnimation(.spring()) {
                currentValue = "\(nights[index + max(0, nights.count-6)].score)"
            }
        }
    }
    
    func resetValues() {
        touchLocationX = -1
        touchLocationY = -1
        touchIndex = -1
        currentValue  =  ""
    }
    
    func labelOffset(in width: CGFloat) -> CGFloat {
        let currentIndex = Int(touchIndex * CGFloat(nights.suffix(6).count))
        guard currentIndex < nights.suffix(6).count && currentIndex >= 0 else {
            return 0
        }
        let cellWidth = width / CGFloat(nights.suffix(6).count)
        let actualWidth = width -    cellWidth
        let position = cellWidth * CGFloat(currentIndex) - actualWidth/2
        return position
    }
    
    func newBarTouch() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        withAnimation(.spring()) {
            self.labelLocX = self.touchLocationX
            self.labelLocY = self.touchLocationY
        }
    }
    
    func normalizeValue(index: Int) -> Double {
        var max: Double = 0.0
        var min: Double = 1.0
        for night in nights {
            if Double(night.score) > max {
                max = Double(night.score)
            }
            if Double(night.score) < min {
                min = Double(night.score)
            }
        }
        if min == max {
            return 1.0
        }
        return (Double(nights[index].score) - min) / (max - min)
    }
    
    var body: some View {
//        VStack(alignment: .leading) {
//            HStack(alignment: .center) {
//                Text("your progress")
//                    .font(.headline)
//                    .foregroundColor(dullWhite)
//                    .padding(.vertical)
//                Spacer()
//                NavigationLink(destination: SettingsView(config: config)) {
//                    Image(systemName: "gear")
//                        .foregroundColor(config.accentColor)
//                }
//            }
        var frameWidth: Double = (Double(width)/7) * Double(nights.suffix(6).count)
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            ForEach(max(0, nights.count-6)..<max(0, nights.count-6) + min(6, nights.count)) { i in
                                VStack {
                                    NavigationLink(value: nights[i]) {
                                        Text(nights[i].startDate!.weekdaySymbol)
                                            .font(.footnote)
                                            .foregroundColor(dullWhite)
                                    }
                                    .frame(width: width/12)
                                    BarChartCell(currentValue: $currentValue, value: normalizeValue(index: i))
                                        .padding()
                                    NavigationLink(value: nights[i]) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(dullWhite)
                                    }
                                }
                                .scaleEffect(barIsTouched(index: i - max(0, nights.count-6)) ? 1.1 : 1, anchor: .bottom)
                                .brightness(barIsTouched(index: i - max(0, nights.count-6)) ? 0.2 : 0.0)
                            }
                            .onAppear {
                                print(nights.suffix(6))
                                print(nights.suffix(6).count)
                            }
                            Spacer()
                        }
                    }
//                    .position(x: width / 15, y: geometry.frame(in: .local).height / 1.25)
                    if currentValue != "" {
                        VStack {
                            Text(currentValue)
                                .padding()
                                .foregroundColor(dullWhite)
                                .brightness(0.5)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                        .position(x: labelLocX, y: labelLocY - height/10)
                    }
                }
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged({ position in
                        withAnimation(.spring()) {
                            self.touchIndex = position.location.x/geometry.frame(in: .local).width
                            self.touchLocationX = position.location.x
                            self.touchLocationY = position.location.y
                            self.labelLocX = position.location.x
                            self.labelLocY = position.location.y
                            updateCurrentValue()
                        }
                    })
                    .onEnded({ position in
                        DispatchQueue.main.async {
                            withAnimation(.spring()) {
                                resetValues()
                            }
                        }
                    })
                )
            }
            .frame(width: frameWidth, height: height / 2.7)
//            .position(x: width / 2, y: height / 1.5)
            .padding()
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .border(.red)
//            NavigationLink(value: 0) {
//                HStack {
//                    Text("see all")
//                    Image(systemName: "chevron.right")
//                }
//                .foregroundColor(dullWhite)
//            }
//        }
//        .padding()
    }
}

//var data: [SleepData] = [
//    .init(startTime: createDate(date: "2022/12/20 11:00"), endTime: createDate(date: "2022/13/20 8:00"), score: 100),
//    .init(startTime: createDate(date: "2022/12/21 11:00"), endTime: createDate(date: "2022/13/22 8:00"), score: 56),
//    .init(startTime: createDate(date: "2022/12/22 11:00"), endTime: createDate(date: "2022/13/23 8:00"), score: 55),
//    .init(startTime: createDate(date: "2022/12/23 11:00"), endTime: createDate(date: "2022/13/24 8:00"), score: 48),
//    .init(startTime: createDate(date: "2022/12/24 11:00"), endTime: createDate(date: "2022/13/25 8:00"), score: 35),
//    .init(startTime: createDate(date: "2022/12/25 11:00"), endTime: createDate(date: "2022/13/26 8:00"), score: 23),
//    .init(startTime: createDate(date: "2022/12/26 11:00"), endTime: createDate(date: "2022/13/27 8:00"), score: 22)
//]

//struct BarChart_Previews: PreviewProvider {
//     static var previews: some View {
//         ChartView(config: Config(), sleepData: data)
//     }
// }
