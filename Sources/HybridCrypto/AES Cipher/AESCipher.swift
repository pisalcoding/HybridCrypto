import Foundation
import CommonCrypto

public class AESCipher {
    
    private var aesKeySizeInBytes: Int!
    private var aesMode: String!
    private var keyIterationCount: UInt32!
    
    public init(aesKeySizeInBytes: Int,
         aesMode: String,
         keyIterationCount: Int = 100
    ) {
        self.aesKeySizeInBytes = aesKeySizeInBytes
        self.aesMode = aesMode
        self.keyIterationCount = UInt32(keyIterationCount)
    }
    
    public func encrypt(password: String, message: String) -> AESResult {
        let iv = randomizeBytes(count: kCCBlockSizeAES128)
        let salt = randomizeBytes(count: 8)
        let aesKey = aesKey(forPassword: password, salt: salt)
        let data = message.data(using: .utf8)!
        
        let ciphertext = crypt(
            operation: kCCEncrypt,
            algorithm: kCCAlgorithmAES,
            options: kCCOptionPKCS7Padding,
            key: aesKey,
            initializationVector: iv,
            dataIn: data)
        
        return AESResult(
            salt: salt.toBase64String(),
            iv: iv.toBase64String(),
            encodedData: ciphertext!.toBase64String()
        )
    }
    
    public func decrypt(password: String, salt: Data, iv: Data, base64CipherText: Data) -> NSDictionary {
        let aesKey = aesKey(forPassword: password, salt: salt)
        let decryptedData = crypt(operation: kCCDecrypt,
                                  algorithm: kCCAlgorithmAES,
                                  options: kCCOptionPKCS7Padding,
                                  key: aesKey,
                                  initializationVector: iv,
                                  dataIn: base64CipherText
        )
        
        let str = String(decoding: decryptedData!, as: UTF8.self)
        return str.toDictionary()! as NSDictionary
    }
    
    
    //========================================================================================
    //MARK:- Internal
    //========================================================================================
    private func randomizeBytes(count: Int) -> Data {
        let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 1)
        defer { bytes.deallocate() }
        let status = SecRandomCopyBytes(nil, count, bytes)
        assert(status == kCCSuccess)
        return Data(bytes: bytes, count: count)
    }
    
    private func aesKey(
        forPassword password: String,
        salt: Data
    ) -> Data {
        let derivedKey = NSMutableData(length: aesKeySizeInBytes * 2)!
        let result = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            password,
            password.lengthOfBytes(using: .utf8),
            salt.bytes,
            salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
            self.keyIterationCount,
            derivedKey.mutableBytes,
            derivedKey.length
        )
        assert(result == kCCSuccess)
        return derivedKey.copy() as! Data
    }
    
    private func crypt(
        operation: Int,
        algorithm: Int,
        options: Int,
        key: Data,
        initializationVector iv: Data,
        dataIn: Data
    ) -> Data? {
        return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
            return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                return iv.withUnsafeBytes { ivUnsafeRawBufferPointer in
                    // Give the data out some breathing room for PKCS7's padding.
                    let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128 * 2
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize,
                                                                   alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(
                        CCOperation(operation),
                        CCAlgorithm(algorithm),
                        CCOptions(options),
                        keyUnsafeRawBufferPointer.baseAddress,
                        key.count,
                        ivUnsafeRawBufferPointer.baseAddress,
                        dataInUnsafeRawBufferPointer.baseAddress,
                        dataIn.count,
                        dataOut,
                        dataOutSize,
                        &dataOutMoved
                    )
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}
