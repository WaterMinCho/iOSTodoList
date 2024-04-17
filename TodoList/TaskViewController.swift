//
//  TaskViewController.swift
//  TodoList
//
//  Created by 조민수 on 4/3/24.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel! // 레이블 변수 추가.
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?

    var task: String?

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        label.text = task
    }
    
    func trextFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @objc func saveTask(){
            guard let text = field.text, !text.isEmpty else {
                return
            }
            
            guard let count = UserDefaults().value(forKey: "count") as? Int else {
                return
            }
            
            let newCount = count + 1
            
            UserDefaults().set(newCount, forKey: "count")
            UserDefaults().set(text, forKey: "task_\(newCount)")
            
            update?()
            
            navigationController?.popViewController(animated: true)
        }

}
