//
//  ErrorModel.swift
//  DS-New
//
//  Created by Eugeniy on 07.04.2021.
//

import Foundation

final class ErrorModel: Error {
    
    // MARK: - Properties
    
    var code: Int
    var messageKey: String
    var message: String {
        return description.isEmpty ? messageKey : description
    }
    
    private var description = ""
    
    init(_ messageKey: String, code: Int = -1) {
        self.messageKey = messageKey
        self.code = code
    }
    
    init(_ error: Error) {
        if let message = error.asAFError?.errorDescription {
            self.messageKey = message
        } else {
            self.messageKey = error.localizedDescription
        }
        code = -1
    }
    
    convenience init(_ statusCode: Int?) {
        let message: String
        switch statusCode {
        case 401:
            message = ErrorKey.authenticationError.rawValue
        case 403:
            message = ErrorKey.accessDenied.rawValue
        case 404:
            message = ErrorKey.serverUnacceptable.rawValue
        case 409:
            message = ErrorKey.conflict.rawValue
        case 412:
            message = ErrorKey.conflict.rawValue
        case 500:
            message = ErrorKey.internalServerError.rawValue
            
        case 501:
            message = ErrorKey.badRequest.rawValue
        case 600:
            message = ErrorKey.timeOut.rawValue
        case nil:
            message = ErrorKey.timeOut.rawValue
        default:
            message = ErrorKey.general.rawValue
        }
        self.init(message, code: statusCode ?? -1)
    }
}

// MARK: - Public Functions

extension ErrorModel {
    
    func set(description: String) {
        self.description = description
    }
    
}

enum ErrorKey: String {
    case general = "Error.General"
    case serverUnacceptable = "Error.ServerUnacceptable"
    case parsing = "Error.Parsing"
    case deserialisig = "Error.Deserialising"
    case accessDenied = "Error.AccessDenied"
    case authenticationError = "Error.Auth"
    case badRequest = "Error.BadRequest"
    case outdated = "Error.Outdated"
    case parameterEncodingFailed = "Error.Serialising"
    case internalServerError = "Error.InternalServerError"
    case conflict = "Error.Conflict"
    case timeOut = "Error.TimeOut"
    case noToken = "Error.NoToken"
    case noInternet = "Error.Internet"
}
