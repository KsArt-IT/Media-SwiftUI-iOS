//
//  Musicinfo.swift
//  Media-SUI
//
//  Created by KsArT on 30.11.2024.
//

struct Musicinfo: Decodable {
    let vocalinstrumental, lang, gender, acousticelectric: String
    let speed: String
    let tags: Tags
}
