//
//  VIdeo.swift
//  SwiftUIVideoFeedTutorial
//
//  Created by Christopher Walter on 7/27/24.
//

import Foundation

struct Video: Identifiable, Decodable {
    let videoUrl: String
    var id : String {
        return NSUUID().uuidString
    }
    
}
