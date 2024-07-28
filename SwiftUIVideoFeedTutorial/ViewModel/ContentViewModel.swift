//
//  ContentViewModel.swift
//  SwiftUIVideoFeedTutorial
//
//  Created by Christopher Walter on 7/27/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

class ContentViewModel: ObservableObject {
    
    @Published var videos: [Video] = []
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadVideo()
            }
        }
    }
    
    init() {
        Task {
            try await fetchVideos()
        }
    }
    
    func uploadVideo() async throws {
        guard let item = selectedItem else { return }
        guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
        
        print("DEBUG: VIdeo data is \(videoData)")
        
        guard let videoURL = try await VideoUploader.uploadVideo(withData: videoData) else { return }
        
        try await Firestore.firestore().collection("videos").document().setData(["videoUrl": videoURL])
        
        print("DEBUG: Finished video upload to Firebase Storage and FirestoreDatabase...")
    }
    
    @MainActor
    func fetchVideos() async throws {
        let snapshot = try await Firestore.firestore().collection("videos").getDocuments()
        
        self.videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self)})
//        for doc in snapshot.documents {
//            print(doc.data())
//        }
    }
}
