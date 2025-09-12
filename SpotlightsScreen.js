import React, {useEffect, useRef} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Platform,
  findNodeHandle,
  NativeModules,
} from 'react-native';
import SpotlightHelper from './CustomTemplatesHelper';
const CleverTap = require('clevertap-react-native');
const {SpotlightBridge} = NativeModules;

console.log('🔍 [JS] SpotlightBridge in NativeModules:', SpotlightBridge);

const SpotlightsScreen = () => {
  const TextView1Ref = useRef(null);
  const TextView2Ref = useRef(null);
  const TextView3Ref = useRef(null);

  useEffect(() => {
    CleverTap.setDebugLevel(3);
    CleverTap.recordEvent('spotlights_nd');
    // CleverTap.recordEvent('SpotlightsND');

    const getTargets = () => {
      const refs = [
        {ref: TextView1Ref.current, name: 'TextView1'},
        {ref: TextView2Ref.current, name: 'TextView2'},
        {ref: TextView3Ref.current, name: 'TextView3'},
      ];

      const targets = {};
      refs.forEach(item => {
        const tag = findNodeHandle(item.ref);
        console.log(`🔹 [JS] findNodeHandle for ${item.name}: ${tag}`);
        if (tag) {
          // We pass the numeric tag as the value.
          // The native side will search views by this tag.
          targets[item.name] = tag;
        } else {
          console.warn(`⚠️ [JS] findNodeHandle is null for ${item.name}`);
        }
      });

      return targets;
    };

    setTimeout(() => {
      CleverTap.getAllDisplayUnits((err, res) => {
        if (err) {
          console.error('Error fetching display units:', err);
          return;
        }
        if (!res || res.length === 0) {
          console.warn('⚠️ No display units found');
          return;
        }

        const displayUnit = res[0];
        console.log('✅ [JS] Display Unit:', displayUnit);
        console.log('wzrk_id:', displayUnit.wzrk_id);

        const targets = getTargets();

        if (Platform.OS === 'android') {
          console.log('🔹 [JS] Android spotlight flow');
          CleverTap.pushDisplayUnitViewedEventForID(displayUnit.wzrk_id);
          SpotlightHelper.showSpotlights(JSON.stringify(displayUnit), error => {
            if (error) console.error('Spotlight error:', error);
            else {
              console.log('✅ Spotlights completed (Android)');
              CleverTap.pushDisplayUnitClickedEventForID(displayUnit.wzrk_id);
            }
          });
        } else if (Platform.OS === 'ios') {
          console.log('🔹 [JS] iOS spotlight flow');
          CleverTap.pushDisplayUnitViewedEventForID(displayUnit.wzrk_id);
          console.log(
            '🚀 [JS] Calling SpotlightBridge.showSpotlights with json & targets:',
            targets,
          );

          if (!SpotlightBridge || !SpotlightBridge.showSpotlights) {
            console.error(
              '❌ [JS] SpotlightBridge.showSpotlights is not available on NativeModules',
            );
            return;
          }

          // Call promise-based native method.
          SpotlightBridge.showSpotlights(JSON.stringify(displayUnit), targets)
            .then(res => {
              console.log('✅ [JS] Spotlight flow completed:', res);
              CleverTap.pushDisplayUnitClickedEventForID(displayUnit.wzrk_id);
            })
            .catch(err => {
              console.error('❌ [JS] Spotlight error:', err);
            });
        }
      });
    }, 2000);
  }, []);

  return (
    <View style={styles.container}>
      <Text ref={TextView1Ref} nativeID="TextView1" style={styles.textView1}>
        TextView1
      </Text>
      <Text ref={TextView2Ref} nativeID="TextView2" style={styles.textView2}>
        TextView2
      </Text>
      <Text ref={TextView3Ref} nativeID="TextView3" style={styles.textView3}>
        TextView3
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {flex: 1, backgroundColor: '#fff'},
  textView1: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: [{translateX: -50}, {translateY: -50}],
    fontSize: 18,
    fontWeight: 'bold',
  },
  textView2: {
    position: 'absolute',
    top: 20,
    right: 20,
    fontSize: 16,
    fontWeight: 'bold',
  },
  textView3: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default SpotlightsScreen;
