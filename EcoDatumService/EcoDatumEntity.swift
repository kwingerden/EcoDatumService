//
//  EcoDatumEntity.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public extension EcoDatumEntity {
    
    public func toModel() throws -> EcoDatum {
        assert(id != nil)
        assert(createdDate != nil)
        assert(updatedDate != nil)
        assert(collectionDate != nil)
        assert(primaryType != nil)
        assert(secondaryType != nil)
        assert(dataType != nil)
        assert(dataValue != nil)
        
        let primaryTypeEnum = PrimaryType.init(rawValue: primaryType!)
        let secondaryTypeEnum = SecondaryType.init(rawValue: secondaryType!)
        let dataTypeEnum = DataType.init(rawValue: dataType!)
        assert(primaryTypeEnum != nil)
        assert(secondaryTypeEnum != nil)
        assert(dataTypeEnum != nil)
        
        var dataUnitEnum: DataUnit?
        if let dataUnit = dataUnit {
            dataUnitEnum = DataUnit.init(rawValue: dataUnit)
            assert(dataTypeEnum != nil)
        }
        
        var ecoDataModels: [EcoDatum] = []
        if let children = children {
            for child in children {
                let ecoDatumEntity = child as! EcoDatumEntity
                ecoDataModels.append(try ecoDatumEntity.toModel())
            }
        }

        return EcoDatum(id: id!,
                        createdDate: createdDate!,
                        updatedDate: updatedDate!,
                        collectionDate: collectionDate!,
                        primaryType: primaryTypeEnum!,
                        secondaryType: secondaryTypeEnum!,
                        dataType: dataTypeEnum!,
                        dataUnit: dataUnitEnum,
                        dataValue: dataValue!.base64EncodedString(),
                        ecoData: ecoDataModels.isEmpty ? nil : ecoDataModels)
    }
    
}
