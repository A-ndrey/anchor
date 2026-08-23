//
//  AnchorApp.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//

import SwiftUI

@main
struct AnchorApp: App {
    private let windowManager = WindowManager()
    
    init () {
        windowManager.start()
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
