import XCTest
@testable import NASAAstronomy

public class APIServiceTests: XCTestCase {
    var service: APIServiceType!
    
    func mockSession() -> URLSession {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return session
    }
    
    public override func setUpWithError() throws {
        service = APIServices(urlSession: mockSession())
    }
    
    func test_fetchPics_success() {
        let exp = expectation(description: "expectation")
        
        let json = "[{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}]".data(using: .utf8)!
        let response = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolStub.stub(data: json, response: response, error: nil)
        
        service.fetchPics(from: "", end_date: "") { result in
            switch result {
            case .success(let response):
                XCTAssertTrue(response[0].title == "title")
            case .failure(_):
                XCTFail("Expected value but got error instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_fetchPicOfDay_success() {
        let exp = expectation(description: "expectation")
        
        let json = "{\"explanation\": \"explanation\", \"date\": \"date\", \"hdurl\": \"hdUrl\", \"title\": \"title\", \"url\": \"url\"}".data(using: .utf8)!
        let response = HTTPURLResponse(url: makeURL(), statusCode: 200, httpVersion: nil, headerFields: nil)
        
        URLProtocolStub.stub(data: json, response: response, error: nil)
        
        service.fetchPicOfDay { result in
            switch result {
            case .success(let response):
                XCTAssertTrue(response.title == "title")
            case .failure(_):
                XCTFail("Expected value but got error instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
