import {
  extractWaveform,
  AudioWavesError,
  AudioWavesView,
} from 'react-native-audio-waves';
import { View, StyleSheet } from 'react-native';
import { useEffect } from 'react';

export default function App() {
  useEffect(() => {
    (async () => {
      try {
        console.log('wow');
        const samples = await extractWaveform('file:///nonexistent.m4a', 50);
        console.log('samples', samples.length, samples);
      } catch (e) {
        if (e instanceof AudioWavesError) {
          console.log('code:', e.code, 'msg:', e.message);
        } else {
          console.log('unexpected:', e);
        }
      }
    })();
  }, []);

  return (
    <View style={styles.container}>
      <AudioWavesView color="#32a852" style={styles.box} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
