//
//  StorageManager.swift
//  TaskList
//
//  Created by Карина Короткая on 29.03.2024.
//

import Foundation
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
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
    
    func fetchTasks() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func addTask(title: String) {
        let context = persistentContainer.viewContext
        let task = ToDoTask(context: context)
        task.title = title
        saveContext()
    }
    
    func updateTask(_ task: ToDoTask, withTitle title: String) {
        task.title = title
        saveContext()
    }
    
    func deleteTask(_ task: ToDoTask) {
        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
}
