import Foundation

public struct PicsRequest: ApiRequest {
    
    private var start_date: String?
    private var end_date: String?
    private var thumbs: Bool
    var urlString: String = Endpoints.apod.urlString
    
    public init(start_date: String?, end_date: String?, thumbs: Bool) {
        self.start_date = start_date
        self.end_date = end_date
        self.thumbs = thumbs
    }
    
    public func makeRequest() throws -> URLRequest {
        guard let url =  URL(string: urlString) else {
            throw RequestError.malformedURL
        }

        var urlComponents = URLComponents(string: urlString)
        let params = [URLQueryItem(name: "api_key", value: "DEMO_KEY"),
                      URLQueryItem(name: "start_date", value: start_date),
                      URLQueryItem(name: "end_date", value: end_date)]
        urlComponents?.queryItems = params
        
        var request = URLRequest(url: urlComponents?.url ?? url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
    
    public func parseResponse(data: Data) throws -> [PlanetaryAPOD] {
        return try JSONDecoder().decode([PlanetaryAPOD].self, from: data)
    }
}
