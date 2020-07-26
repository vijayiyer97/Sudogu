//
//  PersistentStore.swift
//  Sudogu
//
//  Created by Vijay Iyer on 7/26/20.
//

import SwiftUI
import CoreData

class PersistentStore: ObservableObject {
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // One line singleton
    static let shared: PersistentStore = PersistentStore()
    
    // MARK: Initializers
    // Mark the class initializer private so that it is only accessible through the singleton `shared` static property
    private init() { }
    
    private let persistentStoreName: String = "CloudStore"
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: persistentStoreName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error)")
            }
        })
        // Include the following line for use with CloudKit - NSPersistentCloudKitContainer
        container.viewContext.automaticallyMergesChangesFromParent = true
        // Include the following line for use with CloudKit and to set your merge policy, for example...
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    // MARK: - Core Data Saving and "other future" support (such as undo)
    func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
