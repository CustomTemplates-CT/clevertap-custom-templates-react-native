import React, {useEffect} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Image,
  TextInput,
  ScrollView,
  TouchableOpacity,
  FlatList,
} from 'react-native';

import CoachMarkHelper from './CustomTemplatesHelper';

const CleverTap = require('clevertap-react-native');

const CoachMarksScreen = () => {
  CleverTap.setDebugLevel(3);

  useEffect(() => {
    CleverTap.setDebugLevel(3);

    CleverTap.recordEvent('Karthiks Native Display Event');

    setTimeout(() => {
      CleverTap.getAllDisplayUnits((err, res) => {
        if (err) {
          console.log('Error fetching display units: ', err);
        } else {
          console.log('All Display Units: ', res[0]);
          console.log('wzrk_id: ', res[0].wzrk_id);
          CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
          CoachMarkHelper.showCoachMarks(JSON.stringify(res[0]), error => {
            if (error) {
              console.error('Error:', error);
            } else {
              console.log('Coach marks completed');
              CleverTap.pushDisplayUnitClickedEventForID(res[0].wzrk_id);
            }
          });
        }
      });
    }, 2000);
  }, []);

  const categories = [
    {
      id: '1',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
      title: 'Burgers',
    },
    {
      id: '2',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046781.png',
      title: 'Drinks',
    },
    {
      id: '3',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
      title: 'Fries',
    },
    {
      id: '4',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046785.png',
      title: 'Coffee',
    },
  ];

  const recommended = [
    {
      id: '1',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046771.png',
      title: 'Pizza',
    },
    {
      id: '2',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
      title: 'Burger',
    },
    {
      id: '3',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
      title: 'Fries',
    },
    {
      id: '4',
      image: 'https://cdn-icons-png.flaticon.com/512/1046/1046789.png',
      title: 'Soda',
    },
  ];

  const renderCard = item => (
    <View style={styles.cardView}>
      <Image source={{uri: item.image}} style={styles.cardImage} />
      <Text style={styles.cardTitle}>{item.title}</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.textContainer}>
          <Text style={styles.greeting}>Hello User</Text>
          <Text style={styles.subtitle}>Search and Order</Text>
        </View>
        <View style={styles.profileIconContainer}>
          <Image
            accessibilityLabel="profile_image"
            testID="profile_image"
            accessible={true}
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
            }}
            style={styles.profileIcon}
          />
        </View>
      </View>

      {/* Banner */}
      <Image
        source={{
          uri: 'https://img.freepik.com/free-vector/flat-design-fast-food-sale-banner_23-2149135966.jpg?semt=ais_hybrid',
        }}
        style={styles.banner}
      />

      {/* Search Bar */}
      <TextInput
        accessibilityLabel="search"
        testID="search"
        accessible={true}
        style={styles.searchInput}
        placeholder="Search your favorite food"
        placeholderTextColor="#999"
      />

      <ScrollView style={styles.scrollView}>
        {/* Categories Section */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Categories</Text>
          <TouchableOpacity>
            <Text style={styles.seeMore}>See more</Text>
          </TouchableOpacity>
        </View>
        <FlatList
          data={categories}
          renderItem={({item}) => renderCard(item)}
          keyExtractor={item => item.id}
          horizontal={false}
          numColumns={2}
          columnWrapperStyle={styles.rowStyle}
          contentContainerStyle={styles.contentContainer}
        />

        {/* Recommended Section */}
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Recommended</Text>
          <TouchableOpacity>
            <Text style={styles.seeMore}>See more</Text>
          </TouchableOpacity>
        </View>
        <FlatList
          data={recommended}
          renderItem={({item}) => renderCard(item)}
          keyExtractor={item => item.id}
          horizontal={false}
          numColumns={2}
          columnWrapperStyle={styles.rowStyle}
          contentContainerStyle={styles.contentContainer}
        />
      </ScrollView>

      {/* Bottom Navigation Bar */}
      <View style={styles.bottomNav}>
        <TouchableOpacity style={styles.navItem}>
          <Image
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/1946/1946436.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Home</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem}>
          <Image
            accessibilityLabel="cart"
            testID="cart"
            accessible={true}
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/833/833314.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Cart</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem}>
          <Image
            accessibilityLabel="support_help"
            testID="support_help"
            accessible={true}
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/1828/1828919.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Help</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem}>
          <Image
            accessibilityLabel="settings"
            testID="settings"
            accessible={true}
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Settings</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFF',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 10,
    paddingVertical: 5,
  },
  textContainer: {
    flex: 1,
  },
  greeting: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
  },
  subtitle: {
    fontSize: 12,
    color: '#666',
  },
  profileIconContainer: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#F3F3F3',
    justifyContent: 'center',
    alignItems: 'center',
  },
  profileIcon: {
    width: 30,
    height: 30,
    borderRadius: 15,
  },
  banner: {
    width: '100%',
    height: 120,
    borderRadius: 10,
    marginBottom: 10,
  },
  searchInput: {
    backgroundColor: '#F3F3F3',
    borderRadius: 8,
    paddingHorizontal: 10,
    paddingVertical: 8,
    fontSize: 14,
    color: '#333',
    marginHorizontal: 10,
    marginBottom: 10,
  },
  scrollView: {
    flex: 1,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginHorizontal: 10,
    marginBottom: 10,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
  },
  seeMore: {
    fontSize: 14,
    color: '#007BFF',
  },
  cardView: {
    flex: 1,
    margin: 5,
    backgroundColor: '#FFF',
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 10,
    elevation: 4,
  },
  cardImage: {
    width: 50,
    height: 50,
    marginBottom: 10,
  },
  cardTitle: {
    fontSize: 14,
    fontWeight: 'bold',
    textAlign: 'center',
    color: '#333',
  },
  rowStyle: {
    justifyContent: 'space-between',
    paddingHorizontal: 10,
  },
  contentContainer: {
    paddingBottom: 20,
  },
  bottomNav: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    backgroundColor: '#FFF',
    paddingVertical: 10,
    elevation: 8,
  },
  navItem: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  navIcon: {
    width: 24,
    height: 24,
    marginBottom: 5,
  },
  navText: {
    fontSize: 12,
    color: '#333',
  },
});

export default CoachMarksScreen;
