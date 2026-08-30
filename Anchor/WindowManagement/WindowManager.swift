//
//  WindowManager.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//
import AppKit
import OSLog

@MainActor
final class WindowManager {
    private var applications: [pid_t: AXApplication] = [:]
    
    private lazy var applicationTracker = ApplicationTracker(
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
        let pid = application.processIdentifier
        
        guard applications[pid] == nil else {
            return
        }
        
        Logger.windowManager.debug("Adding application pid=\(pid): \(application.localizedName ?? "<no name>")")
        
        let axApplication = AXApplication(
            application: application,
            onWindowCreated: { [weak self] element in
                self?.windowCreated(element)
            }
        )
        
        applications[pid] = axApplication
        
        for window in axApplication.windows() {
            windowCreated(window)
        }
        
        axApplication.startObserving()
    }
    
    private func applicationDidTerminate(_ application: NSRunningApplication) {
        let pid = application.processIdentifier
        
        Logger.windowManager.debug("Removing application pid=\(pid)")
        
        applications.removeValue(forKey: pid)
    }
    
    private func windowCreated(_ window: AXWindow) {
        Logger.windowManager.debug("Window created for application pid=\(window.pid)")
    }
}
