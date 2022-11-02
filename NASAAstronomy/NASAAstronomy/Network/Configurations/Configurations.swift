import Foundation

public enum Environment: String {
    case production, staging, local
    
    public var baseUrl: String {
        switch self {
        default:
            return "https://api.nasa.gov/planetary/"
        }
    }
}

public enum Endpoints: String {
    
    case apod
    
    var path: String {
        switch self {
        case .apod:
            return "apod"
        }
    }
    
    public var urlString: String {
        return Configuration.environment.baseUrl + self.path
    }
}

public class Configuration {
    public static var environment: Environment = .production
}
