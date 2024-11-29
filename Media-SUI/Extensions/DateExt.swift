//
//  DateExt.swift
//  Media-SUI
//
//  Created by KsArT on 28.11.2024.
//

import Foundation

extension Date {
    func toString() -> String {
        formatted(.dateTime.hour().minute().second().day().month().year())
    }
    
    func toFileName() -> String {
        Constants.dateFormatterForFileName.string(from: self)
    }
}
