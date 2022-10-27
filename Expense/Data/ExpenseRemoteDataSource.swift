//
//  ExpenseRemoteDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class ExpenseRemoteDataSource : NSObject {
    
    static let shared = ExpenseRemoteDataSource()
    
    private override init() {}
    
    private let db = Firestore.firestore()
    private let collectionName = "expenses"
    
    func getExpenses(completion: @escaping(_ expenses: [Expense], _ error: String?) -> Void) {
        
        db.collection(collectionName).getDocuments() { (querySnapshot , error) in
            if let _error = error {
                completion([], _error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    var expenses: [Expense] = []
                    for document in documents {
                        do {
                            try expenses.append(document.data(as:Expense.self))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    completion(expenses, nil)
                }
            }
        }
    }
    
    func saveExpense(expense: Expense, completion: @escaping(_ expense: Expense?, _ error: String?) -> Void) {

        if (expense.identifier != nil){
            
            do {
                try db.collection(collectionName).document(expense.identifier!).setData(from: expense, completion: { error in
                    if let _error = error {
                        completion(nil, _error.localizedDescription)
                    }else {
                        completion(expense, nil)
                    }
                })
            } catch let error {
                completion(nil, error.localizedDescription)
            }
            
            
        }else{
            
            var documentRef: DocumentReference? = nil
            
            do {
                try documentRef = db.collection(collectionName).addDocument(from: expense, completion: { _ in
                    documentRef?.getDocument(as: Expense.self) { result in
                        switch result {
                        case .success(let expense):
                            completion(expense, nil)
                        case .failure(let error):
                            completion(nil, error.localizedDescription)
                        }
                    }
                    
                })
                
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func deleteExpense(expense: Expense, completion: @escaping(_ isSuccess: Bool?, _ error: String?) -> Void) {
        
        db.collection(collectionName).document(expense.identifier!).delete() { error in
            if let _error = error {
                print("Error removing document: \(_error.localizedDescription)")
                completion(nil, _error.localizedDescription)
            } else {
                print("Document successfully removed!")
                completion(true, nil)
            }
        }
    }
}
