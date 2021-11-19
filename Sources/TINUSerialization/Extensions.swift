/*
 TINUSerialization: A library for the usage of serialization formats in Swift.
 Copyright (C) 2021 Pietro Caruso

 This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */

import Foundation
import TINURecovery

public extension Encodable{
    func json(prettyPrinted: Bool = false) -> String?{
        let encoder = JSONEncoder()
        
        if prettyPrinted{
            encoder.outputFormatting = .prettyPrinted
        }
        
        var str: String?
        
        do{
            str = try String(data: encoder.encode(self), encoding: .utf8)
        }catch{
            return nil
        }
        
        return str
    }
    
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

public extension Decodable{
    init?(fromJSONSerialisedString json: String){
        let decoder = JSONDecoder()
        
        guard let data = json.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch{
            return nil
        }
    }
    
    init?(fromPlistSerialisedString plist: String){
        let decoder = PropertyListDecoder()
        
        guard let data = plist.data(using: .utf8) else { return nil }
        
        do{
            self = try decoder.decode(Self.self, from: data)
        }catch{
            return nil
        }
    }
    
    private init?(fromFilePath path: String, isJson: Bool) {
        do{
            guard let tempData = try String(data: Data(contentsOf: URL(fileURLWithPath: path ) ), encoding: .utf8) else{
                return nil
            }
            
            if isJson{
                self.init(fromJSONSerialisedString: tempData)
            }else{
                self.init(fromPlistSerialisedString: tempData)
            }
            
        }catch{
            return nil
        }
    }
    
    init?(fromJSONFilePath path: String){
        self.init(fromFilePath: path, isJson: true)
    }
    
    init?(fromJSONFile url: URL) {
        self.init(fromFilePath: url.path, isJson: true)
    }
    
    init?(fromPlistFilePath path: String) {
        self.init(fromFilePath: path, isJson: false)
    }
    
    init?(fromPlistFile url: URL) {
        self.init(fromFilePath: url.path, isJson: false)
    }
    
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
            log("Error while getting the update information from the stored update link: \(e.localizedDescription)")
            return nil
        }
        
        guard let safeResponse = response else{
            log("Invalid or missing url request response")
            return nil
        }
        
        let encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(NSString(string: safeResponse.textEncodingName ?? "utf8") as CFString)))
        
        guard let dataSafe = data else{
            log("Invalid or no data recovered from url request")
            return nil
        }
        
        guard let string = String(data: dataSafe, encoding: encoding) else{
            log("Can't convert the url request data to a string")
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
}
