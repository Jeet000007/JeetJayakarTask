
import Foundation


enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
}

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {
        NetworkService.createApiDataSuite()
    }
    
    func fetchData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 25.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}

extension NetworkService{
    
    static func saveOfflineData(apiData: String, apiKey: String)  {
        
        UserDefaults.init(suiteName: UserDefaultsKey.apiDataStorage)?.setValue(apiData, forKey: apiKey)
    }
    
    static func getOfflineData(apiKey: String) -> String? {
        if  let offlineApiData = UserDefaults.init(suiteName: UserDefaultsKey.apiDataStorage)?.value(forKey: apiKey) as? String{
            return offlineApiData
        }
        return nil
    }
    
    
   static func createApiDataSuite()  {
        UserDefaults.standard.addSuite(named: UserDefaultsKey.apiDataStorage)
    }
}
