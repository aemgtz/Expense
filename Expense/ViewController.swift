//
//  ViewController.swift
//  Expense
//
//  Created by Thiti Sununta on 25/10/2565 BE.
//

import UIKit
import CoreData
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var expenses : [Expenses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createMockupExpense()
        
        let rightBarButton = UIBarButtonItem.init(barButtonSystemItem:
                                                    UIBarButtonItem.SystemItem.add, target:
                                                    self, action: #selector(rightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        checkUser()
    }
    
    private func checkUser(){
        
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "ExpenseToLogin", sender: nil)
            return
        }
    }
    
    @objc func rightBarButtonItemTapped(_ sender: AnyObject?) {
        performSegue(withIdentifier: "ExpenseToAddEdit", sender: nil)
    }
    
    
    private func createMockupExpense(){
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            
            if let context = delegate.persistentContainer.viewContext as NSManagedObjectContext? {
                
                let expense1 = Expenses(context: context)
                expense1.title = "Pay Bill"
                expense1.amount = 500
                expense1.catagory = "🧾" // Income, Expense
                expense1.created = Date()
                expenses.append(expense1)

                let expense2 = Expenses(context: context)
                expense2.title = "Buy food"
                expense2.amount = 60
                expense2.catagory = "🍜" // Income, Expense
                expense2.created = Date()
                expenses.append(expense2)

                let expense3 = Expenses(context: context)
                expense3.title = "Ice cream"
                expense3.amount = 20
                expense3.catagory = "🍦" // Income, Expense
                expense3.created = Date()
                expenses.append(expense3)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell {
            
            let expense = expenses[indexPath.row]
            cell.categoryLabel.text = expense.catagory
            cell.nameLabel.text = expense.title
            cell.amountLabel.text = "$\(expense.amount)"
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

