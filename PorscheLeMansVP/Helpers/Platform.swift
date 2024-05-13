//
//  Platform.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation

public struct Platform {
    public static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}
