import React from 'react';
import {NativeModules, SafeAreaView, StatusBar, Button} from 'react-native';
import RoomPlanScreen from './src/screens/RoomPlanScreen';
import { NavigationContainer } from '@react-navigation/native';

const App = (): React.JSX.Element => {
  
  return (
      <NavigationContainer>
        <RoomPlanScreen />
    </NavigationContainer>
   
  );
};

export default App;
