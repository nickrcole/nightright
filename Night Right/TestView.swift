//
//  TestView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/29/22.
//

import SwiftUI

struct TestView: View {
    @State var texts: [String] = Array(0..<20).map { num in "    \(String(num))    " }
    @State var move: Bool = false
    @State var offset: CGSize = .zero
    var body: some View {
        VStack {
            Button("move") {
                move.toggle()
            }
            HStack {
                VStack(alignment: .leading) {
                    ForEach(0..<texts.count, id: \.self) { i in
                        Group {
                            Text(texts[i])
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue)
                                .clipShape(Capsule())
                        }
                        .offset(y: offset.height)
                        .animation(.spring().delay(1 / (Double(i))))
                    }
                }
                Spacer()
            }
            .padding()
        }
        .contentShape(Rectangle())
        .gesture(DragGesture()
            .onChanged { gesture in
                offset.height = gesture.translation.height
            })
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
