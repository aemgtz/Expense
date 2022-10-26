//
//  Expenses+CoreDataProperties.swift
//  Expense
//
//  Created by Thiti Sununta on 25/10/2565 BE.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var title: String?
    @NSManaged public var detail: String?
    @NSManaged public var amount: Double
    @NSManaged public var type: String?
    @NSManaged public var catagory: String?
    @NSManaged public var created: Date?

}

extension Expenses : Identifiable {

}
