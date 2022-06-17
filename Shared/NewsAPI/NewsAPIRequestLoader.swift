//
//  NewsAPIRequestLoader.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 13/6/2565 BE.
//

import Foundation
import os

enum NewsAPIRequestLoaderError: Error {
    case invalidReponse
    case invalidFormat
}

extension NewsAPIRequestLoaderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidReponse:
            return "Invalid response (statusCode != 200)"
        case .invalidFormat:
            return "Cannot convert to NewsAPIResponse cause invalid format"
        }
    }
}

class NewsAPIRequestLoader {
    private let apiKey = "8bfba1b8763148feb3583622592d9115"
    private let apiUrlString = "https://newsapi.org/v2/everything"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                category: String(describing: NewsAPIRequestLoader.self))
    
    var urlSession: URLSession = URLSession.shared
    
    private func makeArticlesRequest(q: String, pageSize: Int, page offset: Int, sortBy: String) -> URLRequest {
        let qSafe = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let apiUrl = URL(string: apiUrlString + "?apiKey=\(apiKey)&q=\(qSafe)&pageSize=\(pageSize)&page=\(offset)&sortBy=\(sortBy)&language=en")!
        return URLRequest(url: apiUrl)
    }
    
    func loadArticlesRequest(
        q query: String = "apple",
        pageSize size: Int = 10,
        page offset: Int,
        sortBy: String = "publishedAt"
    ) async throws -> [Article] {
        let request = makeArticlesRequest(q: query, pageSize: size, page: offset,sortBy: sortBy)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("can't convert response to HTTPURLResponse")
            throw NewsAPIRequestLoaderError.invalidReponse
        }
        guard httpResponse.statusCode == 200 else {
            logger.warning("can't load article with statusCode != 200, \(httpResponse.statusCode)")
            throw NewsAPIRequestLoaderError.invalidReponse
        }
        guard let newsResponse = try? JSONDecoder().decode(NewsAPIResponse.self, from: data) else {
            logger.warning("can't convert data to the NewsAPIResponse object, \(data)")
            throw NewsAPIRequestLoaderError.invalidFormat
        }
        return newsResponse.articles
    }
}
