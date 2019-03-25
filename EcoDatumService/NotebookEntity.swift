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
}
