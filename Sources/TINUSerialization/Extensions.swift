/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */


import Foundation
#if !(os(watchOS) || os(Linux) || os(Windows))
import TINURecovery
#endif

public extension FastDecodable{
    
    /**
     Initializes the current class from a local file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromFileAt: The `URL` of the file to be used for initialization (must be either JSON or Plist fromattaed).
     - Parameter usingEncoding: The `String.Encoding` to be used for the interpreatation fo the provvided data.
     */
    init?(fromFileAt url: URL, usingEncoding encoding: String.Encoding = .utf8, descapeCharacters: Bool = false) {
        guard let string = String.init(fromFileAt: url, usingEncoding: encoding, descapeCharacters: descapeCharacters) else{
            debug("Can't retrive string from local file!")
            return nil
        }
        
        self.init(fromSerializedString: string)
    }
    
    /**
     Initializes the current class from a local file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromFileAtPath: The `String` path of the file to be used for initialization (must be either JSON or Plist fromattaed).
     - Parameter usingEncoding: The `String.Encoding` to be used for the interpreatation fo the provvided data.
     */
    init?(fromFileAtPath file: String, usingEncoding encoding: String.Encoding = .utf8, descapeCharacters: Bool = false){
        if file.isEmpty{
            return nil
        }
        
        self.init(fromFileAt: URL(fileURLWithPath: file), usingEncoding: encoding, descapeCharacters: descapeCharacters)
    }
    
    #if !(os(Linux) || os(Windows))
    /**
     Initializes the current class from a remote file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromRemoteFileAt: The `URL` of the remote file to be used for initialization (must be either JSON or Plist fromattaed).
     
     */
    init?(fromRemoteFileAt url: URL, descapeCharacters: Bool = false) {
        
        guard let string = String.init(fromRemoteFileAt: url, descapeCharacters: descapeCharacters) else{
            debug("Can't get remote serialized data")
            return nil
        }
        
        self.init(fromSerializedString: string)
    }
    
    /**
     Initializes the current class from a remote file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromRemoteFileAtUrl: The `String` of the url of the remote file to be used for initialization (must be either JSON or Plist fromattaed).
     
     */
    init?(fromRemoteFileAtUrl url: String, descapeCharacters: Bool = false){
        if url.isEmpty{
            return nil
        }
        
        guard let url = URL(string: url) else{
            debug("Can't get valid URL object from the provvided url string")
            return nil
        }
        
        self.init(fromRemoteFileAt: url, descapeCharacters: descapeCharacters)
    }
    #endif
}

extension FastCodable where Self: Codable{}
extension FastCodable where Self: GenericCodable{}
