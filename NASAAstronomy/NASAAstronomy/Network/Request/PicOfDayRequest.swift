import Foundation

public struct PicOfDayRequest: ApiRequest {
    var urlString: String = Endpoints.apod.urlString
    
    public func makeRequest() throws -> URLRequest {
        guard let url =  URL(string: urlString) else {
            throw RequestError.malformedURL
        }

        var urlComponents = URLComponents(string: urlString)
        let params = [URLQueryItem(name: "api_key", value: "DEMO_KEY")]
        urlComponents?.queryItems = params
        
        var request = URLRequest(url: urlComponents?.url ?? url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
    
    public func parseResponse(data: Data) throws -> PlanetaryAPOD {
        return try JSONDecoder().decode(PlanetaryAPOD.self, from: data)
    }
}
