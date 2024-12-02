//
//  Headers.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

struct Headers: Decodable {
    let status: String
    let code: Int
    let errorMessage: String
    let warnings: String
    let resultsCount: Int
}
