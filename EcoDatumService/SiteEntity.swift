//
//  SiteEntity.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public extension SiteEntity {
    
    public enum ServiceError: Error {
        
    }
    
    public func toModel() throws -> Site {
        assert(id != nil)
        assert(name != nil)
        assert(createdDate != nil)
        assert(updatedDate != nil)
        
        var coodinate: Coordinate
        if let latitude = latitude,
            let longitude = longitude,
            let accuracy = coordinateAccuracy {
            coordinate = Coordinate(
                latitude: latitude,
                longitude: longitude,
                accuracy: coordinateAccuracy)
        }
        
        
        let altitude = Altitude(altitude: self.altitude, accuracy: altitudeAccuracy)
        
        return Site(id: id,
                        name: name,
                        createdDate: createdDate,
                        updatedDate: updatedDate,
                        coordinate: coordinate,
                        altitude: altitude,
                        ecoData: nil)
    }
    
}
