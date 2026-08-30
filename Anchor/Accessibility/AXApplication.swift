//
//  AXApplication.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 30.08.2026.
//
import AppKit
import ApplicationServices
import OSLog

final class AXApplication {
    let application: NSRunningApplication
    let element: AXUIElement
    
    var pid: pid_t {
        application.processIdentifier
    }
    
    typealias WindowHandler = (AXWindow) -> Void
    private let onWindowCreated: WindowHandler
    
    private var observer: AXObserver?
    
    init(application: NSRunningApplication, onWindowCreated: @escaping WindowHandler) {
        self.application = application
        self.element = AXUIElementCreateApplication(application.processIdentifier)
        self.onWindowCreated = onWindowCreated
    }
    
    func windows() -> [AXWindow] {
        var value: CFTypeRef?
        
        let error = AXUIElementCopyAttributeValue(element, kAXWindowsAttribute as CFString, &value)
        
        guard error == .success else {
            Logger.accessibility.debug("Cannot get windows for pid=\(self.pid): \(String(describing: error))")
            
            return []
        }
        
        guard let elements = value as? [AXUIElement] else {
            return []
        }
        
        return elements.map { AXWindow(element: $0, pid: pid) }
    }
    
    func startObserving() {
        var observer: AXObserver?
        
        let createError = AXObserverCreate(pid, axObserverCallback, &observer)
        
        guard createError == .success, let observer else {
            Logger.accessibility.error("Cannot create AXObserver for pid=\(self.pid)")
            return
        }
        
        let context = Unmanaged.passUnretained(self).toOpaque()
        
        let notificationError = AXObserverAddNotification(observer, element, kAXWindowCreatedNotification as CFString, context)
        
        guard notificationError == .success else {
            Logger.accessibility.error("Failed to subscribe to window creation for pid=\(self.pid): \(String(describing: notificationError))")
            return
        }
        
        CFRunLoopAddSource(CFRunLoopGetMain(), AXObserverGetRunLoopSource(observer), .commonModes)
        
        self.observer = observer
        
        Logger.accessibility.debug("Started AX observing for pid=\(self.pid)")
    }
    
    fileprivate func handle(element: AXUIElement, notification: CFString) {
        if notification == kAXWindowCreatedNotification as CFString {
            Logger.accessibility.debug("Window created for pid=\(self.pid)")
        }
    }
    
    private func handleWindowCreated(_ element: AXUIElement) {
        Logger.accessibility.debug("pid=\(self.pid) window created")
        
        let window = AXWindow(element: element, pid: pid)
        
        onWindowCreated(window)
    }
}

private func axObserverCallback(observer: AXObserver, element: AXUIElement, notification: CFString, refcon: UnsafeMutableRawPointer?) {
    guard let refcon else { return }
    
    let application = Unmanaged<AXApplication>.fromOpaque(refcon).takeUnretainedValue()
    
    application.handle(element: element, notification: notification)
}
