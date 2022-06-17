//
//  ExploreViewModel.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 14/6/2565 BE.
//

import SwiftUI
import os

enum ExploreFetchState {
    case ready
    case fetching
    case error
}

class ExploreViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: String(describing: ExploreViewModel.self))
    let newsAPILoader = NewsAPIRequestLoader()
    public static let defaultQuery = "apple"
    var query = "apple"
    var pages = 1
    
    // MARK: - Published Variables
    @Published var articles: [Article] = []
    @Published var fetchState: ExploreFetchState = .ready
    
    // MARK: - Update Published Variable
    @MainActor
    func updateFetchState(to state: ExploreFetchState) {
        fetchState = state
    }
    
    // MARK: - Functions
    
    var _isDidLoadDoOnce = true
    var isDidLoad = false
    func loadNewArticlesFromQuery(forced: Bool = false) {
        guard _isDidLoadDoOnce || forced else { return }
        isDidLoad = false
        _isDidLoadDoOnce.toggle()
        Task {
            await reloadArticles()
            isDidLoad = true
        }
    }
    
    var _lock_fetchStatusDidAppear = true
    func fetchStatusDidAppear() {
        guard isDidLoad else { return }
        guard fetchState == .ready else { return }
        guard _lock_fetchStatusDidAppear else { return }
        _lock_fetchStatusDidAppear.toggle()
        Task {
            await updateFetchState(to: .fetching)
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let result = await loadNextArticles()
            await updateFetchState(to: result ? .ready : .error)
            _lock_fetchStatusDidAppear.toggle()
        }
    }
    
    @MainActor
    func reloadArticles() async {
        logger.log("call \(#function)")
        do {
            pages = 1
            let newArticles = try await newsAPILoader.loadArticlesRequest(
                q: query,
                pageSize: 10,
                page: pages)
            pages += 1
            articles = newArticles
        } catch {
            logger.log("\(#function) - \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadNextArticles() async -> Bool {
        logger.log("call \(#function)")
        do {
            let nextArticles = try await newsAPILoader.loadArticlesRequest(
                q: query,
                pageSize: 10,
                page: pages)
            pages += 1
            articles.append(contentsOf: nextArticles)
            return true
        } catch {
            logger.log("\(#function) - \(error.localizedDescription)")
            return false
        }
    }
}
