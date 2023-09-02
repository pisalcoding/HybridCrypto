import Foundation
import CommonCrypto

class RSACipher {
    
    private var plainPublicKey: String!
    private var padding: SwiftyPadding!
    
    init(plainPublicKey: String, padding: SwiftyPadding = .PKCS1) {
        self.plainPublicKey = plainPublicKey
        self.padding = padding
    }
    
    fileprivate lazy var publicKey: SwiftyPublicKey = {
        try! SwiftyPublicKey(base64Encoded: plainPublicKey)
    }()
    
    /**
     * Encrypt plain text with RSA and encode the encrypted with Base64.
     * The RSA public key is usually server's public key.
     */
    func encrypt(content: String) -> String {
        let clear = try! ClearMessage(string: content, using: .utf8)
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        return encrypted.data.toBase64String()
    }
}
