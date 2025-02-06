import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet, SafeAreaView, NativeModules } from 'react-native';
const {RoomPlanModule} = NativeModules;

const RoomPlanScreen = () => {

    const startRoomPlan = async () => {
        try {
          await RoomPlanModule.startScanning();
        } catch (error) {
          console.error('Error starting RoomPlan:', error);
        }
      };

      return (
        <SafeAreaView style={styles.container}>
          <View style={styles.content}>
            <Text style={styles.title}>RoomPlan</Text>
            <Text style={styles.description}>
              To scan your room, point your device at all the walls, windows, doors, 
              and furniture in your space until your scan is complete.
            </Text>
            <Text style={styles.description}>
              You can see a preview of your scan at the bottom of the screen 
              so you can make sure your scan is correct.
            </Text>
          </View>
    
          <TouchableOpacity style={styles.button} onPress={startRoomPlan}>
            <Text style={styles.buttonText}>Start Scanning</Text>
          </TouchableOpacity>
        </SafeAreaView>
      );
};

const styles = StyleSheet.create({
    container: {
      flex: 1,
      backgroundColor: '#000', // Black background
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingBottom: 30, // Padding for button spacing
    },
    content: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      paddingHorizontal: 25,
    },
    title: {
      fontSize: 28,
      fontWeight: 'bold',
      color: '#fff',
      textAlign: 'center',
      marginBottom: 20,
    },
    description: {
      fontSize: 16,
      color: '#fff',
      textAlign: 'center',
      marginBottom: 15,
    },
    button: {
      backgroundColor: '#007AFF', // Blue button
      paddingVertical: 15,
      borderRadius: 25,
      alignItems: 'center',
      justifyContent: 'center',
      width: '80%',
      marginBottom: 20, // Extra margin at bottom for better spacing
    },
    buttonText: {
      fontSize: 18,
      fontWeight: '600',
      color: '#fff',
    },
  });

export default RoomPlanScreen;
