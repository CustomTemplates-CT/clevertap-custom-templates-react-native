import React from 'react';
import {Linking} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';
import NativeDisplayTemplates from './NativeDisplayTemplates';
import Home from './Home';
import CoachMarksScreen from './CoachMarksScreen';
import TooltipsScreen from './TooltipsScreen';
import SpotlightsScreen from './SpotlightsScreen';

const Stack = createStackNavigator();

// Create a navigation reference
export const navigationRef = React.createRef();

export function navigate(name, params) {
  if (navigationRef.current?.isReady()) {
    // Navigate to the desired screen
    navigationRef.current?.navigate(name, params);
  }
}

const linking = {
  prefixes: ['karthikdl://'],
  config: {
    screens: {
      Home: 'loginpage',
    },
  },
};

const App = () => {
  return (
    <NavigationContainer
      linking={linking}
      ref={navigationRef} // Set the navigation reference
      onReady={() => {
        console.log('Navigation is ready');
      }}>
      <Stack.Navigator
        initialRouteName="Home"
        screenOptions={{
          headerTitleAlign: 'center',
          headerStyle: {
            backgroundColor: '#000',
          },
          headerTintColor: '#fff',
          headerTitleStyle: {
            fontWeight: 'bold',
          },
        }}>
        <Stack.Screen
          name="NativeDisplayTemplates"
          component={NativeDisplayTemplates}
          options={{title: 'Native Display Templates'}}
        />
        <Stack.Screen
          name="Home"
          component={Home}
          options={{title: 'Custom Templates'}}
        />
        <Stack.Screen
          name="CoachMarksScreen"
          component={CoachMarksScreen}
          options={{title: 'CoachMarks Screen'}}
        />
        <Stack.Screen
          name="TooltipsScreen"
          component={TooltipsScreen}
          options={{title: 'Tooltips Screen'}}
        />
        <Stack.Screen
          name="SpotlightsScreen"
          component={SpotlightsScreen}
          options={{title: 'Spotlights Screen'}}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
