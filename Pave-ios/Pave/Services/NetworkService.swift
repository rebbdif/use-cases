import Foundation


enum NetworkServiceError: ErrorWithDescription {
	case networkError(description: String)
	case codeNot200(code: Int)
	
	var errorDescription: String? {
		switch self {
		case .networkError(let description):
			return "Network Error: \(description)"
		case .codeNot200(let code):
			return "Network Error. Code \(code)"
		}
	}
}

class NetworkService {
	
	enum Method: String {
		case recurringExpenditures = "recurring_expenditures"
	}
	
	var token: String {
		return "jrEd8yahWl4JXpgKIY1LAJHAyJ2sN4soF48AWsUz"
	}
	
	var baseURL: String = "https://api.pave.dev/v1"

	var userId: String = "user_294"
	
	typealias NetworkServiceCompletion = (Result<Data, NetworkServiceError>) -> ()
	
	func performRequest(_ request: NetworkService.Method, completion: @escaping NetworkServiceCompletion) {
		let url = URL(string: "\(baseURL)/\(Method.recurringExpenditures.rawValue)")!
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue(token, forHTTPHeaderField: "x-api-key")
		request.httpBody =  try? JSONSerialization.data(withJSONObject: ["user_id": userId], options: .prettyPrinted)
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard let response = response as? HTTPURLResponse else {
				completion(.failure(.networkError(description: "No network")))
				return
			}
			if let data = data, response.statusCode == 200 {
				completion(.success(data))
			} else if let error = error {
				completion(.failure(.networkError(description: error.localizedDescription)))
			} else {
				completion(.failure(.codeNot200(code: response.statusCode)))
			}
		}
		
		task.resume()
	}
}
