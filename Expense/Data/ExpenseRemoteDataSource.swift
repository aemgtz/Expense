//
//  ExpenseRemoteDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import Firebase
import FirebaseFirestore

class ExpenseRemoteDataSource: NSObject {

    private let db = Firestore.firestore()
    private let collectionName = "expenses"

    func getExpenses(completion: @escaping(_ expenses: [DocumentSnapshot], _ error: String?) -> Void) {
        
        db.collection(collectionName).getDocuments() { (querySnapshot , err) in
            if let err = err {
                completion([], err.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    completion(documents, nil)
                }
            }
        }
    }
    
    func saveExpense(expense: Expense) {
        
    }
    
    func deleteExpense(expense: Expense) {
        
    }
}
