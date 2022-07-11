//
//  JSONDataManager.swift
//  Assignment3
//
//  Created by Jignesh on 10/06/22.
//

import Foundation

public class JSONDataManager {
    
    //get Document Directory
    static fileprivate func getDocumentDirectory() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            debugPrint(url)
            return url
        } else {
            fatalError("Unable to access document")
        }
    }
    
    //load any kind of data of codeable objest
    static func load<T:Decodable>(_ fileName:String, with type:T.Type) -> T? {
        let url = getDocumentDirectory().appendingPathComponent(fileName + ".json", isDirectory : false)
        if !FileManager.default.fileExists(atPath: url.path){
            print("File not found \(url.path)")
            return nil
        }
        if let data = FileManager.default.contents(atPath: url.path){
            do {
                let model = try JSONDecoder().decode(type, from: data)
                return model
            }catch{
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Data unavaiable at path \(url.path)")
        }
    }
    
    //Save any kind of codeable objects
    static func save<T:Encodable>(_ object:T , with fileName:String){
        let url = getDocumentDirectory().appendingPathComponent(fileName + ".json", isDirectory : false)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path){
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
