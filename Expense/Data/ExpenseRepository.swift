//
//  ExpenseRepository.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import CoreData

class ExpenseRepository {
    
    private let remoteDataSource: ExpenseRemoteDataSource
    private let localDataSource: ExpenseLocalDataSource
    
    public init(remoteDataSource: ExpenseRemoteDataSource,
                localDataSource: ExpenseLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    var cacheIsDirty = false
    var cachedExpenses:  [String: Expense] = [:]

    
    func getExpenses(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {

        if (!cachedExpenses.isEmpty && !cacheIsDirty) {
            completion(Array(cachedExpenses.values), nil)
            return
        }
        
        if (cacheIsDirty) {
            
            getExpesesFromRemoteDataSource(completion: completion)
            
        }else{
            
            localDataSource.getExpenses { [unowned self] expenses, error in
                if let _error = error {
                    completion([], _error)
                }else{
                    refreshCache(expenses: expenses)
                    completion(Array(cachedExpenses.values), nil)
                }
            }
        }
    }
    
    private func getExpesesFromRemoteDataSource(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {
        remoteDataSource.getExpenses { [unowned self] expenses, error in
            self.refreshCache(expenses: expenses)
            self.refreshLocalDataSource(expenses: expenses)
            completion(Array(self.cachedExpenses.values), nil)
        }
    }
    
    
    func saveExpense(expense: Expense) {
        
    }
    
    func deleteExpense(expense: Expense) {
        
    }
    
    private func refreshCache(expenses: [Expense]) {
        cachedExpenses.removeAll()
        expenses.forEach { expense in
            _ = cacheAndPerform(expense: expense)
        }
        cacheIsDirty = false
    }
    
    private func refreshLocalDataSource(expenses: [Expense]) {
        localDataSource.deleteAll()
        for expense in expenses {
            localDataSource.saveExpense(expense: expense)
        }
    }

    private func cacheAndPerform(expense: Expense) -> Expense {
        
        let cached = Expense(identifier: expense.identifier,
                             title: expense.title,
                             detail: expense.detail,
                             amount: expense.amount,
                             type: expense.type,
                             catagory: expense.catagory,
                             created: expense.created)
        
        if let identifier = cached.identifier {
            cachedExpenses[identifier] = cached
        }
        return cached
    }

}
