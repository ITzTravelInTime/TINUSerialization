/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation

public extension Encodable{
    /**
     Gets the current object encoded as a JSON string.
     
     - Parameter usingFormatting: Use this parameter to change the readbility of the printed string.
     
     - Returns: A `String?` containing the current object encoded using the JSON format. `nil` will be returned if the encoding process fails.
     */
    func json(usingFormatting formatting: JSONEncoder.OutputFormatting! = nil) -> String?{
        let encoder = JSONEncoder()
        
        if let f = formatting{
            encoder.outputFormatting = f
        }
        
        var str: String?
        
        do{
            str = try String(data: encoder.encode(self), encoding: .utf8)
        }catch{
            return nil
        }
        
        return str
    }
    
    /**
     Gets the current object encoded as a Plist (Property list) string.
     
     - Returns: A `String?` containing the current object encoded using the Plist (Property list) format. `nil` will be returned if the encoding process fails
     */
    func plist() -> String?{
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        var str: String?
        
        do{
            str = try String(data: encoder.encode(self), encoding: .utf8)
        }catch{
            return nil
        }
        
        return str
    }
}
