import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/features/dashboard/data/model/user.dart';
import 'package:prudential_tems/features/home/presentation/widgets/top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:prudential_tems/providers/app_provider.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MainLayout({required this.child, super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  SideMenuController sideMenu = SideMenuController();
  List<String> menuItems=['Dashboard','Bookings','Environments','Projects'];

  bool isOpen = true;

  @override
  void initState() {
    super.initState();

    // Listen to route changes and update the selected menu item
    GoRouter.of(context).routerDelegate.addListener(() {
      final currentLocation =
          GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

      if (currentLocation == '/home') {
        sideMenu.changePage(0);
      } else if (currentLocation == '/bookings') {
        sideMenu.changePage(1);
      } else if (currentLocation == '/environment') {
        sideMenu.changePage(2);
      } else if (currentLocation == '/projects') {
        sideMenu.changePage(3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(usersProvider);
    return userData.when(
      data: (userData) {
        // debugPrint('build called');
        // if (_isFirstRun) {
        //   firstRunMethod(bookingData);
        //   _isFirstRun = false; // ✅ Prevents calling again
        // }
        return _buildContent(userData);
      },
      loading: () => const Center(child: CircularProgressIndicator()), // Show Loader
      error: (error, stackTrace) => Center(child: Text('Error: $error')), // Show Error
    );


  }

  Widget _buildContent(List<UserModel> userData) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopBarWidget(
          title: menuItems[sideMenu.currentPage],
          onPressed: () {
            setState(() {
              isOpen = !isOpen;
            });
            // sideMenu.open();
          },
          userList:userData,
        ),
      ),
      body: Row(
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              itemOuterPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              openSideMenuWidth: 240,
              compactSideMenuWidth: 80,
              hoverColor: AppColors.lightRed,
              selectedColor: AppColors.prudentialRed,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              unselectedTitleTextStyle: TextStyle(color: Colors.white),
              backgroundColor: AppColors.prudentialGray,

              iconSize: 20,
              itemBorderRadius: const BorderRadius.all(Radius.circular(5.0)),
              showTooltip: true,
              showHamburger: false,
              itemHeight: 50.0,
              itemInnerSpacing: 8.0,
              toggleColor: Colors.black54,
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.white,
              displayMode:
              isOpen
                  ? SideMenuDisplayMode.open
                  : SideMenuDisplayMode.compact,
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ),
                child: SelectableText(
                  'version: 1.0',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                iconWidget: Image.asset(
                  'assets/icons/dashboard_icon.png',
                  // Make sure the path is correct
                  width: 18, // Adjust size
                  height: 18,
                  color: Colors.white,
                ),
                onTap: (index, _) {
                  context.go('/home');
                  sideMenu.changePage(index);
                },
              ),
              SideMenuItem(
                title: 'Bookings',
                iconWidget: Image.asset(
                  'assets/icons/bookings_icon.png',
                  // Make sure the path is correct
                  width: 18, // Adjust size
                  height: 18,
                  color: Colors.white,
                ),
                onTap: (index, _) {
                  context.go('/bookings');
                  sideMenu.changePage(index);
                },
              ),
              SideMenuItem(
                title: 'Environment',
                iconWidget: Image.asset(
                  'assets/icons/environments_icon.png',
                  // Make sure the path is correct
                  width: 18, // Adjust size
                  color: Colors.white,
                  height: 18,
                ),
                onTap: (index, _) {
                  context.go('/environment');
                  sideMenu.changePage(index);
                },
              ),
              SideMenuItem(
                title: 'Projects',
                iconWidget: Image.asset(
                  'assets/icons/projects_icon.png',
                  // Make sure the path is correct
                  width: 18, // Adjust size
                  height: 18,
                  color: Colors.white,
                ),
                onTap: (index, _) {
                  context.go('/projects');
                  sideMenu.changePage(index);
                },
              ),
            ],
          ),
          const VerticalDivider(width: 0),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}