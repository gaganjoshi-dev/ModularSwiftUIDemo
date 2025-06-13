//
//  RemoteRepository.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-10.
//
import Foundation


final class RemoteRepository: ComponentDataSource {

    private let networkManager: NetworkManager
    private let apiConfig: APIConfigProtocol

    init(networkManager: NetworkManager = NetworkManager(),
         apiConfig: APIConfigProtocol = APIConfig()) {
        self.networkManager = networkManager
        self.apiConfig = apiConfig
    }
    
    
    func fetchComponents() async throws -> LegalPrivacyData {
        let request = try buildRequest()
        
        do {
            return try await networkManager.executeRequest(request: request)
        } catch let networkError as NetworkError {
            throw ComponentError.networkError(networkError)
        } catch {
            throw ComponentError.unknown(error)
        }
    }

    
    private func buildRequest() throws -> URLRequest {
        guard var components = URLComponents(string: apiConfig.baseURL) else {
            throw ComponentError.invalidURL
        }

        components.path = apiConfig.endpoint
        components.queryItems = [
            URLQueryItem(name: "channel", value: apiConfig.channel),
            URLQueryItem(name: "fileName", value: apiConfig.fileName)
        ]

        guard let url = components.url else {
            throw ComponentError.invalidURL
        }

        guard let apiKey = apiConfig.apiKey, !apiKey.isEmpty else {
            throw ComponentError.missingAPIKey
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: apiConfig.apiKeyHeader)
        return request
    }

}
