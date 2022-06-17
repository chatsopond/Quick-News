//
//  NewsDetail.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 14/6/2565 BE.
//

import SwiftUI

struct NewsDetail: View {
    
    let article: Article
    
    var body: some View {
        ScrollView {
            Text(article.title ?? "Untitled")
                .font(.title3.weight(.bold))
                .padding()
            VStack(alignment: .leading) {
                AsyncRemoteImage(url: article.imageUrl)
                //.clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(article.content ?? "No Content")
                .padding()
            VStack(alignment: .leading) {
                Color.clear.frame(height: 1)
                if let date = article.publishedDate {
                    Text(dateFormatter.string(from: date))
                        .foregroundColor(.secondary)
                        .font(.subheadline.weight(.semibold))
                }
            }
            .padding()
        }
        .navigationTitle(article.source?.name ?? "Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsDetail(article: .sampleArticle)
        }
    }
}
