//
//  Article.swift
//  News
//
//  Created by Александр Белый on 15.11.2024.
//

import Foundation

struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Decodable {
    let id: String?
    let name: String
}
