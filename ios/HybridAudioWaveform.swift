import Foundation
import NitroModules

class HybridAudioWaveform: HybridAudioWaveformSpec {
  private let extractor = WaveformExtractor()

  func extractWaveform(path: String, sampleCount: Double) throws -> Promise<[Double]> {
    return Promise.async { [extractor] in
      let samples = try extractor.extract(path: path, sampleCount: Int(sampleCount))
      return samples.map(Double.init)
    }
  }
}