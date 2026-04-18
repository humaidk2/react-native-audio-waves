package com.margelo.nitro.audiowaves

sealed class AudioWavesError(code: String, details: String) : Exception("$code: $details") {
  class FileNotFound(details: String) : AudioWavesError("FILE_NOT_FOUND", details)
  class DecodeFailed(details: String) : AudioWavesError("DECODE_FAILED", details)
  class EmptyAudio(details: String) : AudioWavesError("EMPTY_AUDIO", details)
}
