//
//  ExpenseRemoteDataSource.swift
//  Expense
//
//  Created by Thiti Sununta on 26/10/2565 BE.
//

import UIKit
import Firebase
import FirebaseFirestore

class ExpenseRemoteDataSource {
    
    static let shared = ExpenseRemoteDataSource()

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
    
    func saveExpense(expense: Expense, completion: @escaping(_ expense: DocumentSnapshot?, _ error: String?) -> Void) {
        
        if (expense.identifier != nil){
            // update
            let data : [String : Any] = ["title": expense.title ?? "",
                                         "amount": expense.amount ,
                                         "catagory": expense.catagory ?? "",
                                         "created":expense.created ?? Date()]
            
            var ref: DocumentReference? = nil
            ref = db.collection(collectionName).document(expense.identifier!)
            ref?.updateData(data) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    ref?.getDocument { (document, error) in
                        if let document = document, document.exists {
                            completion(document, nil)
                        } else {
                            print("Document does not exist")
                            completion(nil, error?.localizedDescription)
                        }
                    }
                }
            }
            
        }else{
            // insert
            let data : [String : Any] = ["title": expense.title ?? "",
                                         "amount": expense.amount ,
                                         "catagory": expense.catagory ?? "",
                                         "created":expense.created ?? Date()]
            
            var ref: DocumentReference? = nil
            ref = db.collection("expenses").addDocument(data: data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    
                    ref?.getDocument { (document, error) in
                        if let document = document, document.exists {
                            completion(document, nil)
                        } else {
                            print("Document does not exist")
                            completion(nil, error?.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func deleteExpense(expense: Expense, completion: @escaping(_ isSuccess: Bool?, _ error: String?) -> Void) {
        
        db.collection(collectionName).document(expense.identifier!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        completion(nil, err.localizedDescription)
                    } else {
                        print("Document successfully removed!")
                        completion(true, nil)
                    }
                }
    }
}
