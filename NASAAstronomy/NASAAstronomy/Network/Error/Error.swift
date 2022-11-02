import Foundation

public struct ErrorObject: Decodable, Equatable, Error {
    
    public enum ErrorCode: String, Decodable {
        case unknown = "Unknown"
        case defaultError = "Default"
    }
    
    public var errorCode: ErrorCode
    public var message: String?
}

public enum ServiceError: Error {
    case badRequest
    case parseError
    case other(message: String)
    
    public var description: String {
        switch self {
        case .parseError:
            return "Unable to parse the response"
        case .other(let message):
            return message
        default:
            return ""
        }
    }
}
