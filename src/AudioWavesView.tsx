import type { ColorValue, ViewProps } from 'react-native';

type Props = ViewProps & {
  color?: ColorValue;
};

export function AudioWavesView(_props: Props): never {
  throw new Error(
    "'react-native-audio-waves' is only supported on native platforms."
  );
}
