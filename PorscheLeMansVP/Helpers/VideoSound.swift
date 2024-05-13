//
//  VideoSound.swift
//  PorscheLeMansVP
//
//  Created by Thomas Fekete Christensen on 13/05/2024.
//

import Foundation

public struct VideoSound {
    public static var defaultMuted: Bool {
        let isSimulator = TARGET_OS_SIMULATOR != 0
        return isSimulator
    }
}
