// import React, {useEffect} from 'react';
// import {View, Text, StyleSheet} from 'react-native';

// import TooltipsHelper from './CustomTemplatesHelper';

// const CleverTap = require('clevertap-react-native');

// const TooltipsScreen = () => {
//   CleverTap.setDebugLevel(3);

//   useEffect(() => {
//     CleverTap.recordEvent('tooltips_nd');

//     setTimeout(() => {
//       CleverTap.getAllDisplayUnits((err, res) => {
//         if (err) {
//           console.log('Error fetching display units: ', err);
//         } else {
//           console.log('All Display Units: ', res[0]);
//           console.log('wzrk_id: ', res[0].wzrk_id);
//           CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
//           TooltipsHelper.showTooltips(JSON.stringify(res[0]), error => {
//             if (error) {
//               console.error('Error:', error);
//             } else {
//               console.log('Tooltips completed');
//               CleverTap.pushDisplayUnitClickedEventForID(res[0].wzrk_id);
//             }
//           });
//         }
//       });
//     }, 2000);
//   }, []);

//   return (
//     <View style={styles.container}>
//       <Text
//         nativeID="TextView1"
//         style={[styles.title, styles.title1]}>
//         This is Title 1
//       </Text>
//       <Text
//         nativeID="TextView2"
//         style={[styles.title, styles.title2]}>
//         This is Title 2
//       </Text>
//       <Text
//         nativeID="TextView3"
//         style={[styles.title, styles.title3]}>
//         This is Title 3
//       </Text>
//       <Text
//         nativeID="TextView4"
//         style={[styles.title, styles.title4]}>
//         This is Title 4
//       </Text>
//     </View>
//   );
// };

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     backgroundColor: '#fff', // Background color
//   },
//   title: {
//     color: '#000', // White text color
//     position: 'absolute', // Absolute positioning for flexible placement
//   },
//   title1: {
//     top: 20, // Position at the top
//     left: 20, // Position towards the left
//   },
//   title2: {
//     top: 170, // Position at the top
//     right: 20, // Position towards the right
//   },
//   title3: {
//     top: '50%', // Center vertically
//     left: '50%', // Center horizontally
//     transform: [{translateX: -50}, {translateY: -10}], // Adjust for centering
//   },
//   title4: {
//     bottom: 20, // Position at the bottom
//     left: '50%', // Align to the center horizontally
//     transform: [{translateX: -50}], // Adjust for horizontal centering
//   },
// });

// export default TooltipsScreen;

import React, {useEffect, useRef} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Platform,
  findNodeHandle,
  NativeModules,
} from 'react-native';

import TooltipsHelper from './CustomTemplatesHelper';
const CleverTap = require('clevertap-react-native');
const {CTCustomTemplatesBridge} = NativeModules;

const TooltipsScreen = () => {
  const TextView1Ref = useRef(null);
  const TextView2Ref = useRef(null);
  const TextView3Ref = useRef(null);
  const TextView4Ref = useRef(null);

  useEffect(() => {
    CleverTap.setDebugLevel(3);
    CleverTap.recordEvent('tooltips_nd');
    // CleverTap.recordEvent('ToolsTipsND');

    const getTargets = () => {
      const refs = [
        {ref: TextView1Ref.current, name: 'TextView1'},
        {ref: TextView2Ref.current, name: 'TextView2'},
        {ref: TextView3Ref.current, name: 'TextView3'},
        {ref: TextView4Ref.current, name: 'TextView4'},
      ];

      const targets = {};
      refs.forEach(item => {
        const tag = findNodeHandle(item.ref);
        console.log(`🔹 [JS] findNodeHandle for ${item.name}: ${tag}`);
        if (tag) {
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
          console.error('❌ Error fetching display units:', err);
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
        CleverTap.pushDisplayUnitViewedEventForID(displayUnit.wzrk_id);

        if (Platform.OS === 'android') {
          console.log('🔹 [JS] Android tooltip flow');
          TooltipsHelper.showTooltips(JSON.stringify(displayUnit), error => {
            if (error) {
              console.error('❌ Tooltip error:', error);
            } else {
              console.log('✅ Tooltips completed (Android)');
              CleverTap.pushDisplayUnitClickedEventForID(displayUnit.wzrk_id);
            }
          });
        } else if (Platform.OS === 'ios') {
          console.log('🔹 [JS] iOS tooltip flow');
          CTCustomTemplatesBridge.showTooltips(JSON.stringify(displayUnit), targets)
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
      <Text
        ref={TextView1Ref}
        nativeID="TextView1"
        style={[styles.title, styles.title1]}>
        This is Title 1
      </Text>
      <Text
        ref={TextView2Ref}
        nativeID="TextView2"
        style={[styles.title, styles.title2]}>
        This is Title 2
      </Text>
      <Text
        ref={TextView3Ref}
        nativeID="TextView3"
        style={[styles.title, styles.title3]}>
        This is Title 3
      </Text>
      <Text
        ref={TextView4Ref}
        nativeID="TextView4"
        style={[styles.title, styles.title4]}>
        This is Title 4
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  title: {
    color: '#000',
    position: 'absolute',
    fontSize: 16,
    fontWeight: 'bold',
  },
  title1: {
    top: 20,
    left: 20,
  },
  title2: {
    top: 170,
    right: 20,
  },
  title3: {
    top: '50%',
    left: '50%',
    transform: [{translateX: -50}, {translateY: -10}],
  },
  title4: {
    bottom: 20,
    left: '50%',
    transform: [{translateX: -50}],
  },
});

export default TooltipsScreen;
