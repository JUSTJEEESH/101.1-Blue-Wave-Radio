//
//  AudioStreamManager.swift
//  Blue Wave Radio Roatan
//
//  Service for managing radio stream playback
//

import Foundation
import AVFoundation
import MediaPlayer
import Combine

class AudioStreamManager: NSObject, ObservableObject {
    static let shared = AudioStreamManager()

    // Stream configuration
    private let streamURL = URL(string: "https://streaming.shoutcast.com/101-1-blue-wave-radio-roatan")!

    // Player
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?

    // State
    @Published var isPlaying = false
    @Published var isBuffering = false
    @Published var currentTrack: String = "101.1 Blue Wave Radio"
    @Published var currentArtist: String = "Roatan"
    @Published var volume: Float = 0.75

    // Sleep timer
    @Published var sleepTimerMinutes: Int = 0
    private var sleepTimer: Timer?

    private override init() {
        super.init()
        setupRemoteCommands()
    }

    // MARK: - Playback Control

    func play() {
        if player == nil {
            setupPlayer()
        }

        player?.play()
        isPlaying = true
        isBuffering = true
        updateNowPlayingInfo()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func setVolume(_ newVolume: Float) {
        volume = max(0, min(1, newVolume))
        player?.volume = volume
    }

    func skip(seconds: Double) {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTimeAdd(currentTime, CMTime(seconds: seconds, preferredTimescale: 1))
        player?.seek(to: newTime)
    }

    // MARK: - Sleep Timer

    func setSleepTimer(minutes: Int) {
        sleepTimer?.invalidate()
        sleepTimerMinutes = minutes

        if minutes > 0 {
            sleepTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(minutes * 60), repeats: false) { [weak self] _ in
                self?.pause()
                self?.sleepTimerMinutes = 0
            }
        }
    }

    var sleepTimerRemaining: Int {
        sleepTimerMinutes
    }

    // MARK: - Private Methods

    private func setupPlayer() {
        playerItem = AVPlayerItem(url: streamURL)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = volume

        // Observe player status
        playerItem?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: [.new], context: nil)
        playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: [.new], context: nil)

        // Monitor metadata
        setupMetadataObserver()

        // Time observer for progress
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            // Update any time-based UI here
        }
    }

    private func setupMetadataObserver() {
        guard let playerItem = playerItem else { return }

        // Observe timed metadata (Icy protocol)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMetadataChange),
            name: .AVPlayerItemNewAccessLogEntry,
            object: playerItem
        )

        // Check for metadata in player item
        let metadata = playerItem.asset.metadata
        if !metadata.isEmpty {
            parseMetadata(metadata)
        }
    }

    @objc private func handleMetadataChange(_ notification: Notification) {
        guard let playerItem = playerItem else { return }

        let metadata = playerItem.asset.metadata
        if !metadata.isEmpty {
            parseMetadata(metadata)
        }

        // Try to get Icy metadata from the stream
        let timedMetadata = playerItem.timedMetadata
        if !timedMetadata.isEmpty {
            for item in timedMetadata {
                if let value = item.value(forKey: "value") as? String {
                    parseIcyMetadata(value)
                }
            }
        }
    }

    private func parseMetadata(_ metadata: [AVMetadataItem]) {
        for item in metadata {
            if let commonKey = item.commonKey, let value = item.value {
                switch commonKey {
                case .commonKeyTitle:
                    if let title = value as? String {
                        currentTrack = title
                    }
                case .commonKeyArtist:
                    if let artist = value as? String {
                        currentArtist = artist
                    }
                default:
                    break
                }
            }
        }
        updateNowPlayingInfo()
    }

    private func parseIcyMetadata(_ metadata: String) {
        // Parse Shoutcast Icy metadata format: "Artist - Track"
        let components = metadata.components(separatedBy: " - ")
        if components.count >= 2 {
            currentArtist = components[0].trimmingCharacters(in: .whitespaces)
            currentTrack = components[1].trimmingCharacters(in: .whitespaces)
        } else {
            currentTrack = metadata.trimmingCharacters(in: .whitespaces)
        }
        updateNowPlayingInfo()
    }

    // MARK: - Now Playing / Lock Screen

    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipForwardCommand.addTarget { [weak self] _ in
            self?.skip(seconds: 30)
            return .success
        }

        commandCenter.skipBackwardCommand.preferredIntervals = [10]
        commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
            self?.skip(seconds: -10)
            return .success
        }
    }

    private func updateNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTrack
        nowPlayingInfo[MPMediaItemPropertyArtist] = currentArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "101.1 Blue Wave Radio"

        // Add artwork if available (placeholder for now)
        if let image = createRadioWaveImage() {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    private func createRadioWaveImage() -> UIImage? {
        // Create a simple placeholder image with SF Symbol
        let config = UIImage.SymbolConfiguration(pointSize: 200, weight: .regular)
        return UIImage(systemName: "radiowaves.left.and.right", withConfiguration: config)
    }

    // MARK: - KVO

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let status = playerItem?.status {
                switch status {
                case .readyToPlay:
                    isBuffering = false
                case .failed:
                    isBuffering = false
                    isPlaying = false
                    print("Player failed: \(String(describing: playerItem?.error))")
                default:
                    break
                }
            }
        } else if keyPath == "playbackBufferEmpty" {
            isBuffering = true
        } else if keyPath == "playbackLikelyToKeepUp" {
            isBuffering = false
        }
    }

    deinit {
        sleepTimer?.invalidate()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
}
