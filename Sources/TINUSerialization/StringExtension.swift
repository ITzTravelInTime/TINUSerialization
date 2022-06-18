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

extension String{
    func descapingCharacters() -> Self{
        var cpy = self.replacingOccurrences(of: "\\\\\"", with: "\"")
        cpy = cpy.replacingOccurrences(of: "\\\\n", with: "\n")
        cpy = cpy.replacingOccurrences(of: "\\\\r", with: "\r")
        cpy = cpy.replacingOccurrences(of: "\\\\0", with: "")
        cpy = cpy.replacingOccurrences(of: "\\\\", with: "\\")
        return cpy
    }
    
    mutating func descapeCharacters(){
        self = self.descapingCharacters()
    }
    
#if !(os(Linux) || os(Windows))
    init?(fromRemoteFileAt url: URL, descapeCharacters: Bool = false){
        #if !os(watchOS)
        if !SimpleReachability.status {
            return nil
        }
        #endif
        
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
        
        debug("Obtained remote string: \n\n" + self)
    }
#endif
    
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

