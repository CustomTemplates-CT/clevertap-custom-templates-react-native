import React, {useState} from 'react';
import {
  View,
  TextInput,
  StyleSheet,
  Alert,
  TouchableOpacity,
  Text,
} from 'react-native';

const CleverTap = require('clevertap-react-native');

const NativeDisplayTemplates = ({navigation}) => {
  CleverTap.setDebugLevel(3);

  const handleSubmit = () => {
    navigation.navigate('CoachMarksScreen');
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity style={styles.button} onPress={handleSubmit}>
        <Text style={styles.buttonText}>Navigate to Coachmarks</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 16,
  },
  title: {
    fontSize: 25,
    fontWeight: 'bold',
    textTransform: 'uppercase',
    textAlign: 'center',
    paddingVertical: 20,
    color: '#2196f3',
  },
  button: {
    height: 50,
    borderRadius: 25, // Oval-shaped button
    backgroundColor: '#2196f3', // Button color
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 10, // Margin between inputs and button
  },
  buttonText: {
    color: '#fff', // Text color
    fontSize: 18,
  },
});

export default NativeDisplayTemplates;
