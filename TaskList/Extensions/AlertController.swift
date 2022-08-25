//
//  AlertController.swift
//  TaskList
//
//  Created by igor s on 25.08.2022.
//

import UIKit

extension UIAlertController {
    static func createAlert(withTitle title: String) -> UIAlertController {
        UIAlertController(
            title: title, message: "What do you want to do?", preferredStyle: .alert
        )
    }
    
    func action(task: Task?, completion: @escaping(String) -> Void) {
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self ] _ in
            guard let newValue = self?.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(save)
        addAction(cancel)
        addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = task?.title
        }
    }
}
