//
//  AddEditExpenseViewController.swift
//  Expense
//
//  Created by Thiti Sununta on 25/10/2565 BE.
//

import UIKit

class AddEditExpenseViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        amountTextField.text = ""
        amountTextField.placeholder = "$199.0"
        
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
        dismiss(animated: true)
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
