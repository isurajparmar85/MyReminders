//
//  AddViewController.swift
//  MyReminders
//
//  Created by isurajparmar85 on 20/05/2024.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String,String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        
        
    }
    
    @IBAction func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
            
        }
    }

}
