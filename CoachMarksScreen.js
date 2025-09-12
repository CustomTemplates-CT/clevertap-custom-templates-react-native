// import React, {useEffect} from 'react';
// import {
//   StyleSheet,
//   Text,
//   View,
//   Image,
//   TextInput,
//   ScrollView,
//   TouchableOpacity,
//   FlatList,
// } from 'react-native';

// import CoachMarkHelper from './CustomTemplatesHelper';

// const CleverTap = require('clevertap-react-native');

// const CoachMarksScreen = () => {
//   CleverTap.setDebugLevel(3);

//   useEffect(() => {
//     CleverTap.setDebugLevel(3);

//     CleverTap.recordEvent('coachmarks_nd');

//     setTimeout(() => {
//       CleverTap.getAllDisplayUnits((err, res) => {
//         if (err) {
//           console.log('Error fetching display units: ', err);
//         } else {
//           console.log('All Display Units: ', res[0]);
//           console.log('wzrk_id: ', res[0].wzrk_id);
//           CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
//           CoachMarkHelper.showCoachMarks(JSON.stringify(res[0]), error => {
//             if (error) {
//               console.error('Error:', error);
//             } else {
//               console.log('Coach marks completed');
//               CleverTap.pushDisplayUnitClickedEventForID(res[0].wzrk_id);
//             }
//           });
//         }
//       });
//     }, 2000);
//   }, []);

//   const categories = [
//     {
//       id: '1',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
//       title: 'Burgers',
//     },
//     {
//       id: '2',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046781.png',
//       title: 'Drinks',
//     },
//     {
//       id: '3',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
//       title: 'Fries',
//     },
//     {
//       id: '4',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046785.png',
//       title: 'Coffee',
//     },
//   ];

//   const recommended = [
//     {
//       id: '1',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046771.png',
//       title: 'Pizza',
//     },
//     {
//       id: '2',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
//       title: 'Burger',
//     },
//     {
//       id: '3',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046786.png',
//       title: 'Fries',
//     },
//     {
//       id: '4',
//       image: 'https://cdn-icons-png.flaticon.com/512/1046/1046789.png',
//       title: 'Soda',
//     },
//   ];

//   const renderCard = item => (
//     <View style={styles.cardView}>
//       <Image source={{uri: item.image}} style={styles.cardImage} />
//       <Text style={styles.cardTitle}>{item.title}</Text>
//     </View>
//   );

//   return (
//     <View style={styles.container}>
//       {/* Header */}
//       <View style={styles.header}>
//         <View style={styles.textContainer}>
//           <Text style={styles.greeting}>Hello User</Text>
//           <Text style={styles.subtitle}>Search and Order</Text>
//         </View>
//         <View style={styles.profileIconContainer}>
//           <Image
//             nativeID="profile_image"
//             source={{
//               uri: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
//             }}
//             style={styles.profileIcon}
//           />
//         </View>
//       </View>

//       {/* Banner */}
//       <Image
//         source={{
//           uri: 'https://img.freepik.com/free-vector/flat-design-fast-food-sale-banner_23-2149135966.jpg?semt=ais_hybrid',
//         }}
//         style={styles.banner}
//       />

//       {/* Search Bar */}
//       <TextInput
//         nativeID="search"
//         style={styles.searchInput}
//         placeholder="Search your favorite food"
//         placeholderTextColor="#999"
//       />

//       <ScrollView style={styles.scrollView}>
//         {/* Categories Section */}
//         <View style={styles.sectionHeader}>
//           <Text style={styles.sectionTitle}>Categories</Text>
//           <TouchableOpacity>
//             <Text style={styles.seeMore}>See more</Text>
//           </TouchableOpacity>
//         </View>
//         <FlatList
//           data={categories}
//           renderItem={({item}) => renderCard(item)}
//           keyExtractor={item => item.id}
//           horizontal={false}
//           numColumns={2}
//           columnWrapperStyle={styles.rowStyle}
//           contentContainerStyle={styles.contentContainer}
//         />

//         {/* Recommended Section */}
//         <View style={styles.sectionHeader}>
//           <Text style={styles.sectionTitle}>Recommended</Text>
//           <TouchableOpacity>
//             <Text style={styles.seeMore}>See more</Text>
//           </TouchableOpacity>
//         </View>
//         <FlatList
//           data={recommended}
//           renderItem={({item}) => renderCard(item)}
//           keyExtractor={item => item.id}
//           horizontal={false}
//           numColumns={2}
//           columnWrapperStyle={styles.rowStyle}
//           contentContainerStyle={styles.contentContainer}
//         />
//       </ScrollView>

//       {/* Bottom Navigation Bar */}
//       <View style={styles.bottomNav}>
//         <TouchableOpacity style={styles.navItem}>
//           <Image
//             source={{
//               uri: 'https://cdn-icons-png.flaticon.com/512/1946/1946436.png',
//             }}
//             style={styles.navIcon}
//           />
//           <Text style={styles.navText}>Home</Text>
//         </TouchableOpacity>
//         <TouchableOpacity style={styles.navItem}>
//           <Image
//             nativeID="cart"
//             source={{
//               uri: 'https://cdn-icons-png.flaticon.com/512/833/833314.png',
//             }}
//             style={styles.navIcon}
//           />
//           <Text style={styles.navText}>Cart</Text>
//         </TouchableOpacity>
//         <TouchableOpacity style={styles.navItem}>
//           <Image
//             nativeID="support_help"
//             source={{
//               uri: 'https://cdn-icons-png.flaticon.com/512/1828/1828919.png',
//             }}
//             style={styles.navIcon}
//           />
//           <Text style={styles.navText}>Help</Text>
//         </TouchableOpacity>
//         <TouchableOpacity style={styles.navItem}>
//           <Image
//             nativeID="settings"
//             source={{
//               uri: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
//             }}
//             style={styles.navIcon}
//           />
//           <Text style={styles.navText}>Settings</Text>
//         </TouchableOpacity>
//       </View>
//     </View>
//   );
// };

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     backgroundColor: '#FFF',
//   },
//   header: {
//     flexDirection: 'row',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     paddingHorizontal: 10,
//     paddingVertical: 5,
//   },
//   textContainer: {
//     flex: 1,
//   },
//   greeting: {
//     fontSize: 16,
//     fontWeight: 'bold',
//     color: '#333',
//   },
//   subtitle: {
//     fontSize: 12,
//     color: '#666',
//   },
//   profileIconContainer: {
//     width: 40,
//     height: 40,
//     borderRadius: 20,
//     backgroundColor: '#F3F3F3',
//     justifyContent: 'center',
//     alignItems: 'center',
//   },
//   profileIcon: {
//     width: 30,
//     height: 30,
//     borderRadius: 15,
//   },
//   banner: {
//     width: '100%',
//     height: 120,
//     borderRadius: 10,
//     marginBottom: 10,
//   },
//   searchInput: {
//     backgroundColor: '#F3F3F3',
//     borderRadius: 8,
//     paddingHorizontal: 10,
//     paddingVertical: 8,
//     fontSize: 14,
//     color: '#333',
//     marginHorizontal: 10,
//     marginBottom: 10,
//   },
//   scrollView: {
//     flex: 1,
//   },
//   sectionHeader: {
//     flexDirection: 'row',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     marginHorizontal: 10,
//     marginBottom: 10,
//   },
//   sectionTitle: {
//     fontSize: 16,
//     fontWeight: 'bold',
//     color: '#333',
//   },
//   seeMore: {
//     fontSize: 14,
//     color: '#007BFF',
//   },
//   cardView: {
//     flex: 1,
//     margin: 5,
//     backgroundColor: '#FFF',
//     borderRadius: 10,
//     alignItems: 'center',
//     justifyContent: 'center',
//     padding: 10,
//     elevation: 4,
//   },
//   cardImage: {
//     width: 50,
//     height: 50,
//     marginBottom: 10,
//   },
//   cardTitle: {
//     fontSize: 14,
//     fontWeight: 'bold',
//     textAlign: 'center',
//     color: '#333',
//   },
//   rowStyle: {
//     justifyContent: 'space-between',
//     paddingHorizontal: 10,
//   },
//   contentContainer: {
//     paddingBottom: 20,
//   },
//   bottomNav: {
//     flexDirection: 'row',
//     justifyContent: 'space-around',
//     alignItems: 'center',
//     backgroundColor: '#FFF',
//     paddingVertical: 10,
//     elevation: 8,
//   },
//   navItem: {
//     justifyContent: 'center',
//     alignItems: 'center',
//   },
//   navIcon: {
//     width: 24,
//     height: 24,
//     marginBottom: 5,
//   },
//   navText: {
//     fontSize: 12,
//     color: '#333',
//   },
// });

// export default CoachMarksScreen;

import React, {useEffect, useRef} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Image,
  TextInput,
  ScrollView,
  TouchableOpacity,
  FlatList,
  Platform,
  findNodeHandle,
  NativeModules,
} from 'react-native';

import CoachMarkHelper from './CustomTemplatesHelper';

const CleverTap = require('clevertap-react-native');

const {SpotlightBridge} = NativeModules;

const CoachMarksScreen = () => {
  const profileImageRef = useRef(null);
  const searchRef = useRef(null);
  const cartRef = useRef(null);
  const supportHelpRef = useRef(null);
  const settingsRef = useRef(null);

  useEffect(() => {
    CleverTap.setDebugLevel(3);
    // CleverTap.recordEvent('coachmarks_nd');
    CleverTap.recordEvent('CoachmarksND');

    const getTargets = () => {
      const refs = [
        {ref: profileImageRef.current, name: 'profile_image'},
        {ref: searchRef.current, name: 'search'},
        {ref: cartRef.current, name: 'cart'},
        {ref: supportHelpRef.current, name: 'support_help'},
        {ref: settingsRef.current, name: 'settings'},
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
        if (Platform.OS === 'android') {
          console.log('🔹 [JS] Android tooltip flow');
          CleverTap.pushDisplayUnitViewedEventForID(res[0].wzrk_id);
          CoachMarkHelper.showCoachMarks(JSON.stringify(res[0]), error => {
            if (error) {
              console.error('Error:', error);
            } else {
              console.log('Coach marks completed');
              CleverTap.pushDisplayUnitClickedEventForID(res[0].wzrk_id);
            }
          });
        } else if (Platform.OS === 'ios') {
          console.log('🔹 [JS] iOS coachmarks flow');
          CleverTap.pushDisplayUnitViewedEventForID(displayUnit.wzrk_id);
          SpotlightBridge.showCoachmarks(JSON.stringify(displayUnit), targets)
            .then(res => {
              console.log('✅ [JS] coachmarks flow completed:', res);
              CleverTap.pushDisplayUnitClickedEventForID(displayUnit.wzrk_id);
            })
            .catch(err => {
              console.error('❌ [JS] coachmarks error:', err);
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
            ref={profileImageRef}
            nativeID="profile_image"
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
        ref={searchRef}
        nativeID="search"
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
            ref={cartRef}
            nativeID="cart"
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/833/833314.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Cart</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem}>
          <Image
            ref={supportHelpRef}
            nativeID="support_help"
            source={{
              uri: 'https://cdn-icons-png.flaticon.com/512/1828/1828919.png',
            }}
            style={styles.navIcon}
          />
          <Text style={styles.navText}>Help</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.navItem}>
          <Image
            ref={settingsRef}
            nativeID="settings"
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
