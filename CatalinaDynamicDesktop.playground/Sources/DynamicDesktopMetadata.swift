import Foundation
import AppKit

public struct DynamicDesktopMetadata {
    public init() { }
    
    public func base64EncodedMetadata() throws -> String {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        
        let binaryPropertyListData = try encoder.encode(self)
        return binaryPropertyListData.base64EncodedString()
    }
}

extension DynamicDesktopMetadata: Encodable {
    private enum CodingKeys: String, CodingKey {
        case d, l
    }
    
    public func encode(to encoder: Encoder) throws {
        var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
        try keyedContainer.encode(0, forKey: .l)
        try keyedContainer.encode(1, forKey: .d)
    }
}
