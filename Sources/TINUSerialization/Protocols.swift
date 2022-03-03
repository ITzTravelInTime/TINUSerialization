//
//  File.swift
//  
//
//  Created by Pietro Caruso on 24/11/21.
//

import Foundation
import TINURecovery

///Protocol for objects to implement basic json/plist deserialization features.
public protocol ExternallyDecodable{
    init?(fromJSONSerializedString string: String)
    init?(fromPlistSerializedString string: String)
    init?(fromSerializedString string: String)
}

///Protocol for objects to implement simple encoding functions for plist and json.
public protocol FastEncodable{
    func plist() -> String?
    func json() -> String?
}

public protocol ExternallyFastCodable: ExternallyDecodable, FastEncodable{}

public protocol GenericDecodable: ExternallyDecodable{}

public protocol GenericEncodable: FastEncodable{}

public protocol GenericCodable: GenericEncodable & GenericDecodable{}


