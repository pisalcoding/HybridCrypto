//
//  HttpFriendlyResult.swift
//  
//
//  Created by Pisal on 8/19/22.
//

import Foundation

public struct HttpFriendlyResult : Codable {
    /// RSA-encrypted AES password of request body
    public let requestPassword: String

    /// IV that was used while encrypting the raw data
    public let iv: String
    
    /// salt that was used while encrypting the raw data
    public let salt: String

    /// RSA-encrypted AES password for peer/server to encrypt the response
    public let responsePassword: String

    /// AES-encrypted data
    public let encryptedData: String

    /// RSA-encrypted SHA512 hash of the raw data
    public let signature: String
    
    enum CodingKeys: String, CodingKey {
        case requestPassword
        case iv
        case salt
        case responsePassword
        case encryptedData
        case signature
    }
}
