//
//  StorageManager.swift
//  TaskList
//
//  Created by igor s on 23.08.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private init () {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchDatas(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        do {
            taskList = try context.fetch(fetchRequest)
            if !taskList.isEmpty {
                completion(.success(taskList))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(title: String, completion: (Result<Task, Error>) -> Void) {
        let task = Task(context: context)
        task.title = title
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(task))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
    
    func delete(object: Task) {
        context.delete(object)
        checkContextChanges()
    }
    
    func update(task: Task, newTitle: String) {
        task.title = newTitle
        checkContextChanges()
    }
    
    private func checkContextChanges() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
    }
    
}
