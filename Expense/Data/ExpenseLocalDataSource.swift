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
    
    var context: NSManagedObjectContext!
    
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
    
    
    func getExpenses(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {
        
        let fetchRequest: NSFetchRequest<Expenses> = NSFetchRequest(entityName: "Expenses")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created" , ascending: true)]
//        let asyncFetchRequest = NSAsynchronousFetchRequest<Expenses>(fetchRequest: fetchRequest) { fetchRequestResults in
//
//            if let finalResult: [Expenses] = fetchRequestResults.finalResult {
//                var completionResult: [Expense] = []
//                for result in finalResult {
//                    completionResult.append(Expense.from(expenses: result))
//                }
//                completion(completionResult, nil)
//            }
//        }
        
        do {
            let results = try self.context.fetch(fetchRequest)
            if (!results.isEmpty) {
                var completionResult: [Expense] = []
                for result in results {
                    completionResult.append(Expense.from(expenses: result))
                }
                completion(completionResult, nil)
            }else{
                completion([], nil)
            }
        } catch let error {
            completion([], error.localizedDescription)
        }
    }
    
    
    func saveExpense(expense: Expense) {
        
        if (expense.identifier != nil){
            
            context.perform { [unowned self] in
                
                let entity = NSEntityDescription.entity(forEntityName: "Expenses", in: self.context)!
                let expenseObject = NSManagedObject(entity: entity, insertInto: self.context) as? Expenses
                
                expenseObject?.identifier = expense.identifier
                expenseObject?.title = expense.title
                expenseObject?.detail = expense.detail
                expenseObject?.catagory = expense.catagory
                expenseObject?.type = expense.type
                expenseObject?.amount = expense.amount
                expenseObject?.created = expense.created

                do {
                    try self.context.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
        }else {
            
            let fetchRequest: NSFetchRequest<Expenses> = NSFetchRequest(entityName: "Expenses")
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", expense.identifier!)
            do {
                let results = try context.fetch(fetchRequest)
                if (results.count != 0){
                    if let existedOjbect = results.first {
                       
                        existedOjbect.title = expense.title
                        existedOjbect.detail = expense.detail
                        existedOjbect.amount = expense.amount
                        existedOjbect.catagory = expense.catagory
                        existedOjbect.type = expense.type
                        existedOjbect.created = expense.created
                        
                        do {
                            try self.context.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
                
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveExpenses(expenses: [Expense] , completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {
        
        context.perform { [unowned self] in
            
            var completionResult: [Expense] = []
            
            for expense in expenses {
                
                let entity = NSEntityDescription.entity(forEntityName: "Expenses", in: context)!
                let expenseObject = NSManagedObject(entity: entity, insertInto: context) as? Expenses

                expenseObject?.identifier = expense.identifier
                expenseObject?.title = expense.title
                expenseObject?.detail = expense.detail
                expenseObject?.catagory = expense.catagory
                expenseObject?.type = expense.type
                expenseObject?.amount = expense.amount
                expenseObject?.created = expense.created
                
                completionResult.append(Expense.from(expenses: expenseObject!))
            }
            
            do {
                try self.context.save()
                completion(completionResult, nil)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                completion([], error.localizedDescription)
            }
        }
    }
    
    func deleteExpense(expense: Expense) {
        
        let fetchRequest: NSFetchRequest<Expenses> = NSFetchRequest(entityName: "Expenses")
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", expense.identifier!)
        do {
            let results = try context.fetch(fetchRequest)
            if (results.count != 0){
                if let expenseObject = results.first {
                    context.delete(expenseObject)
                }
            }
            
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expenses")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
