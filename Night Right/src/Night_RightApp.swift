//
//  Night_RightApp.swift
//  Night Right
//
//  Created by Nicholas Cole on 12/20/22.
//

import SwiftUI
import AVFAudio

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
let backgroundColor: Color = Color(UIColor(named: "darkBackground")!).opacity(0.8)
let solidBackground: Color = Color(UIColor(named: "darkBackground")!)
let primary: Color = Color.white.opacity(0.6)
let secondary: Color = Color.white.opacity(0.4)
let dullWhite: Color = secondary
let defaultColor: Color = Color(.sRGB, red: 0.477, green: 0.505, blue: 1.0)
let orangeColor: Color = Color(.sRGB, red: 0.94964, green: 0.66292, blue: 0.51796)

enum AppLaunchErrors: Error {
    case failedToConfigureAudioSession
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

@main
struct Night_RightApp: App {
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @StateObject private var persistenceController = PersistenceController.shared
    @StateObject var config: Config = Config()
    
    func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient)
            try session.setActive(true)
        } catch {
            print("error starting or configuring audio session")
        }
    }

    var body: some Scene {
        WindowGroup {
            VStack {
                if firstLaunch {
                    WelcomeView(config: config)
                        .preferredColorScheme(.dark)
                } else {
                    NightView(config: config)
                        .transition(.opacity)
                        .preferredColorScheme(.dark)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
            .onAppear {
                configureAudioSession()
            }
            .animation(.spring(), value: firstLaunch)
        }
//        .onChange(of: ScenePhase) { scenePhase in
//            let fetchRequest = NSFetchRequest(entityName: "Configuration")
//            fetchRequest.includesPropertyValues = false
//
//            do {
//                let configuration = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Configuration]
//
//                for item in items {
//                    managedObjectContext.deleteObject(item)
//                }
//
//                // Save Changes
//                try managedObjectContext.save()
//
//            } catch {
//                // Error Handling
//                // ...
//            }
//        }
    }
}
