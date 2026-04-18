import { getHostComponent } from 'react-native-nitro-modules';
const AudioWavesConfig = require('../nitrogen/generated/shared/json/AudioWavesConfig.json');
import type {
  AudioWavesMethods,
  AudioWavesProps,
} from './AudioWaves.nitro';

export const AudioWavesView = getHostComponent<
  AudioWavesProps,
  AudioWavesMethods
>('AudioWaves', () => AudioWavesConfig);
