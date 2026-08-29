//
//  WindowManager.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//
import AppKit
import OSLog


final class WindowManager {
    private lazy var applicationTracker: ApplicationTracker = ApplicationTracker(
        onLaunch: {[weak self] application in
            self?.applicationDidLaunch(application)
        },
        onTerminate: { [weak self] application in
            self?.applicationDidLaunch(application)
        }
    )
    
    
    func start() {
        Logger.windowManager.info("Starting window manager")
        
        applicationTracker.start()
    }
    
    private func applicationDidLaunch(_ application: NSRunningApplication) {
        Logger.windowManager.debug("Tracking application pid=\(application.processIdentifier) name=\(application.localizedName ?? "<unknown>")")
    }
    
    private func applicationDidTerminate(_ application: NSRunningApplication) {
        Logger.windowManager.debug("Removing application pid=\(application.processIdentifier)")
    }
}
