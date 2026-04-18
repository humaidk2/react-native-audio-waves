import type {
  HybridView,
  HybridViewMethods,
  HybridViewProps,
} from 'react-native-nitro-modules';

export interface AudioWavesProps extends HybridViewProps {
  color: string;
}
export interface AudioWavesMethods extends HybridViewMethods {}

export type AudioWaves = HybridView<
  AudioWavesProps,
  AudioWavesMethods
>;
