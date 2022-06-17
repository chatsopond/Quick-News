//
//  SearchResult.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 14/6/2565 BE.
//

import SwiftUI

struct SearchResult: View {
    @State var isPresentedContent = false
    let article: Article
    var body: some View {
        Text(article.title ?? "Untitled")
            .lineLimit(1)
            .contentShape(Rectangle())
            .onTapGesture {
                isPresentedContent = true
            }
            .sheet(isPresented: $isPresentedContent) {
                NavigationView {
                    NewsDetail(article: article)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button {
                                    isPresentedContent = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                }
            }
    }
}

struct SearchResult_Previews: PreviewProvider {
    static var previews: some View {
        SearchResult(article: .sampleArticle)
    }
}
