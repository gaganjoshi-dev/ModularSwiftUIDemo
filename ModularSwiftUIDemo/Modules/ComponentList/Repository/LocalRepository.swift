//
//  LocalRepository.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-05.
//

import Foundation

enum LocalDataError: Error {
    case fileNotFound
    case invalidData
    case decodingFailed(Error)
    case unknown(Error)
}

extension LocalDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Local content file not found."
        case .invalidData:
            return "Local content could not be read."
        case .decodingFailed:
            return "Failed to parse local content."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class LocalRepository: ComponentDataSource {

    private let decoderService: DecoderService

    init(decoderService: DecoderService = JSONDecoderService()) {
        self.decoderService = decoderService
    }

    func fetchComponents() async throws -> LegalPrivacyData {
        guard let url = Bundle.main.url(forResource: "LegalPrivacyLocal", withExtension: "json") else {
            throw LocalDataError.fileNotFound
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw LocalDataError.invalidData
        }

        do {
            return try decoderService.decode(LegalPrivacyData.self, from: data)
        } catch let error as NetworkError {
            throw LocalDataError.decodingFailed(error)
        } catch {
            throw LocalDataError.unknown(error)
        }
    }
}
