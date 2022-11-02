import XCTest
@testable import NASAAstronomy

class HTTPClientTests: XCTestCase {
    
    func test_on_loadRequest_fails_with_error() {
        let error = makeError()
        let receivedError = resultErrorFor(data: nil, response: nil, error: error)! as ErrorObject
        let receivedErrorCode = receivedError.errorCode
        XCTAssertEqual(receivedErrorCode, .defaultError)
    }
    
    func test_on_loadRequest_success_with_data() {
        let response = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
                
        let json = "[{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}]".data(using: .utf8)!

        let receivedValue = resultValueFor(data: json, response: response, error: nil)!
        XCTAssertEqual(receivedValue[0].title, "title")
    }
    
    func test_on_loadRequest_withNon200Status_failsWithError() {
        let response = HTTPURLResponse(url: makeURL(), statusCode: 400, httpVersion: nil, headerFields: nil)
                
        let json = "[{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}]".data(using: .utf8)!

        let receivedError = resultErrorFor(data: json, response: response, error: nil)
        XCTAssertNotNil(receivedError, "Expected Error but got valid response\(json)")
    }
    
    func test_on_loadRequest_withInvalidResponse_failsWithError() {
        let response = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
                
        let json = "{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}".data(using: .utf8)!

        let receivedError1 = resultErrorFor(data: json, response: response, error: nil)
        XCTAssertNotNil(receivedError1, "Expected Error but got valid response\(json)")
        
        let receivedError2 = resultErrorFor(data: nil, response: response, error: nil)
        XCTAssertNotNil(receivedError2, "Expected Error but got valid response\(json)")
    }
    
    func test_prod_environment_URL() {
        Configuration.environment = .production
        XCTAssert(Configuration.environment.baseUrl == "https://api.nasa.gov/planetary/")
    }
}

extension HTTPClientTests {
    
    func makeSUT() -> HTTPClient<PicsRequest>! {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = HTTPClient(apiRequest: PicsRequest(start_date: "", end_date: "", thumbs: true), urlSession: session)
        checkForMemoryLeaks(sut)
        return sut
    }
    
    func resultErrorFor(data: Data?, response: URLResponse?, error: Error?) -> ErrorObject? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        var receivedError: ErrorObject? = nil
        let exp = expectation(description: "await completion")
        let sut = makeSUT()
        
        sut?.loadRequest { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure but got result instead")
            case .failure(let error):
                receivedError = error
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        return receivedError
    }
    
    func resultValueFor(data: Data?, response: URLResponse?, error: Error?) -> [PlanetaryAPOD]? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        var receivedValue: [PlanetaryAPOD]? = nil
        let exp = expectation(description: "await completion")
        let sut = makeSUT()
        
        sut?.loadRequest { result in
            switch result {
            case .success(let response):
                receivedValue = response
            case .failure(_):
                XCTFail("Expected value but got error instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        return receivedValue
    }
}
