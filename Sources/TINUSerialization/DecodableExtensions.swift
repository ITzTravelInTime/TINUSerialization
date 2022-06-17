/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021-2022 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public extension FastDecodable where Self:GenericDecodable{
    init?(fromJSONSerializedString string: String){
        
        guard let data = string.data(using: .utf8) else{
            debug("Can't convert the string into valid utf8 data")
            return nil
        }
        
        do{
            guard let arr = try JSONSerialization.jsonObject(with: data, options: []) as? Self else{
                debug("Can't convert JSON data into a valid instance")
                return nil
            }
            
            self = arr
        }catch let err{
            debug("Can't decode JSON data into a valid instance, error: \(err.localizedDescription)")
            return nil
        }
    }
    
    init?(fromPlistSerialisedString string: String){
        guard let data = string.data(using: .utf8) else{
            debug("Can't convert the string into valid utf8 data")
            return nil
        }
        
        do{
            guard let arr = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? Self else{
                debug("Can't convert Plist data into a valid instance")
                return nil
            }
            
            self = arr
        }catch let err{
            debug("Can't decode Plist data into a valid instance, error: \(err.localizedDescription)")
            return nil
        }
    }
    
    init?(fromSerializedString string: String){
        if let json = Self.init(fromJSONSerializedString: string){
            self = json
        }else if let plist = Self.init(fromPlistSerialisedString: string){
            self = plist
        }else{
            return nil
        }
    }
}


public extension FastDecodable where Self: Decodable{
    
    /**
     Initializes the current class from a string containg JSON serialized data.
     
     - Parameter fromJSONSerialisedString: The `String` containing JSON encoded data to be used for the initialization.
     */
    init?(fromJSONSerializedString string: String){
        
        if string.isEmpty{
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let data = string.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch let err{
            debug("Error while decoding json decodable \(err.localizedDescription)")
            return nil
        }
    }
    
    /**
     Initializes the current class from a string containg Plist (Property list) serialized data.
     
     - Parameter fromPlistSerialisedString: The `String` containing Plist (Property list) encoded data to be used for the initialization.
     */
    init?(fromPlistSerialisedString string: String){
        
        if string.isEmpty{
            return nil
        }
        
        let decoder = PropertyListDecoder()
        
        guard let data = string.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch let err{
            debug("Error while decoding plist decodable \(err.localizedDescription)")
            return nil
        }
    }
    
    /**
     Initializes the current class from a string containing serialized data in either JSON or Plist (Property list) formats.
     
     - Parameter fromSerializedString: The `String` containing serialized data in either JSON or Plist (Property list) formats to be used for the initialization.
     */
    init?(fromSerializedString string: String){
        
        if string.isEmpty{
            return nil
        }
        
        //ineffiecient, there might be a better way
        if let _ = Self.init(fromJSONSerializedString: string){
            self.init(fromJSONSerializedString: string)
        }else if let _ = Self.init(fromPlistSerialisedString: string){
            self.init(fromPlistSerialisedString: string)
        }else{
            return nil
        }
    }
}
