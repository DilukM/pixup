import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:pixup/screens/home.dart';
import 'package:pixup/screens/liked_screen.dart';
import 'package:pixup/screens/profile_screen.dart';
import 'package:pixup/screens/search_screen.dart';
import 'package:pixup/util/Colors/colors.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  MainScreen.withIndex({super.key, required this.initialIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedIndex;
  late TabController tabController;

  @override
  void initState() {
    _selectedIndex = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != _selectedIndex && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      _selectedIndex = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  static List<Widget> _pages = <Widget>[
    HomePage(),
    SearchScreen(),
    LikedScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomBar(
        child: TabBar(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.all(12)
              : EdgeInsets.all(3),
          dividerColor: Colors.transparent,
          unselectedLabelColor: Theme.of(context).colorScheme.surface,
          indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
          controller: tabController,
          tabs: [
            Tab(icon: Icon(Icons.home_outlined)),
            Tab(icon: Icon(Icons.search)),
            Tab(icon: Icon(Icons.favorite_border)),
            Tab(icon: Icon(Icons.person_outlined)),
          ],
          onTap: _onItemTapped,
        ),
        width: MediaQuery.of(context).size.width * 0.8,
        fit: StackFit.loose,
        borderRadius: BorderRadius.circular(500),
        barColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
        hideOnScroll: true,
        body: (context, controller) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _pages[_selectedIndex],
        ),
      ),
    );
  }
}