//
//  ExpenseViewModel.swift
//  Expense
//
//  Created by Thiti Sununta on 28/10/2565 BE.
//

import Foundation

public class ExpenseViewModel {
    
    private var expenseRepository: ExpenseRepository?
    
    init(expenseRepository: ExpenseRepository) {
        self.expenseRepository = expenseRepository
    }
    
    let expeses: Box<[Expense]> = Box([])
    let dataLoading: Box<Bool> = Box(false)

    func fetchExpeses(forceUpdate: Bool){
        
        if (forceUpdate){
            expenseRepository?.refreshExpenses()
        }
        
        dataLoading.value = true
        
        expenseRepository?.getExpenses(completion: { [weak self] expenses, error in
            
            self?.dataLoading.value = false
            
            if let _error = error {
                
            }else{
                
                self?.expeses.value = expenses.sorted(by: { expense1, expense2 in
                    return (expense1.created!.compare(expense2.created!) == ComparisonResult.orderedAscending)
                })
            }
        })
    }
}
