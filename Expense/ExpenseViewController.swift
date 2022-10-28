//
//  ViewController.swift
//  Expense
//
//  Created by Thiti Sununta on 25/10/2565 BE.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore

class ExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl? = nil

    private var expenses : [Expense] = []
    
    private var expensesRepository: ExpenseRepository? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let remoteDataSouce = ExpenseRemoteDataSource.shared
        let localDataSouce = ExpenseLocalDataSource.shared(context: AppDatabase.shared.managedObjectContext)
        expensesRepository = ExpenseRepository(remoteDataSource: remoteDataSouce, localDataSource: localDataSouce)
        
        let rightBarButton = UIBarButtonItem.init(barButtonSystemItem:
                                                    UIBarButtonItem.SystemItem.add, target:
                                                    self, action: #selector(rightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

        
        setupTableView()
        checkUser()
        //createMockupExpense()
        fetchExpense()
    }
    
    private func setupTableView(){
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        
        expensesRepository?.refreshExpenses()
        fetchExpense()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            // Code to be executed
            self.refreshControl?.endRefreshing()

        }
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
        
        //var expenses : [Expense] = []

        var expense1 = Expense()
        expense1.identifier = "8qSic6xGNvYygRNxoJwj"
        expense1.title = "Pay Bill"
        expense1.amount = 500
        expense1.catagory = "🧾" // Income, Expense
        expense1.created = Date()
        expenses.append(expense1)

        var expense2 = Expense()
        expense2.identifier = "E1D4a3No72JWvERwcU2y"
        expense2.title = "Buy food"
        expense2.amount = 60
        expense2.catagory = "🍜" // Income, Expense
        expense2.created = Date()
        expenses.append(expense2)

        var expense3 = Expense()
        expense3.identifier = "VKVnjYmpWHMGqh0u2HMY"
        expense3.title = "Ice cream"
        expense3.amount = 20
        expense3.catagory = "🍦" // Income, Expense
        expense3.created = Date()
        expenses.append(expense3)
        
        for expense in expenses {

            ExpenseRemoteDataSource.shared.saveExpense(expense: expense) { expense, error in

            }
        }
        
    }
    
    private func fetchExpense() {
            
        expensesRepository?.getExpenses { [unowned self] expenses, error in
            if let _error = error {
                // display error on screen
            }else{
                
                self.expenses = expenses
                self.expenses.sort { expense1, expense2 in
                    return (expense1.created!.compare(expense2.created!) == ComparisonResult.orderedAscending)
                }
                self.expenses.forEach { item in
                    print("Name: \(item.title) Category: \(item.catagory)")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    private func addExpene(expense: DocumentSnapshot){
        
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//
//            if let context = delegate.persistentContainer.viewContext as NSManagedObjectContext? {
//
//                var newExpense = Expense()
//                newExpense.title = expense["title"] as? String
//                newExpense.amount = expense["amount"] as? Double ?? 0
//                newExpense.catagory = expense["catagory"] as? String
//                expenses.append(newExpense)
//            }
//        }
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

