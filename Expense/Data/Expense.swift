//
//  Expense.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import Foundation
import CoreData

public struct Expense: Codable {
    
    var identifier: String?
    var title: String?
    var detail: String?
    var amount: Double = 0
    var type: String?
    var catagory: String?
    var created: Date? = Date()
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case detail
        case amount
        case type
        case catagory
        case created
    }
    
    static func from(expenses: Expenses) -> Expense{
        return Expense(identifier: expenses.identifier,
                       title: expenses.title,
                       detail: expenses.detail,
                       amount: expenses.amount,
                       type: expenses.type,
                       catagory: expenses.catagory,
                       created: expenses.created)
    }
    
}
