//
//  NotebookEntity.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public extension NotebookEntity {
    
    public enum ServiceError: Error {

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
        
        if siteModels.count == 0 {
            return Notebook(id: id!,
                            name: name!,
                            createdDate: createdDate!,
                            updatedDate: updatedDate!)
        } else {
            return Notebook(id: id!,
                            name: name!,
                            createdDate: createdDate!,
                            updatedDate: updatedDate!,
                            sites: siteModels)
        }
    }
}
