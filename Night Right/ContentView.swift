import SwiftUI

struct TimerView: View {

    // MARK: - Properties
    @State private var secondsElapsed: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // MARK: - View
    var body: some View {
        VStack {
            Text("Time Elapsed: \(secondsElapsed)")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            Button(action: {
                self.secondsElapsed = 0
            }) {
                Text("Reset")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onReceive(timer) { _ in
            self.secondsElapsed += 1
        }
    }

}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimerView()
        }
    }
}
