//
//  PlayerAction.swift
//  Media-SUI
//
//  Created by KsArT on 14.01.2025.
//

import Foundation
import AVFoundation

enum PlayerAction: Hashable {
    case start(_ track: Track?)
    case pauseOrPlay
    case stop
    case skipBackward
    case backward(_ rnd: Int = -1)
    case forward(_ rnd: Int = -1)
    case skipForward
    case seekPosition(_ time: Double)
}
