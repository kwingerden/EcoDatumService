//
//  AltitudeEntity.swift
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

public extension AltitudeEntity {
    
    public func model() -> Altitude {
        return Altitude(altitude: altitude, accuracy: accuracy)
    }
    
}
