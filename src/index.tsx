export { AudioWavesView } from './AudioWavesView';
import { NitroModules } from 'react-native-nitro-modules';
import type { AudioWaveform } from './specs/AudioWaveform.nitro';
import { AudioWavesError } from './errors/AudioWavesError';

const Native = NitroModules.createHybridObject<AudioWaveform>('AudioWaveform');

export async function extractWaveform(
  path: string,
  sampleCount: number
): Promise<number[]> {
  try {
    return await Native.extractWaveform(path, sampleCount);
  } catch (err) {
    throw AudioWavesError.fromNative(err);
  }
}

export { AudioWavesError } from './errors/AudioWavesError';
export type { AudioWavesErrorCode } from './errors/AudioWavesError';
