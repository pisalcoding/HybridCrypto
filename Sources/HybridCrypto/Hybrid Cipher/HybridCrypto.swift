//
//  HybridCipher.swift
//  MobileBanking
//
//  Created by Pisal on 6/17/22.
//  Copyright © 2022 WB Finance. All rights reserved.
//

import Foundation

public class HybridCrypto {
    
    private init() { }
    public static let shared = HybridCrypto()
    
    public static func initialize(with configuration: Configuration, publicKeyPlain: String) {
        shared.publicKeyPlain = publicKeyPlain
        shared.configuration = configuration
    }
    
    private var configuration: Configuration = Configuration.defaultCofig
    private var publicKeyPlain: String?
    
    private lazy var aesCipher: AESCipher = {
        AESCipher(aesKeySizeInBytes: configuration.aesKeySize,
                  aesMode: configuration.aesMode,
                  keyIterationCount: configuration.aesKeyIterationCount)
    }()
    
    private lazy var rsaCipher: RSACipher = {
        RSACipher(plainPublicKey: publicKeyPlain!,
                  padding: configuration.rsaPadding)
    }()
    
    
    /// Apply AES + RSA Encryption mechanism to the request param
    /// - Parameter message: raw message
    public func encrypt(message: String) throws -> HybridCipherResult {
        guard publicKeyPlain != nil else { throw fatalError("Public key is not provided! Make sure you called initialize().") }
        
        // AES operation
        let requestPassword = randomizeAESPassword()
        let responsePassword = randomizeAESPassword()
        let aesObj = aesCipher.encrypt(password: requestPassword, message: message)
        
        // Signature
        let signature = rsaCipher.encrypt(content: message.sha512)
        
        // RSA
        let encryptedReqKey = rsaCipher.encrypt(content: requestPassword)
        let encryptedResKey = rsaCipher.encrypt(content: responsePassword)
        let iv = rsaCipher.encrypt(content: aesObj.iv)
        let salt = rsaCipher.encrypt(content: aesObj.salt)
        
        let params = HttpFriendlyResult(
            requestPassword: encryptedReqKey,
            iv: iv,
            salt: salt,
            responsePassword: encryptedResKey,
            encryptedData: aesObj.encodedData,
            signature: signature
        )
        
        return HybridCipherResult(rawResponsePassword: responsePassword, httpParams: params)
    }
    
    private func randomizeAESPassword() -> String {
        let length = 16
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString.toBase64()
    }
}

public  struct Configuration {
    var aesKeySize: Int
    var aesMode: String
    var aesKeyIterationCount: Int
    var rsaPadding: SwiftyPadding
    
    static let defaultCofig = Configuration(
        aesKeySize: DEFAULT_AES_KEY_SIZE,
        aesMode: DEFAULT_AES_MODE,
        aesKeyIterationCount: DEFAULT_AES_KEY_ITERATION_COUNT,
        rsaPadding: DEFAULT_RSA_PADDING
    )
    
    static let DEFAULT_AES_KEY_SIZE = 16 // Bytes
    static let DEFAULT_AES_KEY_ITERATION_COUNT = 100 // Rounds
    static let DEFAULT_RSA_PADDING = SwiftyPadding.PKCS1
    static let DEFAULT_AES_MODE = "AES/CBC/PKCS7Padding"
}
