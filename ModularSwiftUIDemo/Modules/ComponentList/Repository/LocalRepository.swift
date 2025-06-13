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


final class LocalRepository: ComponentDataSource {

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
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(LegalPrivacyData.self, from: data)
        } catch let decodingError as DecodingError {
            throw LocalDataError.decodingFailed(decodingError)
        } catch {
            throw LocalDataError.unknown(error)
        }
    }

}
