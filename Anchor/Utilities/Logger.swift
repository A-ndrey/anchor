//
//  Logger.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//

import OSLog

extension Logger {
    private static let subsystem: String = Bundle.main.bundleIdentifier ?? "Anchor"
    
    static let app = Logger(subsystem: subsystem, category: "app")
    static let accessibility = Logger(subsystem: subsystem, category: "accessibility")
    static let windowManager = Logger(subsystem: subsystem, category: "window-manager")
}
