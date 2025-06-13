//
//  DecorderService.swift
//  ModularSwiftUIDemo
//
//  Created by gagan joshi on 2025-06-11.
//
import Foundation

protocol DecoderService {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

final class JSONDecoderService : DecoderService  {
    
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            let message: String
            switch decodingError {
            case .typeMismatch(let type, let context):
                message = "Type '\(type)' mismatch: \(context.debugDescription) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .valueNotFound(let type, let context):
                message = "Value '\(type)' not found: \(context.debugDescription) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .keyNotFound(let key, let context):
                message = "Key '\(key.stringValue)' not found: \(context.debugDescription) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            case .dataCorrupted(let context):
                message = "Data corrupted: \(context.debugDescription) at \(context.codingPath.map(\.stringValue).joined(separator: "."))"
            @unknown default:
                message = "Unknown decoding error"
            }
            
            throw NetworkError.decodingFailed(NSError(domain: "Decoding", code: -1, userInfo: [
                NSLocalizedDescriptionKey: message
            ]))
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    
}

