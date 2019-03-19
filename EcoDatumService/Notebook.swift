//
//  Notebook.swift
//  EcoDatumService
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCommon
import EcoDatumCoreData
import EcoDatumModel
import Foundation

extension Notebook {
    
    func delete() throws -> Bool {
        if let notebook = try NotebookEntity.find(by: name) {
            notebook.delete()
            return true
        }
        assertionFailure("Failed to find persisted Notebook: \(name)")
        return false
    }
    
}
