import Foundation

public protocol ApiRequest {
    associatedtype ResponseDataType
    associatedtype ErrorDataType: Error
    
    func makeRequest() throws ->  URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
    func parseError(data: Data?, error: Error?) -> ErrorDataType
}

extension ApiRequest {
    
    public func parseError(data: Data?, error: Error?) -> ErrorObject {
        if let data = data {
            do {
                // To check if the data is json serializable
                _ = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return try JSONDecoder().decode(ErrorObject.self, from: data)
            } catch {
                let errorObject = ErrorObject(errorCode: .defaultError, message: error.localizedDescription)
                return errorObject
            }
        } else {
            let errorObject = ErrorObject(errorCode: .defaultError, message: error?.localizedDescription)
            return errorObject
        }
    }
}

public var defaultHeaders: [String: String] {
    return [
        "Content-Type": "application/json"
    ]
}

public enum RequestError: Error, Equatable {
    case malformedURL
    case unparseableJSON
    case unacceptableStatusCode(code: Int)
}
