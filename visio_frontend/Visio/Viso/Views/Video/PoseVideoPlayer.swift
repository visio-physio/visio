//
//  PoseVideoPlayer.swift
//  Viso
//
//  Created by person on 2023-01-29.
//

import SwiftUI
import AVKit

struct PoseVideoPlayer: View {
    var body: some View {
        VideoPlayer(player: AVPlayer(url:  URL(string: "https://bit.ly/swswift")!)) {
        }
    }
}

struct PoseVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        PoseVideoPlayer()
    }
}


