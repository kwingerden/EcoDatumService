//
//  CoordinateEntity.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 5/6/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import CoreData
import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public extension CoordinateEntity {
    
    public func model() -> Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude, accuracy: accuracy)
    }
    
}
