//
//  SearchView.swift
//  Quick News
//
//  Created by Chatsopon Deepateep on 14/6/2565 BE.
//

import SwiftUI
import Combine
import os

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @Binding var searchText: String
    
    var body: some View {
        ForEach(viewModel.articles) { article in
            if article.title != nil {
                SearchResult(article: article)
            }
        }
        .onChange(of: searchText) { newValue in
            viewModel.search(query: searchText)
        }
        .onAppear {
            viewModel.search(query: searchText)
        }
    }
}

enum SearchState {
    case ready, busy
}

@MainActor
class SearchViewModel: ObservableObject {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                        category: String(describing: SearchViewModel.self))
    let newsAPILoader = NewsAPIRequestLoader()
    
    @Published var articles: [Article] = []
    
    let queue = DispatchQueue(label: String(describing: SearchViewModel.self))
    var deboucedSearch = PassthroughSubject<Void, Never>()
    var searchCancellable: AnyCancellable?
    var searchPreviousTask: Task<Void, Never>?
    func search(query: String) {
        searchCancellable = deboucedSearch
            .timeout(
                .seconds(0.8),
                scheduler: queue)
            .sink(receiveCompletion: { [weak self] _ in
                // Debouced
                // Start call search
                self?.searchPreviousTask?.cancel()
                self?.searchPreviousTask = Task {
                    await self?.reloadArticles(query: query)
                }
            }, receiveValue: { _ in
                // Nothing to do
            })
    }
    
    @MainActor
    func reloadArticles(query: String) async {
        logger.log("call \(#function)")
        do {
            let newArticles = try await newsAPILoader.loadArticlesRequest(q: query, pageSize: 100, page: 1, sortBy: "relevancy")
            guard !Task.isCancelled else {
                logger.log("cancel search: \(query) ,\(#function)")
                return
            }
            articles = newArticles
        } catch {
            logger.log("\(#function) - \(error.localizedDescription)")
        }
    }
}
