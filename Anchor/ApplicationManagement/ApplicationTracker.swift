//
//  ApplicationTracker.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 30.08.2026.
//
import AppKit
import OSLog

final class ApplicationTracker {
    typealias ApplicationHandler = (NSRunningApplication) -> Void
    
    private let workspace: NSWorkspace
    private let onLaunch: ApplicationHandler
    private let onTerminate: ApplicationHandler
    
    private var observers: [NSObjectProtocol] = []
    
    init(workspace: NSWorkspace = .shared, onLaunch: @escaping ApplicationHandler, onTerminate: @escaping ApplicationHandler) {
        self.workspace = workspace
        self.onLaunch = onLaunch
        self.onTerminate = onTerminate
    }
    
    func start() {
        Logger.app.info("Starting application tracker")
        
        workspace.runningApplications.forEach { handleInitialApplication($0) }
        
        observers.append(
            workspace.notificationCenter.addObserver(
                forName: NSWorkspace.didLaunchApplicationNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                self?.handleLaunch(notification)
            }
        )
        
        observers.append(
            workspace.notificationCenter.addObserver(
                forName: NSWorkspace.didTerminateApplicationNotification,
                object: nil,
                queue: .main
            ) { [weak self] notification in
                self?.handleTerminate(notification)
            }
        )
    }
    
    deinit {
        observers.forEach { workspace.notificationCenter.removeObserver($0) }
    }
    
    private func handleInitialApplication(_ application: NSRunningApplication) {
        guard shouldTrack(application) else { return }
        
        onLaunch(application)
    }
    
    private func handleLaunch(_ notification: Notification) {
        guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else { return }
        
        guard shouldTrack(application) else { return }
        
        Logger.app.debug("Application launched: \(application.bundleIdentifier ?? "<unknown>", privacy: .public)")
        
        onLaunch(application)
    }
    
    private func handleTerminate(_ notification: Notification) {
        guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else { return }
        
        Logger.app.debug("Application terminated: \(application.bundleIdentifier ?? "<unknown>", privacy: .public)")
        
        onTerminate(application)
    }
    
    private func shouldTrack(_ application: NSRunningApplication) -> Bool {
        guard application.processIdentifier != ProcessInfo.processInfo.processIdentifier else { return false }
        
        return application.activationPolicy == .regular
    }
}
