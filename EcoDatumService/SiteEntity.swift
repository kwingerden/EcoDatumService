//
//  SiteEntity.swift
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

public extension SiteEntity {
    
    public enum EntityError: Error {
        case NotebookDoesNotExist(name: String)
        case NameAlreadyExists(name: String)
    }
    
    public static func new(_ context: NSManagedObjectContext, with siteName: String, in notebookName: String) throws -> SiteEntity {
        guard let notebook = try NotebookEntity.find(context, with: notebookName) else {
            throw EntityError.NotebookDoesNotExist(name: notebookName)
        }
        
        if try exists(context, with: siteName, in: notebookName) {
            throw EntityError.NameAlreadyExists(name: siteName)
        }
        
        let site = SiteEntity(context: context)
        site.id = UUID()
        site.name = siteName
        site.createdDate = Date()
        site.updatedDate = Date()
        
        notebook.addToSites(site)
        
        return site
    }
    
    public static func exists(_ context: NSManagedObjectContext, with siteName: String, in notebookName: String) throws -> Bool {
        let request: NSFetchRequest<SiteEntity> = SiteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name ==[c] %@ AND notebook.name ==[c] %@", argumentArray: [siteName, notebookName])
        request.fetchLimit = 1
        request.includesSubentities = false
        return try context.count(for: request) == 1
    }
    
    public static func find(_ context: NSManagedObjectContext, with siteName: String, in notebookName: String) throws -> SiteEntity? {
        let request: NSFetchRequest<SiteEntity> = SiteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name ==[c] %@ AND notebook.name ==[c] %@", argumentArray: [siteName, notebookName])
        request.fetchLimit = 1
        request.includesSubentities = false
        let result = try context.fetch(request)
        if result.count == 1 {
            return result[0]
        }
        return nil
    }
    
    public static func count(_ context: NSManagedObjectContext, in notebookName: String) throws -> Int {
        let request: NSFetchRequest<SiteEntity> = SiteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "notebook.name ==[c] %@", argumentArray: [notebookName])
        request.includesSubentities = false
        return try context.count(for: request)
    }
    
    public static func names(_ context: NSManagedObjectContext, in notebookName: String) throws -> [String] {
        let request: NSFetchRequest<SiteEntity> = SiteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "notebook.name ==[c] %@", argumentArray: [notebookName])
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
    public static func fromModel(site: Site) throws -> SiteEntity {
    
    }
    
    public func toModel() throws -> Site {
        assert(id != nil)
        assert(name != nil)
        assert(createdDate != nil)
        assert(updatedDate != nil)
        
        var location: Location?
        if let locationEntity = self.location {
            assert(locationEntity.coordinate != nil)
            let coordinate = Coordinate(
                latitude: locationEntity.coordinate!.latitude,
                longitude: locationEntity.coordinate!.longitude,
                accuracy: locationEntity.coordinate!.accuracy)
            
            var altitude: Altitude?
            if locationEntity.altitude != nil {
                altitude = Altitude(
                    altitude: locationEntity.altitude!.altitude,
                    accuracy: locationEntity.altitude!.accuracy)
            }
            
            location = Location(coordinate: coordinate, altitude: altitude)
        }
        
        var ecoDatumModels: [EcoDatum] = []
        if let ecoData = ecoData {
            for ecoDatum in ecoData {
                let ecoDatumEntity = ecoDatum as! EcoDatumEntity
                ecoDatumModels.append(try ecoDatumEntity.toModel())
            }
        }
        
        return Site(id: id!,
                    name: name!,
                    createdDate: createdDate!,
                    updatedDate: updatedDate!,
                    location: location,
                    ecoData: ecoDatumModels.isEmpty ? nil : ecoDatumModels)
    }
 */
    
}
