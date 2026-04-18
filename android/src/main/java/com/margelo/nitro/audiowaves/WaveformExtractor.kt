package com.margelo.nitro.audiowaves

import android.content.Context
import android.media.MediaPlayer
import com.linc.amplituda.Amplituda
import com.linc.amplituda.Compress
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

class WaveformExtractor(private val context: Context) {
  private val scale = 0.12f

  suspend fun extract(path: String, sampleCount: Int): List<Float> {
    val durationSec = readDurationSeconds(path)
    if (durationSec <= 0) return List(sampleCount) { 0f }

    val samplesPerSec = (sampleCount / durationSec).toInt().coerceAtLeast(1)

    return suspendCoroutine { cont ->
      try {
        Amplituda(context)
          .processAudio(path, Compress.withParams(Compress.AVERAGE, samplesPerSec))
          .get(
            { result ->
              try {
                val amps = result.amplitudesAsList()
                val resampled = resample(amps, sampleCount)
                val max = resampled.maxOrNull() ?: 1
                cont.resume(
                  resampled.map {
                    if (max > 0) (it.toFloat() / max) * scale else 0f
                  }
                )
              } catch (e: Exception) {
                cont.resumeWithException(
                  AudioWavesError.DecodeFailed(e.message ?: "amplitude processing failed")
                )
              }
            },
            { ex ->
              cont.resumeWithException(
                AudioWavesError.DecodeFailed(ex.message ?: "amplituda failed")
              )
            }
          )
      } catch (e: Exception) {
        cont.resumeWithException(
          AudioWavesError.DecodeFailed(e.message ?: "amplituda init failed")
        )
      }
    }
  }

  private fun readDurationSeconds(path: String): Double {
    val mp = MediaPlayer()
    try {
      mp.setDataSource(path)
      mp.prepare()
      return mp.duration / 1000.0
    } catch (e: Exception) {
      throw AudioWavesError.FileNotFound(e.message ?: path)
    } finally {
      mp.release()
    }
  }

  private fun resample(amps: List<Int>, target: Int): List<Int> = when {
    amps.isEmpty() -> List(target) { 0 }
    amps.size == target -> amps
    else -> {
      val factor = amps.size.toFloat() / target
      List(target) { amps[(it * factor).toInt()] }
    }
  }
}