//
//  Article.swift
//  Quick News Tests
//
//  Created by Chatsopon Deepateep on 13/6/2565 BE.
//

import Foundation

struct Article: Decodable, Identifiable, Equatable {
    
    // Raw Content
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    /// Identifiable logic
    var id: String {
        return (publishedAt ?? "") + (title ?? "")
    }
    
    /// Equatable logic
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ArticleSource: Decodable {
    let id: String?
    let name: String?
}

// MARK: - Conversion

extension Article {
    var publishedDate: Date? {
        guard let publishedAt = publishedAt else { return nil }
        return try? Date(publishedAt, strategy: .iso8601)
    }
    
    var imageUrl: URL? {
        guard let urlToImage = urlToImage else { return nil }
        return URL(string: urlToImage)
    }
}

// MARK: - Preview

//#if DEBUG

extension Article {
    public static var sampleArticle: Article = {
        Article(
            source: ArticleSource(id: "apple", name: "Apple"),
            author: "Alex Bender, Katie Clark Alsadder, Apple Media Helpline",
            title: "Apple provides developers with even more powerful technologies to push the app experience forward",
            description: "New APIs offer deeper platform integration and greater capabilities for third-party apps",
            url: "https://www.apple.com/newsroom/2022/06/apple-provides-developers-with-even-more-powerful-technologies/",
            urlToImage: "https://www.apple.com/newsroom/images/live-action/wwdc-2022/Apple-WWDC22-developer-tools-hero-220606_big.jpg.large_2x.jpg",
            publishedAt: "2022-06-06T01:00:00+01:00",
            content: "CUPERTINO, CALIFORNIA – Apple today unveiled new tools, technologies, and APIs designed to help developers create even richer experiences for their users. Widgets on the Lock Screen enable developers to surface key information from their apps in a new way, while other new APIs across Apple’s platforms help them build more unique features. WeatherKit gives developers the ability to integrate Apple Weather forecast data directly into their apps, and Xcode Cloud — Apple’s continuous integration and delivery service built into Xcode — is now available to every Apple Developer Program member to help them create higher-quality apps, faster. Metal 3 enables gaming developers to create breathtaking graphics with accelerated performance, and developing for Apple’s platforms is now even more intuitive with improvements to Swift, SwiftUI, and Xcode. And with improvements to SKAdNetwork, ad networks and developers can better measure how ads perform while still preserving user privacy.")
    }()
    
    public static var sampleArticle2: Article = {
        Article(
            source: ArticleSource(id: "apple", name: "Apple"),
            author: "Starlayne Meza, Katie Michelle Del Rio, Apple Media Helpline",
            title: "Apple unveils all-new MacBook Air, supercharged by the new M2 chip",
            description: "MacBook Air features a new, strikingly thin design in four beautiful finishes, larger 13.6-inch Liquid Retina display, 1080p HD camera, MagSafe charging, and more",
            url: "https://www.apple.com/newsroom/2022/06/apple-unveils-all-new-macbook-air-supercharged-by-the-new-m2-chip/",
            urlToImage: "https://www.apple.com/newsroom/images/product/mac/standard/Apple-WWDC22-MacBook-Air-hero-220606_big.jpg.large_2x.jpg",
            publishedAt: "2022-06-06T01:00:00+01:00",
            content: "CUPERTINO, CALIFORNIA – Apple today introduced a completely redesigned MacBook Air and an updated 13-inch MacBook Pro, both powered by the new M2 chip — which takes the breakthrough performance and capabilities of M1 even further. MacBook Air takes everything users love about the world’s best-selling laptop to the next level. With an all-new, strikingly thin design and even more performance, MacBook Air also features a larger 13.6-inch Liquid Retina display, a 1080p FaceTime HD camera, four-speaker sound system, up to 18 hours of battery life,1 and MagSafe charging. It is now available in four finishes — silver, space gray, midnight, and starlight. M2 also comes to the 13-inch MacBook Pro, the world’s second best-selling laptop — delivering incredible performance, up to 24GB of unified memory, ProRes acceleration, and up to 20 hours of battery life,2 all in a compact design. The new MacBook Air and updated 13-inch MacBook Pro join the even more powerful 14- and 16-inch MacBook Pro with M1 Pro and M1 Max to round out the strongest lineup of Mac notebooks ever offered. Both laptops will be available next month. ")
    }()
}



//#endif
