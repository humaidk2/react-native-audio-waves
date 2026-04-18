import type { HybridObject } from 'react-native-nitro-modules';

export interface AudioWaveform extends HybridObject<{
  ios: 'swift';
  android: 'kotlin';
}> {
  extractWaveform(path: string, sampleCount: number): Promise<number[]>;
}
