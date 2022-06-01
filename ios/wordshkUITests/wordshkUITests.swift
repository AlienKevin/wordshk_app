//
//  wordshkUITests.swift
//  wordshkUITests
//
//  Created by Kevin Li on 6/1/22.
//

import XCTest

class wordshkUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testTakeScreenshots() throws {
        
        let app = XCUIApplication()
        
        // wait for the full UI to be loaded
        let success = app.textFields.element(boundBy: 0).waitForExistence(timeout: 6)
        assert(success)
        
        let appLocale = app.buttons["Open navigation menu"].exists ? "en" : (app.buttons["打开导航菜单"].exists ? "zh-Hans": "zh-Hant")
        
        let initDrawerTag = appLocale.contains("en") ? "Open navigation menu" : (appLocale.contains("zh-Hans") ? "打开导航菜单" : "開啟導覽選單")
        let initPreferencesTag = appLocale.contains("en") ? "Preferences" : (appLocale.contains("zh-Hans") ? "设置" : "設定");
        
        
        let drawerTag = locale.contains("en") ? "Open navigation menu" : (appLocale.contains("zh-Hans") ? "打开导航菜单" : "開啟導覽選單")
        let resultTag = locale.contains("zh-Hans") ? "广东话 gwong2 dung1 waa2" : "廣東話 gwong2 dung1 waa2";
        let aboutTag = locale.contains("en") ? "About words.hk" : (locale.contains("zh-Hans") ? "关于粤典" : "關於粵典");
        let languageTag = locale.contains("en") ? "English" : (locale.contains("zh-Hans") ? "中文（中国大陆）" : "中文（台灣）")
        let dictionaryTag = locale.contains("en") ? "Dictionary" : "字典"
        
        app.buttons[initDrawerTag].tap()
        app.buttons[initPreferencesTag].tap()
        app.switches[languageTag].tap()
        
        snapshot("4Preferences")

        app.buttons[drawerTag].tap()
        
        app.buttons[aboutTag].tap()
        snapshot("3About")
        app.buttons[drawerTag].tap()
        
        app.buttons[dictionaryTag].tap()
        snapshot("0Home")
        
        let searchField = app.textFields.element(boundBy: 0)
        searchField.typeText("gwong dung waa")
        snapshot("1Results")
        
        app.buttons[resultTag].tap()
        snapshot("2Entry")
    }
}
