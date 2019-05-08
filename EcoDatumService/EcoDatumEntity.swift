//
//  EcoDatumEntity.swift
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

public extension EcoDatumEntity {
    
    public enum ServiceError: Error {
        case NotebookDoesNotExist(name: String)
        case SiteDoesNotExist(name: String)
        case EcoDatumIsNotValid(description: String)
    }
    
    public static func new(_ context: NSManagedObjectContext,
                           with siteName: String,
                           in notebookName: String,
                           ecoDatum: EcoDatum) throws -> EcoDatumEntity {
        guard try NotebookEntity.exists(context, with: notebookName) else {
            throw ServiceError.NotebookDoesNotExist(name: notebookName)
        }
        
        guard let site = try SiteEntity.find(context, with: siteName, in: notebookName) else {
            throw ServiceError.SiteDoesNotExist(name: siteName)
        }
        
        guard ecoDatum.isValid else {
            throw ServiceError.EcoDatumIsNotValid(description: ecoDatum.description)
        }
        
        let ecoDatumEntity = EcoDatumEntity(context: context)
        ecoDatumEntity.id = ecoDatum.id
        ecoDatumEntity.createdDate = Date()
        ecoDatumEntity.updatedDate = Date()
        
        ecoDatumEntity.collectionDate = ecoDatum.collectionDate
        ecoDatumEntity.primaryType = ecoDatum.primaryType.rawValue
        ecoDatumEntity.secondaryType = ecoDatum.secondaryType.rawValue
        ecoDatumEntity.dataType = ecoDatum.dataType.rawValue
        ecoDatumEntity.dataUnit = ecoDatum.dataUnit?.rawValue ?? nil
        ecoDatumEntity.dataValue = ecoDatum.dataValue.data(using: .utf8)
        
        site.addToEcoData(ecoDatumEntity)
        
        return ecoDatumEntity
    }
    
    public static func first(_ context: NSManagedObjectContext,
                             in notebookName: String,
                             in siteName: String,
                             with primaryType: PrimaryType,
                             with secondaryType: SecondaryType,
                             with dataType: DataType) throws -> EcoDatumEntity? {
        guard try NotebookEntity.exists(context, with: notebookName) else {
            throw ServiceError.NotebookDoesNotExist(name: notebookName)
        }
        
        guard let site = try SiteEntity.find(context, with: siteName, in: notebookName) else {
            throw ServiceError.SiteDoesNotExist(name: siteName)
        }
        
        let request: NSFetchRequest<EcoDatumEntity> = EcoDatumEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: """
                site.id == %@ AND
                primaryType == %@ AND
                secondaryType == %@ AND
                dataType == %@
                """,
            argumentArray: [
                site.id!.uuidString,
                primaryType.rawValue,
                secondaryType.rawValue,
                dataType.rawValue])
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.fetchLimit = 1
        //request.includesSubentities = false
        let result = try context.fetch(request)
        if result.count == 1 {
            return result[0]
        }
        return nil
    }
    
    public func save() throws {
        try managedObjectContext?.save()
    }
    
    public func delete() {
        managedObjectContext?.delete(self)
    }
    
    public func model() throws -> EcoDatum {
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
                ecoDataModels.append(try ecoDatumEntity.model())
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
