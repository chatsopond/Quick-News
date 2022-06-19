# Quick-News

- Users can see the list of news
  - Fetch 10 news per API request and display it
- Users can tap the news on the list to see news detail
- Users can see loading and error UI
- Users can search the news by keyword
  - Debounced ~1 second before performing a search while users type keywords

## Note

You may need to change the `apiKey` at [NewsAPIRequestLoader.swift](Shared/NewsAPI/NewsAPIRequestLoader.swift) 

## Development Info

- Xcode Version 13.4.1 (13F100)

## Demo

![demo](demo-news.gif)
