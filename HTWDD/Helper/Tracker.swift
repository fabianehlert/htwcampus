//
//  Tracker.swift
//  HTWDD
//
//  Created by Benjamin Herzog on 18.12.17.
//  Copyright © 2017 HTW Dresden. All rights reserved.
//

import Foundation

enum TrackType: Int {
    case start, open
}

enum Platform: Int {
    case android, iOS
}

class Tracker {
    
    class func track(_ type: TrackType) {
        
        var r = URLRequest(url: URL(string: "https://rubu2.rz.htw-dresden.de/API/track")!)
        r.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        r.httpMethod = "POST"
        
        let p = [
            "plattform": Platform.iOS.rawValue,
            "api": UIDevice.current.systemVersion,
            "version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
            "unique": UIDevice.current.identifierForVendor?.uuidString ?? "unkown",
            "type": type.rawValue
            ] as [String : Any]
        
        let d = try? JSONSerialization.data(withJSONObject: p, options: .prettyPrinted)
        r.httpBody = d
        r.setValue(d?.count.description ?? "0", forHTTPHeaderField: "Content-Length")
        
        URLSession.shared.dataTask(with: r, completionHandler: {
            d, r, e in
            
            if let e = e {
                return Log.error(e)
            }
        })
        .resume()
    }
}

