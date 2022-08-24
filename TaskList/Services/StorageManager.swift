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
    
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    private init () {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let taskList = try context.fetch(fetchRequest)
            completion(.success(taskList))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(title: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.title = title
        completion(task)
        saveContext()
    }
    
    func delete(object: Task) {
        context.delete(object)
        saveContext()
    }
    
    func update(task: Task, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
}
