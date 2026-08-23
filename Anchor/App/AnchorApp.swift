//
//  AnchorApp.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//

import SwiftUI
import OSLog

@main
struct AnchorApp: App {
    private let windowManager = WindowManager()
    
    init () {
        windowManager.start()
        
        Logger.app.info("Anchor started")
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
