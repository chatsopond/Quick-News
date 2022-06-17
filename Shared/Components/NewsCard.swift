//
//  NewsCard.swift
//  Quick News
//
//  Created by Chatsopon Deepateep on 13/6/2565 BE.
//

import SwiftUI

struct NewsCard: View {
    
    let article: Article
    
    var publishedDate: String {
        if let date = article.publishedDate {
            return "\(dateFormatter.string(from: date))"
        }
        return ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .frame(height: 200)
                .foregroundColor(.clear)
                .background(
                    AsyncRemoteImage(url: article.imageUrl)
                )
                .clipped()
            VStack(alignment: .leading, spacing: 8) {
                Color.clear.frame(height: 1)
                Text(article.title ?? "Untitlied")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.primary)
                Text(article.description ?? "No Description")
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .foregroundColor(.primary)
                Text(publishedDate)
                    .padding(.top, 20)
                    .foregroundColor(.secondary)
                    .font(.subheadline.weight(.semibold))
            }
            .padding()
            .background(Color.backgroundCard)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

struct NewsCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background2
                .ignoresSafeArea()
            NewsCard(article: .sampleArticle)
        }
        .preferredColorScheme(.light)
    }
}
