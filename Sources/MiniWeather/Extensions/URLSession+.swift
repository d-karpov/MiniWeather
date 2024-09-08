//
//  URLSession+.swift
//  
//
//  Created by Denis on 04.09.2024.
//

import Foundation

//MARK: - NetworkErrors
enum NetworkError: Error, LocalizedError {
	case httpStatusCode(Int)
	case urlRequestError(Error)
	case urlSessionError
	
	var errorDescription: String? {
		switch self {
		case .httpStatusCode(let code):
			return "HTTP Status Code Error - code \(code)"
		case .urlRequestError(let error):
			return "Request Error - \(error.localizedDescription)"
		case .urlSessionError:
			return "URL Session Error"
		}
	}
}
//MARK: - DecoderErrors
enum DecoderError: Error, LocalizedError {
	case decodingError(Error)
	
	var errorDescription: String? {
		switch self {
		case .decodingError(let error):
			guard let error = error as? DecodingError else {
				return "Error while try decode - \(error)"
			}
			switch error {
			case .typeMismatch(let type, let context):
				return "Type mismatch - used \(type) for codingPath:\n\(context.codingPath)"
			case .valueNotFound(let value, let context):
				return "Value - \(value) wasn't found!\nCodingPath: \(context.codingPath)"
			case .keyNotFound(let key, let context):
				return "Key - \(key) wasn't found!\nCodingPath: \(context.codingPath)"
			case .dataCorrupted(let context):
				return "Data corrupted - \(context)"
			@unknown default:
				return "Unknown Decoding error - \(error)"
			}
		}
	}
}

//MARK: - Network methods implementation
extension URLSession {
	static let decoder: JSONDecoder = .init()
	
	func objectTask<T: Decodable>(
		for request: URLRequest,
		completion: @escaping(Result<T, Error>) -> Void
	) -> URLSessionTask {
		let decoder = URLSession.decoder
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let task = data(for: request) { result in
			switch result {
			case .success(let data):
				do {
					let responseBody = try decoder.decode(T.self, from: data)
					completion(.success(responseBody))
				} catch {
					completion(.failure(DecoderError.decodingError(error)))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
		return task
	}
	
	//MARK: Private methods
	private func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
		let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		let task = dataTask(with: request) { data, response, error in
			if
				let data = data,
				let response = response,
				let statusCode = (response as? HTTPURLResponse)?.statusCode
			{
				if 200..<300 ~= statusCode {
					fulfillCompletionOnTheMainThread(.success(data))
				} else {
					fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
				}
			} else if let error = error {
				fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
			} else {
				fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
			}
		}
		
		return task
	}
}
