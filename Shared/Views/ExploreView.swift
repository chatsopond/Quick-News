//
//  ExploreView.swift
//  Quick News
//
//  Created by Chatsopon Deepateep on 13/6/2565 BE.
//

import SwiftUI
import os

struct ExploreView: View {
    
    @Environment(\.isSearching) private var isSearching
    @StateObject var viewModel = ExploreViewModel()
    @State var searchText = ""
    
    var body: some View {
        scrollNews
            .navigationTitle("News")
            .background(Color.background2.ignoresSafeArea())
            .onAppear {
                viewModel.loadNewArticlesFromQuery()
            }
            .searchable(text: $searchText) {
                SearchView(searchText: $searchText)
            }
            .onSubmit(of: .search) {
                viewModel.query = searchText.isEmpty ? ExploreViewModel.defaultQuery : searchText
                viewModel.loadNewArticlesFromQuery(forced: true)
            }
            .onChange(of: searchText) { value in
                if searchText.isEmpty && !isSearching {
                    // Cancel Search
                    viewModel.query = ExploreViewModel.defaultQuery
                    viewModel.loadNewArticlesFromQuery(forced: true)
                }
            }
    }
    
    var scrollNews: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.articles) { article in
                    NavigationLink {
                        NewsDetail(article: article)
                    } label: {
                        NewsCard(article: article)
                    }
                    .buttonStyle(FlatLinkStyle())
                }
                fetchStatus
                    .onAppear {
                        viewModel.fetchStatusDidAppear()
                    }
            }
        }
    }
    
    @ViewBuilder
    var fetchStatus: some View {
        switch viewModel.fetchState {
        case .error:
            VStack {
                Text("Could not load the articles")
                Button("Try Again") {
                    viewModel.updateFetchState(to: .ready)
                    viewModel.fetchStatusDidAppear()
                }
                .font(.body.weight(.semibold))
            }
            .padding()
        case .fetching:
            ProgressView()
        default:
            ProgressView()
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
    }
}
