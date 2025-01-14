//
//  PlayerAction.swift
//  Media-SUI
//
//  Created by KsArT on 14.01.2025.
//

import Foundation
import AVFoundation

enum PlayerAction {
    case start(_ track: Track?)
    case play
    case pauseOrPlay
    case stop
    case backward
    case forward
}
