//
//  ExpenseLocalDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import CoreData

class ExpenseLocalDataSource {
    
    static let shared = ExpenseLocalDataSource()
    
    private static var context : NSManagedObjectContext?
    
    class func setup(_ context: NSManagedObjectContext){
        ExpenseLocalDataSource.context = context
    }
    
    private init() {
        guard let context = ExpenseLocalDataSource.context else {
            fatalError("Error - you must call setup before accessing MySingleton.shared")
        }
    }
    
    
    func getExpenses(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {
        
        
    }
    
    func saveExpense(expense: Expense) {
        
    }
    
    func deleteExpense(expense: Expense) {
        
    }
}
