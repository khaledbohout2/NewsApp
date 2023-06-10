import XCTest
import Combine
@testable import NewsApp

final class FetchNewsUseCaseTests: XCTestCase {

    var sut: NewsRepository!
    var newsApiService: NewsAPIServiceMock!
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        newsApiService = NewsAPIServiceMock()
        let countriesLoadingService = CountriesLoader(fileName: "countries", fileType: "json")
        sut = NewsDataRepository(countriesLoadingService: countriesLoadingService,
                                 newsService: newsApiService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchTopHeadLines() throws {
        var result: TopHeadlines?
        var resultError: Error?
        newsApiService.topHeadlines = StubNewsRepositoryResult.tobHeadLine
        let expectation = expectation(description: "Fetch News With success")
        sut.fetchTopHeadlines(with: Country(name: "Canada", iso2: "ca"), category: NewsCategory.allNews)
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                }
            } receiveValue: { news in
                result = news
                expectation.fulfill()
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)

        XCTAssertNil(resultError, "Error is not nil")
        XCTAssertEqual(result?.articles, StubNewsRepositoryResult.tobHeadLine.articles, "Failed loading News")
    }

    func testFetchTopHeadLines_withError() throws {
        var result: TopHeadlines?
        var resultError: Error?
        newsApiService.topHeadlines = StubNewsRepositoryResult.tobHeadLine
        let expectation = expectation(description: "Fetch News With error failed fetch News")
        sut.fetchTopHeadlines(with: Country(name: "Canada", iso2: "ca"), category: NewsCategory.allNews)
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { news in
                result = news
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(resultError)
        XCTAssertNil(result)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

    // MARK: - Stub
    struct StubNewsRepositoryResult {
        static let tobHeadLine = TopHeadlines(status: "", totalResults: 5, articles: [Article(source: Source(id: "google-news", name: "Google News"), author: "MOR-TV.com", title: "\'Keto-like\' diet may be associated with a higher risk of heart disease, according to new research - MOR-TV.com", articleDescription: "", url: "https://news.google.com/rss/articles/CBMiamh0dHBzOi8vd3d3Lm1vci10di5jb20vYXJ0aWNsZS9rZXRvLWxpa2UtZGlldC1tYXktYmUtYXNzb2NpYXRlZC13aXRoLWhpZ2hlci1yaXNrLW9mLWhlYXJ0LWRpc2Vhc2UvNDMyMDIyMjbSAQA?oc=5", urlToImage: nil, publishedAt: Date(), content: nil)])
    }



