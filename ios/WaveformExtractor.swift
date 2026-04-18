import Accelerate
import AVFoundation

final class WaveformExtractor {
  func extract(path: String, sampleCount: Int) throws -> [Float] {
    guard let url = URL(string: path) else {
      throw AudioWavesError.fileNotFound("Invalid URL: \(path)")
    }

    let audioFile: AVAudioFile
    do {
      audioFile = try AVAudioFile(forReading: url)
    } catch {
      throw AudioWavesError.fileNotFound(error.localizedDescription)
    }

    let samples = max(1, sampleCount)
    let totalFrames = AVAudioFrameCount(audioFile.length)
    var framesPerBuffer = totalFrames / AVAudioFrameCount(samples)

    guard let buffer = AVAudioPCMBuffer(
      pcmFormat: audioFile.processingFormat,
      frameCapacity: framesPerBuffer
    ) else {
      throw AudioWavesError.decodeFailed("Failed to allocate PCM buffer")
    }

    let channels = Int(audioFile.processingFormat.channelCount)
    var data = Array(
      repeating: [Float](repeating: 0, count: samples),
      count: channels
    )

    var startFrame: AVAudioFramePosition = 0

    for i in 0..<samples {
      audioFile.framePosition = startFrame
      do {
        try audioFile.read(into: buffer, frameCount: framesPerBuffer)
      } catch {
        throw AudioWavesError.decodeFailed("Read failed: \(error.localizedDescription)")
      }

      guard let floatData = buffer.floatChannelData else {
        throw AudioWavesError.decodeFailed("No float channel data")
      }

      for c in 0..<channels {
        var rms: Float = 0
        vDSP_rmsqv(floatData[c], 1, &rms, vDSP_Length(buffer.frameLength))
        data[c][i] = rms
      }

      startFrame += AVAudioFramePosition(framesPerBuffer)
      if startFrame + AVAudioFramePosition(framesPerBuffer) > totalFrames {
        let remaining = totalFrames - AVAudioFrameCount(startFrame)
        if remaining <= 0 { break }
        framesPerBuffer = remaining
      }
    }

    return try mean(normalize(data, scale: 0.12), channelCount: channels)
  }

  private func normalize(_ data: [[Float]], scale: Float, threshold: Float = 0.01) -> [[Float]] {
    data.map { channel in
      let maxAmp = channel.filter { abs($0) >= threshold }.max() ?? 1.0
      guard maxAmp > 0 else { return channel }
      return channel.map { abs($0) < threshold ? 0 : ($0 / maxAmp) * scale }
    }
  }

  private func mean(_ data: [[Float]], channelCount: Int) throws -> [Float] {
    if channelCount >= 2, !data[0].isEmpty, !data[1].isEmpty {
      return zip(data[0], data[1]).map { ($0 + $1) / 2 }
    }
    if !data.isEmpty, !data[0].isEmpty { return data[0] }
    throw AudioWavesError.emptyAudio("No channel data available")
  }
}