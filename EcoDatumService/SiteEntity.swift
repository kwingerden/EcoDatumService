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
    
    public static func names(_ context: NSManagedObjectContext, in notebook: String) throws -> [String] {
        let request: NSFetchRequest<SiteEntity> = SiteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "notebook.name ==[c] %@", argumentArray: [notebook])
        request.includesSubentities = false
        request.propertiesToFetch = ["name"]
        let result = try context.fetch(request)
        return result.map({$0.name!})
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
