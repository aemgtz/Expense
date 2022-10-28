//
//  AddEditExpenseViewController.swift
//  Expense
//
//  Created by Thiti Sununta on 25/10/2565 BE.
//

import UIKit

class AddEditExpenseViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    

    private var expensesRepository: ExpenseRepository? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let remoteDataSouce = ExpenseRemoteDataSource.shared
        let localDataSouce = ExpenseLocalDataSource.shared(context: AppDatabase.shared.managedObjectContext)
        expensesRepository = ExpenseRepository(remoteDataSource: remoteDataSouce, localDataSource: localDataSouce)
        
        amountTextField.text = ""
        amountTextField.placeholder = "$199.0"
        amountTextField.keyboardType = .numberPad
        
        let rightBarButton = UIBarButtonItem.init(barButtonSystemItem:
                                                    UIBarButtonItem.SystemItem.save, target:
                                                    self, action: #selector(rightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButton

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountTextField.becomeFirstResponder()
    }
    
    @objc func rightBarButtonItemTapped(_ sender: AnyObject?) {

    }
    

    @IBAction func saveButtonTouched(_ sender: Any) {
        
        if let amountText = amountTextField.text, let amount = Double(amountText),  let title = titleTextField.text{
            
            var expense = Expense()
            expense.title = title
            expense.amount = amount
            expense.catagory = "🧾"
            expense.created = Date()
            
            expensesRepository?.saveExpense(expense: expense, completion: { expense, error in
                self.dismiss(animated: true)
            })
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
