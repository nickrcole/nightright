//
//  ViewEffects.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/23/22.
//
import SwiftUI
import PDFKit

struct FlippableView<Primary: View, Secondary: View>: View {
    @State var frame: CGSize = .zero
    @State private var flipped = false
    @Binding private var flipView: Bool
    var leftSide: Bool
    
    let primary: Primary
    let secondary: Secondary
    
    init(flipView: Binding<Bool>, @ViewBuilder primary: () -> Primary, @ViewBuilder secondary: () -> Secondary, leftSide: Bool) {
        self.primary = primary()
        self.secondary = secondary()
        self._flipView = flipView
        self.leftSide = leftSide
    }
    
    var body: some View {
        return VStack {
              Spacer()

              ZStack() {
                  primary.opacity(flipped ? 1.0 : 0.0)
//                      .gesture(TapGesture()
//                          .onEnded { value in
//                              withAnimation(.spring()) {
//                                  flipView.toggle()
//                              }
//                          })
                  secondary.opacity(flipped ? 0.0 : 1.0)
                      .clipShape(RoundedRectangle(cornerRadius: 20))
                      .shadow(radius: 25)
//                      .gesture(TapGesture()
//                          .onEnded { value in
//                              withAnimation(.spring()) {
//                                  flipView.toggle()
//                              }
//                          })
                  }
              .modifier(FlipEffect(flipped: $flipped, angle: flipView ? leftSide ? 180 : 0 : leftSide ? 0 : 180, axis: (x: 0, y: 1)))
              Spacer()
        }
    }
}

struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}

struct ChildSizeReader<Content: View>: View {
    @Binding var size: CGSize
    let content: () -> Content
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
