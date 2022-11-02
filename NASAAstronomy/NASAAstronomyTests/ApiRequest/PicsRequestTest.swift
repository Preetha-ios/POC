import XCTest
@testable import NASAAstronomy

class PicsRequestTest: XCTestCase {

    var request: PicsRequest!

    override func setUp() {
        super.setUp()
        
        Configuration.environment = .production
        request = PicsRequest(start_date: "", end_date: "", thumbs: true)
    }
    
    func testMakingURLRequest() throws {
        let urlRequest = try request.makeRequest()
        
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.nasa.gov")
    }
    
    func testParsingReponse() throws {
        let json = "[{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}]".data(using: .utf8)!
        
        let response = try request.parseResponse(data: json)
        
        XCTAssertEqual(response[0].title, "title")
    }
    
    func test_request_with_malformedURL_shouldThrowError() {
        let sut = makeSUT()
        let exp = expectation(description: "await completion")

        sut?.loadRequest({ result in
            switch result {
            case .success(_):
                XCTFail("Expected failure but got result instead")
            case .failure(_):
                return  exp.fulfill()
            }
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
    }
}

extension PicsRequestTest {
    func makeSUT() -> HTTPClient<PicsRequest>! {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let request = PicsRequest(start_date: "", end_date: "", thumbs: true)
        let sut = HTTPClient(apiRequest: request, urlSession: session)
        checkForMemoryLeaks(sut)
        return sut
    }
}
