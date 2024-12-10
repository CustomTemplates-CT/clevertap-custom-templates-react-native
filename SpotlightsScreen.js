import React, {useEffect} from 'react';
import {StyleSheet, Text, View} from 'react-native';

import SpotlightHelper from './CustomTemplatesHelper';

const CleverTap = require('clevertap-react-native');

const SpotlightsScreen = () => {
  CleverTap.setDebugLevel(3);

  useEffect(() => {
    CleverTap.recordEvent('Spotlight Event');

    setTimeout(() => {
      CleverTap.getAllDisplayUnits((err, res) => {
        if (err) {
          console.log('Error fetching display units: ', err);
        } else {
          console.log('All Display Units: ', res[0]);
          console.log('wzrk_id: ', res[0].wzrk_id);
          CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
          SpotlightHelper.showSpotlights(JSON.stringify(res[0]), error => {
            if (error) {
              console.error('Error:', error);
            } else {
              console.log('Spotlights completed');
              CleverTap.pushDisplayUnitClickedEventForID(res[0].wzrk_id);
            }
          });
        }
      });
    }, 2000);
  }, []);

  return (
    <View style={styles.container}>
      <Text
        accessibilityLabel="TextView1"
        testID="TextView1"
        accessible={true}
        style={styles.textView1}>
        TextView1
      </Text>
      <Text
        accessibilityLabel="TextView2"
        testID="TextView2"
        accessible={true}
        style={styles.textView2}>
        TextView2
      </Text>
      <Text
        accessibilityLabel="TextView3"
        testID="TextView3"
        accessible={true}
        style={styles.textView3}>
        TextView3
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff', // Assuming a dark background color
  },
  textView1: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: [{translateX: -50}, {translateY: -50}],
    color: '#000',
    fontSize: 18,
    fontWeight: 'bold',
  },
  textView2: {
    position: 'absolute',
    top: 20,
    right: 20,
    color: '#000',
    fontSize: 16,
    fontWeight: 'bold',
  },
  textView3: {
    position: 'absolute',
    bottom: 20,
    left: 20,
    color: '#000',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default SpotlightsScreen;
