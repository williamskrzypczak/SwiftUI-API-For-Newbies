//
//  Swift_API_Calls_for_NewbiesUITestsLaunchTests.swift
//  Swift API Calls for NewbiesUITests
//
//  Created by Bill Skrzypczak on 10/22/23.
//

import XCTest

final class Swift_API_Calls_for_NewbiesUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
