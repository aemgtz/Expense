//
//  ExpenseDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import Foundation

enum Response<T> {
    case succeed(T)
    case failed(message: String)
}

protocol ExpenseDataSource : NSObject {
    
    func getExpenses()
    func saveExpense()
    func deleteExpense()
}
