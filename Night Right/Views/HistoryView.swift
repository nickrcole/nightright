//
//  HistoryView.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/21/22.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var config: Config
    @State var nights: FetchedResults<NightDelegate>
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section("your history") {
                    ForEach(nights) { night in
                        NavigationLink {
                            NightDetailsView(config: config, nightDelegate: night)
                        } label: {
                            Text("\(night.startDate!.formatted())")
                                .foregroundColor(dullWhite)
                        }

                    }
                }
            }
        }//.background(Color(UIColor(named: "darkBackground")!))
    }
}
//
//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView(config: Config())
//    }
//}
