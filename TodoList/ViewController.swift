//
//  ViewController.swift
//  TodoList
//
//  Created by 조민수 on 4/2/24.
//

import UIKit
import OSLog

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView! //클래스 전역 변수로 tableView 변수 추가.
    
    var tasks = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "할일들"
        
        
        // extension을 통해 확장했던 tableView의 delegate, dataSource를 self(현재 ViewController)가 제어할 수 있도록 설정.
        tableView.delegate = self
        tableView.dataSource = self
        
    
        //UserDefaults: 내장 클래스.
        if !UserDefaults().bool(forKey: "setup") { //저장된 데이터를 "bool"형태로 가져오는 메소드. "forKey"는 저장된 데이터의 키를 입력하는 파라미터
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        updateTasks()
    }
    
    func updateTasks(){
        
        print("업데이트 removeALL")
        tasks.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        print("업데이트 count", count)
        
        for x in 0..<count{
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                print("업데이트 task", task)
                tasks.append(task)
            }
            
        }
        
        tableView.reloadData()
    }
    

    @IBAction func didTapAdd(){
        let vc  = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async(){ //비동기 처리
                self.updateTasks() //갱신 처리
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController: UITableViewDelegate{ //뷰 컨트롤러 확장 1
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
       
        vc.title = "Task"
        vc.task = tasks[indexPath.row]
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource{ //뷰 컨트롤러 확장 2
    
//    tableview의 row의 section수를 정해주는 것
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    // tasks배열의 요소 갯수가 5개라면 5개의 section으로 나뉠 것.

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row] //task 배열 데이터를 cell textLabel의 text에 넣어줌
        
        return cell
        
    }
}
