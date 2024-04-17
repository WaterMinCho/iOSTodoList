//
//  EntryViewController.swift
//  TodoList
//
//  Created by 조민수 on 4/3/24.
//

import UIKit

//UITextFieldDelegate: TextField Object에서 텍스트 편집 및 유효성 검사를 관리하는 일련의 Optional 메서드
class EntryViewController: UIViewController, UITextFieldDelegate { //프로토콜 채택
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)? //클로저 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self // filed변수, filed와 연결된 item의 상태변화 혹은 event 발생시 self(현재 class)가 위임받아 작업을 대신 처리하겠다라는 의미.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveTask))
    }
    
    //그 작업을 처리해주는 친구
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    
    // #selector()가 옵젝씨라서 옵젝씨도 가능하게끔. @objc 표기
    @objc func saveTask() {
        //saveTask 동작하면 text를 가져옴
        guard let text = field.text, !text.isEmpty else {
//            let text = field.text - field.text의 값을 상수 "text"에 옮긴다.
//            2. "!text.isEmpty"가 "true(값이 있으면)"이면 그대로 진행.
//            3. "!text.isEmpty"가 "false(값이 없으면)"이면 "return(메소드 진행을 종료)"
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else { // 해당 값이 Int 자료형이 아닐 경우 리턴
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }
}
