////
////  DataController.swift
////  Night Right
////
////  Created by Nicholas Cole on 1/6/23.
////
//
//import Foundation
//import CoreData
//
//class DataController: ObservableObject {
//    let container = NSPersistentContainer(name: "Night_Right")
//
//    internal init() {
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                print("Core Data failed to load: \(error.localizedDescription)")
//            }
//        }
//    }
//}
