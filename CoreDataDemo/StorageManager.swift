//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Никита Горбунов on 23.03.2022.
//

import Foundation
import CoreData
import UIKit


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class StorageManager {
    
    static let shared = StorageManager()
    
    let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Save Core Data
    func saveCoreData(_ name: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.title = name
        saveContext()
    }
    
    func editCoreData(_ task: Task, newName: String) {
        task.title = newName
        saveContext()
    }
    
    func deleteCoreData(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
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
    
    func fetchData(completion: (Result<[Task], NetworkError>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch {
            completion(.failure(.noData))
        }
    }
}
    
    
