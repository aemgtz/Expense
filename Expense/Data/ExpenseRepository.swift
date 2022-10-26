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
    
    func getExpenses(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {

        
    }
    
    func saveExpense(expense: Expense) {
        
    }
    
    func deleteExpense(expense: Expense) {
        
    }
    
}
