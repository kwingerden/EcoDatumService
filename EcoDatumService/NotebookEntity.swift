//
//  NotebookEntity.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import CoreData
import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public extension NotebookEntity {
    
    public enum EntityError: Error {
        case NameAlreadyExists(name: String)
    }
    
    public static let DEFAULT_NOTEBOOK_NAME = "Default"
    
    public static func new(_ context: NSManagedObjectContext,
                           name: String = DEFAULT_NOTEBOOK_NAME) throws -> NotebookEntity {
        if try exists(context, with: name) {
            throw EntityError.NameAlreadyExists(name: name)
        }
        
        let notebook = NotebookEntity(context: context)
        notebook.id = UUID()
        notebook.name = name
        notebook.createdDate = Date()
        notebook.updatedDate = Date()
        return notebook
    }
    
    public static func exists(_ context: NSManagedObjectContext, with name: String) throws -> Bool {
        let request: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name ==[c] %@", argumentArray: [name])
        request.fetchLimit = 1
        request.includesSubentities = false
        return try context.count(for: request) == 1
    }
    
    public static func find(_ context: NSManagedObjectContext, with name: String) throws -> NotebookEntity? {
        let request: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name ==[c] %@", argumentArray: [name])
        request.fetchLimit = 1
        request.includesSubentities = false
        let result = try context.fetch(request)
        if result.count == 1 {
            return result[0]
        }
        return nil
    }
    
    public static func count(_ context: NSManagedObjectContext) throws -> Int {
        let request: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        request.includesSubentities = false
        return try context.count(for: request)
    }
    
    public static func names(_ context: NSManagedObjectContext) throws -> [String] {
        let request: NSFetchRequest<NotebookEntity> = NotebookEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.includesSubentities = false
        request.propertiesToFetch = ["name"]
        let result = try context.fetch(request)
        return result.map({$0.name!})
    }
    
    public func save() throws {
        try managedObjectContext?.save()
    }
    
    public func delete() {
        managedObjectContext?.delete(self)
    }
    
    /*
    public static var names: [String] {
        guard let names = try? NotebookEntity.all().map({$0.name}).filter({$0 != nil}).map({$0!}) else {
            return []
        }
        return names
    }
    
    
    public static func fromModel(notebook: Notebook) throws -> NotebookEntity {
        let notebookEntity = try new(
            id: notebook.id,
            name: notebook.name,
            createdDate: notebook.createdDate,
            updatedDate: notebook.updatedDate)
        
        if let sites = notebook.sites {
            for site in sites {
                notebookEntity.sites?.adding(SiteEntity.fromModel(site))
            }
        }
        
        return notebookEntity
    }
    
    public func toModel() throws -> Notebook {
        assert(id != nil)
        assert(name != nil)
        assert(createdDate != nil)
        assert(updatedDate != nil)
        
        var siteModels: [Site] = []
        if let sites = sites {
            for s in sites {
                let siteEntity = s as! SiteEntity
                siteModels.append(try siteEntity.toModel())
            }
        }
        
        return Notebook(id: id!,
                        name: name!,
                        createdDate: createdDate!,
                        updatedDate: updatedDate!,
                        sites: siteModels.isEmpty ? nil : siteModels)
    }
 */
}
