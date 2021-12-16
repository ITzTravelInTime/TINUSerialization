/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import TINURecovery

public extension Decodable{
    /**
     Initializes the current class from a string containg JSON serialized data.
     
     - Parameter fromJSONSerialisedString: The `String` containing JSON encoded data to be used for the initialization.
     */
    init?(fromJSONSerialisedString string: String){
        
        if string.isEmpty{
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let data = string.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch{
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
        }catch{
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
        if let _ = Self.init(fromJSONSerialisedString: string){
            self.init(fromJSONSerialisedString: string)
        }else if let _ = Self.init(fromPlistSerialisedString: string){
            self.init(fromPlistSerialisedString: string)
        }else{
            return nil
        }
    }
    
    /**
     Initializes the current class from a `Data` object encoding a string containing serialized information in either JSON or Plist (Property list) formats.
     
     - Parameter fromData: The `Data` containing serialized information (as a string) in either JSON or Plist (Property list) formats to be used for the initialization.
     - Parameter encoding: The `String.Encoding` to be used for the interpreatation fo the provvided data.
     */
    fileprivate init?(fromSerializedData data: Data, usingEncoding encoding: String.Encoding = .utf8){
        
        guard let string = String(data: data, encoding: encoding) else{
            debug("Can't convert the data to a valid string using the provvided encoding.")
            return nil
        }
        
        self.init(fromSerializedString: string)
    }
    
    /**
     Initializes the current class from a local file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromFileAt: The `URL` of the file to be used for initialization (must be either JSON or Plist fromattaed).
     - Parameter encoding: The `String.Encoding` to be used for the initialization of the readed text.
     */
    init?(fromFileAt url: URL, usingEncoding encoding: String.Encoding = .utf8) {
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
        
        self.init(fromSerializedData: data, usingEncoding: encoding)
    }
    
    /**
     Initializes the current class from a local file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromFileAtPath: The `String` path of the file to be used for initialization (must be either JSON or Plist fromattaed).
     - Parameter encoding: The `String.Encoding` to be used for the initialization of the readed text.
     */
    init?(fromFileAtPath file: String){
        if file.isEmpty{
            return nil
        }
        
        self.init(fromFileAt: URL(fileURLWithPath: file))
    }
    
    /**
     Initializes the current class from a remote file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromRemoteFileAt: The `URL` of the remote file to be used for initialization (must be either JSON or Plist fromattaed).
     
     */
    init?(fromRemoteFileAt url: URL) {
        
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
        
        self.init(fromSerializedData: safeData, usingEncoding: encoding)
        
    }
    
    /**
     Initializes the current class from a remote file encoded in either JSON or Plist (Property list) formats.
     
     - Parameter fromRemoteFileAtUrl: The `String` of the url of the remote file to be used for initialization (must be either JSON or Plist fromattaed).
     
     */
    init?(fromRemoteFileAtUrl url: String){
        if url.isEmpty{
            return nil
        }
        
        guard let url = URL(string: url) else{
            debug("Can't get valid URL object from the provvided url string")
            return nil
        }
        
        self.init(fromRemoteFileAt: url )
    }
}
