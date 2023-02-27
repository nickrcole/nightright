//
//  ClockView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/21/22.
//

import SwiftUI
import Combine

struct ClockView: View {
    @ObservedObject var config: Config
    var startTime: Date
    var endTime: Date
    var startMinutes: Int
    var endMinutes: Int
    var fillTicks: Int = 0
    
    init(config: Config, startTime: Date, endTime: Date) {
        self.config = config
        self.startTime = startTime
        self.endTime = endTime
        self.startMinutes = startTime.timeInMinutes
        self.endMinutes = endTime.timeInMinutes
        self.fillTicks = diffMinutes(start: startTime, end: endTime) / 12
    }
    
    func tick(at tick: Int, fill: Bool) -> some View {
        return VStack {
            VStack {
                if fill {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(config.accentColor)
                        .opacity(tick % 5 == 0 ? 1 : 0.75)
                        .frame(width: 10, height: tick % 5 == 0 ? width/12 : width/14)
                    Spacer()
                } else {
                    Rectangle()
                        .fill(dullWhite)
                        .opacity(tick % 5 == 0 ? 1 : 0.4)
                        .frame(width: 4, height: tick % 5 == 0 ? width/15 : width/20)
                    Spacer()
                }
            }.rotationEffect(Angle.degrees(Double(tick)/(40) * 360))
        }
    }
    
    var body: some View {
        return ZStack {
            ForEach(0..<40) { tick in
                self.tick(at: tick, fill: (fillTicks >= tick ? true : false))
            }
            VStack {
                Text("hours asleep")
                    .font(.title2)
                    .scaleEffect(1.8)
                    .fontWeight(.bold)
                    .padding(width/100)
                Text("\(fillTicks / 5)")
                    .font(.title)
                    .scaleEffect(2.15)
                    .offset(y: height/40)
            }
            .shadow(radius: 20)
            .foregroundColor(dullWhite)
            
        }.frame(width: width/1.14, height: height/2.5, alignment: .center)
    }
}

struct PreviewView: View {
    var startTime: Date =  createDate(date: "2022/12/20 23:00")
    var endTime: Date =  createDate(date: "2022/12/21 1:30")
    var body: some View {
        ClockView(config: Config(), startTime: startTime, endTime: endTime)
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
}
