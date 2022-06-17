//
//  NewsAPIResponse.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 13/6/2565 BE.
//

import Foundation

/// The response from **NewsAPI** `v2/everything`
struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
