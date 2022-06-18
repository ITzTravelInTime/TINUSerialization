/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

///Protocol for objects to implement basic json/plist deserialization features.
public protocol FastDecodable{
    init?(fromJSONSerializedString string: String)
    init?(fromPlistSerialisedString string: String)
    init?(fromSerializedString string: String)
}

///Protocol for objects to implement simple encoding functions for plist and json.
public protocol FastEncodable{
    func plist() -> String?
    func json() -> String?
}

public protocol FastCodable: FastDecodable, FastEncodable{}

public protocol GenericDecodable{}

public protocol GenericEncodable{}

public protocol GenericCodable: GenericEncodable & GenericDecodable{}


