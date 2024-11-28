//
//  Recording.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import Foundation

struct Recording: Identifiable, Hashable {
    let id: Int
    let name: String
    let url: URL
    let date: Date
}