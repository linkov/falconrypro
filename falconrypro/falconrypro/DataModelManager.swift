//
//  DataManager.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import UIKit
import CoreData

class DataModelManager: NSObject {
    

    static let sharedInstance : DataModelManager = {
        let instance = DataModelManager()
        return instance
    }()
    
    var errorHandler: (Error) -> Void = {_ in }
    
    
    func setupCoreData() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    

    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    func deleteAllEntitiesWithName(name:String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.viewContext.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
    }
    
  
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func insert(entity:NSManagedObject,
                     toContext:NSManagedObjectContext,
                     completion:sdw_id_error_block) {
        
        
    }
    
    public func fetch(entityDescription:NSEntityDescription,
                         predicate:NSPredicate?,
                         context:NSManagedObjectContext,
                         completion:sdw_id_error_block) {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityDescription.name!)
        fetchRequest.predicate = predicate
        
        var results = [NSManagedObject]()
        do {
            results = try context.fetch(fetchRequest) as! [NSManagedObject]
            completion(results.first,nil)
        } catch {
            let nserror = error as NSError
            completion(nil,nserror)
          
        }
        
        print(results.first ?? "error")
        
        
        
    }
    
    public func fetchAll(entityName:String,
                         predicate:NSPredicate?,
                         context:NSManagedObjectContext) -> [NSManagedObject] {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        var results = [NSManagedObject]()
        do {
            results = try context.fetch(fetchRequest)  as! [NSManagedObject]
            return results
        } catch {
            
            return []

        }
        
        return []
        
        
        
    }

    
    
    public func fetchAll(entityName:String,
                         predicate:NSPredicate?,
                         context:NSManagedObjectContext,
                         completion:sdw_id_error_block) {
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
    
        var results = [NSManagedObject]()
        do {
            results = try context.fetch(fetchRequest)  as! [NSManagedObject]
            completion(results,nil)
        } catch {
            let nserror = error as NSError
            completion(nil,nserror)
        }
        
        print(results )
        
        

    }
    
//    - (void)fetchAllEntitiesForName:(NSString *)entityName
//    withPredicate:(NSPredicate *)predicate
//    inContext:(NSManagedObjectContext *)context
//    withCompletion:(CNIIDErrorBlock)completion {
//    [context performBlock:^{
//    NSError                         *error = nil;
//    NSArray                         *results = nil;
//    NSFetchRequest          *fetchRequest = nil;
//    NSEntityDescription     *entity = nil;
//    
//    fetchRequest = [[NSFetchRequest alloc] init];
//    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
//    fetchRequest.entity = entity;
//    fetchRequest.predicate = predicate;
//    
//    results = [context executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//    SDWPerformBlock(completion, nil, error);
//    } else {
//    SDWPerformBlock(completion, results, nil);
//    }
//    }];
//    }
}

