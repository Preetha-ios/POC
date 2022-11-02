import UIKit

public protocol APIServiceType {
    func fetchPicOfDay(completion: @escaping (Result<PlanetaryAPOD, ErrorObject>) -> Void)
    
    func fetchPics(from start_date: String?,
                   end_date: String?,
                   completion: @escaping (Result<[PlanetaryAPOD], ErrorObject>) -> Void)
}

public final class APIServices: APIServiceType {
    
    var urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func fetchPicOfDay(completion: @escaping (Result<PlanetaryAPOD, ErrorObject>) -> Void) {
        let request = PicOfDayRequest()
        
        let client = HTTPClient(apiRequest: request, urlSession: urlSession)
        
        client.loadRequest { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchPics(from start_date: String? = nil,
                          end_date: String? = nil,
                          completion: @escaping (Result<[PlanetaryAPOD], ErrorObject>) -> Void) {
        let request = PicsRequest(start_date: start_date,
                                  end_date: end_date,
                                  thumbs: true)
        
        let client = HTTPClient(apiRequest: request, urlSession: urlSession)
        
        client.loadRequest { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
