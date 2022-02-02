/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */


import Foundation
import TINURecovery

public extension ExternallyDecodable{
    
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
}

public extension GenericDecodable{
    init?(fromJSONSerializedString string: String){
        
        guard let data = string.data(using: .utf8) else{
            debug("Can't convert the string into valid utf8 data")
            return nil
        }
        
        do{
            guard let arr = try JSONSerialization.jsonObject(with: data, options: []) as? Self else{
                debug("Can't convert JSON data into valid NSArray")
                return nil
            }
            
            self = arr
        }catch let err{
            debug("Can't decode JSON data into valid NSArray, error: \(err.localizedDescription)")
            return nil
        }
    }
    
    init?(fromPlistSerializedString string: String){
        guard let data = string.data(using: .utf8) else{
            debug("Can't convert the string into valid utf8 data")
            return nil
        }
        
        do{
            guard let arr = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? Self else{
                debug("Can't convert Plist data into valid NSArray")
                return nil
            }
            
            self = arr
        }catch let err{
            debug("Can't decode Plist data into valid NSArray, error: \(err.localizedDescription)")
            return nil
        }
    }
    
    init?(fromSerializedString string: String){
        if let json = Self.init(fromJSONSerializedString: string){
            self = json
        }else if let plist = Self.init(fromPlistSerializedString: string){
            self = plist
        }else{
            return nil
        }
    }
}

public extension GenericEncodable{
    /*
     Gets the current object encoded as a Plist (Property list) string.
     
     - Returns: A `String?` containing the current object encoded using the Plist (Property list) format. `nil` will be returned if the encoding process fails
     */
    func plist() -> String?{
        do{
            let data = try PropertyListSerialization.data(fromPropertyList: self, format: .xml, options: 0)
            
            return String.init(data: data, encoding: .utf8)
        }catch let err{
            debug("Cant convert NSArray to valid Plist data: \(err.localizedDescription)")
            return nil
        }
    }
    
    /**
     Gets the current object encoded as a JSON string.
     
     - Returns: A `String?` containing the current object encoded using the JSON format. `nil` will be returned if the encoding process fails.
     */
    func json() -> String?{
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            
            return String.init(data: data, encoding: .utf8)
        }catch let err{
            debug("Cant convert NSArray to valid JSON data: \(err.localizedDescription)")
            return nil
        }
    }
}

extension String{
    func descapingCharacters() -> Self{
        var cpy = self.replacingOccurrences(of: "\\\"", with: "\"")
        cpy = cpy.replacingOccurrences(of: "\\\\", with: "\\")
        cpy = cpy.replacingOccurrences(of: "\\n", with: "\n")
        cpy = cpy.replacingOccurrences(of: "\\r", with: "\r")
        cpy = cpy.replacingOccurrences(of: "\\0", with: "")
        return cpy
    }
    
    mutating func descapeCharacters(){
        self = self.descapingCharacters()
    }
    
    init?(fromRemoteFileAt url: URL, descapeCharacters: Bool = false){
        if !SimpleReachability.status {
            return nil
        }
        
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)
        
        if let e = error {
            debug("Error while getting the update information from the stored update link: \(e.localizedDescription)")
            return nil
        }
        
        guard let safeResponse = response else{
            debug("Invalid or missing url request response")
            return nil
        }
        
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(NSString(string: safeResponse.textEncodingName ?? "utf8") as CFString)))
        
        guard let safeData = data else{
            debug("Didn't get any remote data!")
            return nil
        }
        
        self.init(data: safeData, encoding: encoding)
        
        if descapeCharacters{
            self.descapeCharacters()
        }
    }
    
    init?(fromFileAt url: URL, usingEncoding encoding: String.Encoding = .utf8, descapeCharacters: Bool = false) {
        var isDirectory: ObjCBool = .init(booleanLiteral: false)
        
        if !FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory){
            debug("The provvided file doesn't exist")
            return nil
        }else if isDirectory.boolValue{
            debug("The provvided file is a folder!")
            return nil
        }
        
        var tdata: Data!
        
        do{
            tdata = try Data(contentsOf: url )
        }catch let err{
            debug("Can't get valid data from file, error: \(err.localizedDescription)")
            return nil
        }
        
        guard let data = tdata else{
            debug("Didn't get any file data!")
            return nil
        }
        
        self.init(data: data, encoding: encoding)
        
        if descapeCharacters{
            self.descapeCharacters()
        }
    }
}
