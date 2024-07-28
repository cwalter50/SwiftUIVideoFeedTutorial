//
//  VideoUploader.swift
//  SwiftUIVideoFeedTutorial
//
//  Created by Christopher Walter on 7/27/24.
//

import Foundation
import FirebaseStorage


struct VideoUploader {
    
    static func uploadVideo(withData videoData: Data) async throws -> String? {
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference().child("/videos/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quicktime"

        do {
            let _ = try await ref.putDataAsync(videoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: failed to upload video with error \(error.localizedDescription)")
            return nil
        }
    }
}
