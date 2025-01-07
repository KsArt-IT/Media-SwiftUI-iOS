//
//  Recording.swift
//  Media-SUI
//
//  Created by KsArT on 07.01.2025.
//

import Foundation

struct FileDto: Identifiable, Hashable {
    let n: Int
    let name: String
    let url: URL
    let date: Date
    var id: URL {
        url
    }
}
