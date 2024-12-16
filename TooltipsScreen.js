import React, {useEffect} from 'react';
import {View, Text, StyleSheet} from 'react-native';

import TooltipsHelper from './CustomTemplatesHelper';

const CleverTap = require('clevertap-react-native');

const TooltipsScreen = () => {
  CleverTap.setDebugLevel(3);

  useEffect(() => {
    CleverTap.recordEvent('tooltips_nd');

    setTimeout(() => {
      CleverTap.getAllDisplayUnits((err, res) => {
        if (err) {
          console.log('Error fetching display units: ', err);
        } else {
          console.log('All Display Units: ', res[0]);
          console.log('wzrk_id: ', res[0].wzrk_id);
          CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
          TooltipsHelper.showTooltips(JSON.stringify(res[0]), error => {
            if (error) {
              console.error('Error:', error);
            } else {
              console.log('Tooltips completed');
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
        accessible={true}
        style={[styles.title, styles.title1]}>
        This is Title 1
      </Text>
      <Text
        accessibilityLabel="TextView2"
        accessible={true}
        style={[styles.title, styles.title2]}>
        This is Title 2
      </Text>
      <Text
        accessibilityLabel="TextView3"
        accessible={true}
        style={[styles.title, styles.title3]}>
        This is Title 3
      </Text>
      <Text
        accessibilityLabel="TextView4"
        accessible={true}
        style={[styles.title, styles.title4]}>
        This is Title 4
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff', // Background color
  },
  title: {
    color: '#000', // White text color
    position: 'absolute', // Absolute positioning for flexible placement
  },
  title1: {
    top: 20, // Position at the top
    left: 20, // Position towards the left
  },
  title2: {
    top: 170, // Position at the top
    right: 20, // Position towards the right
  },
  title3: {
    top: '50%', // Center vertically
    left: '50%', // Center horizontally
    transform: [{translateX: -50}, {translateY: -10}], // Adjust for centering
  },
  title4: {
    bottom: 20, // Position at the bottom
    left: '50%', // Align to the center horizontally
    transform: [{translateX: -50}], // Adjust for horizontal centering
  },
});

export default TooltipsScreen;
