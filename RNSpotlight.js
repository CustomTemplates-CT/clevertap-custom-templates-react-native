import { NativeModules } from 'react-native';
const { RNSpotlightModule } = NativeModules;

export function showSpotlights(payload) {
  // payload is the exact object you shared
  return RNSpotlightModule.showSpotlights(payload);
}
