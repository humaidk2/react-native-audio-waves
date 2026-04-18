export type AudioWavesErrorCode =
  | 'FILE_NOT_FOUND'
  | 'DECODE_FAILED'
  | 'EMPTY_AUDIO'
  | 'UNKNOWN';

const KNOWN_CODES: AudioWavesErrorCode[] = [
  'FILE_NOT_FOUND',
  'DECODE_FAILED',
  'EMPTY_AUDIO',
];

export class AudioWavesError extends Error {
  readonly code: AudioWavesErrorCode;

  constructor(code: AudioWavesErrorCode, message: string) {
    super(message);
    this.name = 'AudioWavesError';
    this.code = code;
  }

  static fromNative(err: unknown): AudioWavesError {
    const raw = err instanceof Error ? err.message : String(err);
    for (const code of KNOWN_CODES) {
      const marker = `${code}:`;
      const idx = raw.indexOf(marker);
      if (idx !== -1) {
        return new AudioWavesError(code, raw.slice(idx + marker.length).trim());
      }
    }
    return new AudioWavesError('UNKNOWN', raw);
  }
}
