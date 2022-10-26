//
//  ExpenseLocalDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import CoreData

class ExpenseLocalDataSource {
    
    
    private static var sharedInstance: ExpenseLocalDataSource!

       var context: NSManagedObjectContext?

       private init(context: NSManagedObjectContext?) {
           self.context = context
           ExpenseLocalDataSource.sharedInstance = self
       }

       static func shared(context: NSManagedObjectContext? = nil) -> ExpenseLocalDataSource {
           switch sharedInstance {
           case let i?:
               i.context = context
               return i
           default:
               sharedInstance = ExpenseLocalDataSource(context: context)
               return sharedInstance
           }
       }

    
    func getExpenses() -> [Expense]? {
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest(entityName: "Expense")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "created" , ascending: false)
        fetchRequest.sortDescriptors = [sorter]
        fetchRequest.returnsObjectsAsFaults = false

        var result = [Expense]()

        do {
            result = try context!.fetch(fetchRequest)
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return result
    }
    
    func saveExpense(expense: Expense) {
        
    }
    
    func deleteExpense(expense: Expense) {
        
    }
}
