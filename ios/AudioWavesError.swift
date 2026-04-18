import Foundation

enum AudioWavesErrorCode: String {
  case fileNotFound = "FILE_NOT_FOUND"
  case decodeFailed = "DECODE_FAILED"
  case emptyAudio   = "EMPTY_AUDIO"
}

struct AudioWavesError: Error, CustomStringConvertible {
  let code: AudioWavesErrorCode
  let details: String

  var description: String { "\(code.rawValue): \(details)" }
  var localizedDescription: String { description }

  static func fileNotFound(_ details: String) -> AudioWavesError {
    .init(code: .fileNotFound, details: details)
  }
  static func decodeFailed(_ details: String) -> AudioWavesError {
    .init(code: .decodeFailed, details: details)
  }
  static func emptyAudio(_ details: String) -> AudioWavesError {
    .init(code: .emptyAudio, details: details)
  }
}