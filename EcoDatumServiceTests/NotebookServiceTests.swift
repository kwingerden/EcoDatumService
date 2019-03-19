//
//  NotebookServiceTests.swift
//  EcoDatumServiceTests
//
//  Created by Kenneth Wingerden on 3/18/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import EcoDatumCoreData
import XCTest
@testable import EcoDatumService

class NotebookServiceTests: XCTestCase {

    override func setUp() {
        try? CoreDataManager.shared.reset()
    }

    override func tearDown() {
    }

    func test1() throws {
        let defaultNotebook = try NotebookService.new()
        let notebook1 = try NotebookService.new("notebook1")
        let notebook2 = try NotebookService.new("notebook2")
        
        XCTAssert(NotebookService.names.count == 3)
        XCTAssert(NotebookService.names.contains(NotebookService.DEFAULT_NAME))
        XCTAssert(NotebookService.names.contains("notebook1"))
        XCTAssert(NotebookService.names.contains("notebook2"))
        
        XCTAssert(try NotebookService.find(by: NotebookService.DEFAULT_NAME) == defaultNotebook)
        XCTAssert(try NotebookService.find(by: "notebook1") == notebook1)
        XCTAssert(try NotebookService.find(by: "notebook2") == notebook2)

        XCTAssert(try NotebookService.find(by: "does not exist") == nil)
        
        do {
            let _ = try NotebookService.new("notebook1")
            XCTFail()
        } catch {
            // Expected, do nothing
        }
        
        let _ = try notebook1.delete()
        XCTAssert(NotebookService.names.count == 2)
        XCTAssert(NotebookService.names.contains(NotebookService.DEFAULT_NAME))
        XCTAssert(NotebookService.names.contains("notebook2"))
    }

}
