import 'package:campusmart/features/bottomNavBar/listings/view/listing_screen.dart';
import 'package:campusmart/features/bottomNavBar/navbar_controller..dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class BottomBarC extends ConsumerWidget {
  const BottomBarC({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentScreen = ref.watch(currentScreenProvider);
    List<Widget> screens = [
  ListingsScreen(),
  // BookMarkScreen(),
  // OrderScreen(),
  // ProfileScreen(),
];
   return Scaffold(
    body: IndexedStack(
      index: currentScreen,
      children: screens
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: ref.watch(currentScreenProvider) ?? 0,
      onDestinationSelected: (int index) {
        navigateTo(ref, index);
      },
      destinations: [
          NavigationDestination(
            selectedIcon: Icon(Iconsax.home),
            icon: Icon(Iconsax.home_copy),
            label: 'Home',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.bookmark),
            icon: Icon(Iconsax.bookmark_copy),
            label: 'Notifications',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.bookmark),
            icon: Icon(Iconsax.bookmark_copy),
            label: 'Orders',
          ),
          const NavigationDestination(
            selectedIcon: Icon(Iconsax.profile_2user),
            icon: Icon(Iconsax.profile_2user_copy),
            label: 'Profile',
          ),
        ],
    ),
   );
  }
}



// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     var btmNavBarProvider = Provider.of<BtmNavbarProvider>(context);
//     return Scaffold(
//       body: IndexedStack(
//         index: btmNavBarProvider.selectedIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: NavigationBar(
//         indicatorColor: Color(0xff8E6CEF),
//         selectedIndex: btmNavBarProvider.selectedIndex,
//         onDestinationSelected: btmNavBarProvider.changeIndex,
        
//       ),
      
//     );
//   }
// }
