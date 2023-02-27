//
//  NightDelegate+CoreDataProperties.swift
//  Night Right
//
//  Created by Nicholas Cole on 1/14/23.
//
//

import Foundation
import CoreData


extension NightDelegate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NightDelegate> {
        return NSFetchRequest<NightDelegate>(entityName: "NightDelegate")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var score: Int64
    @NSManaged public var snoreReduction: Bool
    @NSManaged public var snoringURLs: [URL]
    @NSManaged public var startDate: Date?

}

extension NightDelegate : Identifiable {

}
