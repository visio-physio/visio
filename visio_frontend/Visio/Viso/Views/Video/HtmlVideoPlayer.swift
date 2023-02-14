import SwiftUI
import AVKit

struct HttpVideoPlayer: View {
    let url: URL
    let player: AVPlayer
    
    init(url: URL) {
        self.url = url
        self.player = AVPlayer(url: url)
    }
    
    var body: some View {
        PlayerView(player: player)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        player.play()
        return view
    }
}

struct HttpVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        return HttpVideoPlayer(url: url)
    }
}
