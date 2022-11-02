import Foundation

final class HTTPClient<T: ApiRequest> {
    private let apiRequest: T
    private let urlSession: URLSession
    
    init(apiRequest: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    func loadRequest(_ completion: @escaping (Result<T.ResponseDataType, T.ErrorDataType>) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest()
            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    let errorObject = self.validateError(error, data: nil)
                    completion(.failure(errorObject))
                } else if let data = data, let response = response as? HTTPURLResponse {
                    self.validateResponse(response, data: data, completion: completion)
                } else {
                    let parsedError = self.apiRequest.parseError(data: nil, error: ServiceError.parseError)
                    completion(.failure(parsedError))
                }
            }
            task.resume()
        } catch {
            let errorObject = self.validateError(error, data: nil)
            completion(.failure(errorObject))
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse,
                                  data: Data,
                                  completion: @escaping (Result<T.ResponseDataType, T.ErrorDataType>) -> Void ) {
        switch response.statusCode {
        case 200...299:
            #if DEBUG
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(jsonData)
            } catch {
                print(error)
            }
            #endif
            do {
                let parsedResponse = try self.apiRequest.parseResponse(data: data)
                completion(.success(parsedResponse))
            } catch {
                let errorObject = self.validateError(error, data: nil)
                completion(.failure(errorObject))
            }
        default:
            let errorObject = self.validateError(nil, data: data)
            completion(.failure(errorObject))
        }
    }
    
    private func validateError(_ error: Error?, data: Data?) -> T.ErrorDataType {
        return self.apiRequest.parseError(data: data, error: error)
    }
}
