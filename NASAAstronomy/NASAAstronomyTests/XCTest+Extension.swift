
import XCTest

extension XCTestCase {
    
    func makeURL(_ string: String = "https://some-url.com") -> URL {
      guard let url = URL(string: string) else {
        preconditionFailure("Could not create URL for \(string)")
      }
      return url
    }
    
    func makeError(_ str: String = "uh oh, something went wrong") -> NSError {
        return NSError(domain: "TEST_ERROR", code: -1, userInfo: nil)
    }
    
    func checkForMemoryLeaks(_ instance: AnyObject) {
      addTeardownBlock { [weak instance] in
        XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.")
      }
    }
}
