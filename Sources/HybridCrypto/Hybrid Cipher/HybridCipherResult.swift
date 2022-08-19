//
//  HybridCipherResult.swift
//  
//
//  Created by Pisal on 8/19/22.
//

import Foundation

public struct HybridCipherResult : Codable {
    
    /**
     * Should be saved for decrypting the encrypted response from server
     */
    public let rawResponsePassword: String
    
    /**
     * Suitable for sending to server via REST API
     */
    public let httpParams: HttpFriendlyResult
    
    enum CodingKeys: String, CodingKey {
        case rawResponsePassword
        case httpParams
    }
}
