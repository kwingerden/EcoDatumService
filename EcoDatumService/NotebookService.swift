//
//  NotebookService.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

public class NotebookService {
    
    public static let DEFAULT_NAME = "Default"
    
    public enum ServiceError: Error {
        case InvalidNotebookData
    }
    
    public static var names: [String] {
        guard let names = try? NotebookEntity.all().map({$0.name}).filter({$0 != nil}).map({$0!}) else {
            return []
        }
        return names
    }
    
    public static func new(_ name: String = DEFAULT_NAME) throws -> Notebook {
        let notebook = try NotebookEntity.new(name: name)
        try CoreDataManager.shared.save()
        assert(notebook.id != nil)
        assert(notebook.createdDate != nil)
        assert(notebook.updatedDate != nil)
        return Notebook(id: notebook.id!,
                        name: name,
                        createdDate: notebook.createdDate!,
                        updatedDate: notebook.updatedDate!)
    }
    
    public static func find(by name: String) throws -> Notebook? {
        return try NotebookEntity.find(by: name)?.toModel()
    }
    
    public static func deleteAll() throws {
        try NotebookEntity.deleteAll()
    }
    
}
