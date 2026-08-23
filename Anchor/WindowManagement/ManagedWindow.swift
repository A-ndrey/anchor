//
//  ManagedWindow.swift
//  Anchor
//
//  Created by Андрей Мокрецов on 24.08.2026.
//

import Foundation

struct ManagedWindow {
    let id: UUID
    let axWindow: AXWindow
    
    var frame: CGRect
    var isFloating: Bool
}
