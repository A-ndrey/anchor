//
//  WindowManager.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//
import AppKit
import OSLog


final class WindowManager {
    func start() {
        Logger.windowManager.info("Starting...")
        
        discoverWindows()
        
        Logger.windowManager.info("Started")
    }
    
    private func discoverWindows() {
        
    }
}
