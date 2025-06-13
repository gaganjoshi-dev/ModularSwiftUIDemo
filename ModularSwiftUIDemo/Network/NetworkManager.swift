//
//  NetworkManager.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import Foundation

class NetworkManager {
    
    private let session: URLSessionProtocol
    private let decoder: DecoderService
    
    init(session: URLSessionProtocol = URLSession.shared, decoder: DecoderService = JSONDecoderService()) {
        self.session = session
        self.decoder = decoder
    }
    
    func executeRequest<T: Decodable>(request: URLRequest) async throws -> T {
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.clientError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(-1, "Invalid Status Code")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            throw NetworkError.invalidResponse(httpResponse.statusCode, message)
        }
        return try decoder.decode(T.self, from: data)
    }
    
}
