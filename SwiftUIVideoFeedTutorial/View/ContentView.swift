//
//  ContentView.swift
//  SwiftUIVideoFeedTutorial
//
//  Created by Christopher Walter on 7/27/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct ContentView: View {
    
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.videos) {
                    video in
                    VideoPlayer(player: AVPlayer(url: URL(string: video.videoUrl)!))
                        .frame(height: 250)
                }
            }
            .refreshable {
                Task {
                    try await viewModel.fetchVideos()
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.videos, .not(.images)])) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            })
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
