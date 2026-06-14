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
        let method = request.httpMethod ?? "GET"
        let url = LogRedaction.sanitizedURL(request.url)

        AppLogger.network.debug("Request started method=\(method, privacy: .public) url=\(url, privacy: .public)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            AppLogger.network.error("Request failed url=\(url, privacy: .public) error=\(error.localizedDescription, privacy: .public)")
            throw NetworkError.clientError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            AppLogger.network.error("Invalid response url=\(url, privacy: .public)")
            throw NetworkError.invalidResponse(-1, "Invalid Status Code")
        }

        let summary = LogRedaction.responseSummary(statusCode: httpResponse.statusCode, byteCount: data.count)
        AppLogger.network.info("Response received url=\(url, privacy: .public) \(summary, privacy: .public)")
        LogRedaction.logFullResponseBodyIfEnabled(data, url: url, statusCode: httpResponse.statusCode)

        guard (200...299).contains(httpResponse.statusCode) else {
            LogRedaction.logFullResponseBodyForDebugging(
                data, url: url, statusCode: httpResponse.statusCode, reason: "HTTP error"
            )
            AppLogger.network.error("HTTP error url=\(url, privacy: .public) \(summary, privacy: .public)")
            let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            throw NetworkError.invalidResponse(httpResponse.statusCode, message)
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            AppLogger.network.debug("Decode succeeded url=\(url, privacy: .public) type=\(String(describing: T.self), privacy: .public)")
            return decoded
        } catch {
            LogRedaction.logFullResponseBodyForDebugging(
                data, url: url, statusCode: httpResponse.statusCode, reason: "decode failed"
            )
            AppLogger.network.error("Decode failed url=\(url, privacy: .public) \(summary, privacy: .public) error=\(error.localizedDescription, privacy: .public)")
            throw error
        }
    }
}
