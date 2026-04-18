package com.margelo.nitro.audiowaves

import com.margelo.nitro.NitroModules
import com.margelo.nitro.core.Promise

class HybridAudioWaveform : HybridAudioWaveformSpec() {
  private val extractor by lazy {
    val context = NitroModules.applicationContext
      ?: throw AudioWavesError.DecodeFailed("NitroModules.applicationContext is null")
    WaveformExtractor(context)
  }

  override fun extractWaveform(path: String, sampleCount: Double): Promise<DoubleArray> {
    return Promise.async {
      extractor.extract(path, sampleCount.toInt())
        .map { it.toDouble() }
        .toDoubleArray()
    }
  }
}