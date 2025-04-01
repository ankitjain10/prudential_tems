import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prudential_tems/config/constants.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/features/home/presentation/widgets/engine_tile_widget.dart';
import '../../../../core/app_navigation/routes.dart';
import '../viewmodels/user_view_model.dart';

class EngineListScreen extends ConsumerWidget {
  const EngineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineAsyncValue = ref.watch(userViewModelProvider);
    ref.read(userViewModelProvider.notifier).fetchEngineList();

    return const Placeholder();
    // return Scaffold(
    //   appBar: AppBar(
    //     leading: const Icon(Icons.home, color: Colors.white),
    //     title: const SelectableText(
    //       Constants.engineListText,
    //       style: TextStyle(
    //           fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
    //     ),
    //     actions: const [
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 14),
    //         child: Icon(Icons.search, color: Colors.white),
    //       ),
    //       Icon(Icons.more_vert, color: Colors.white),
    //     ],
    //     flexibleSpace: Container(
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [AppColors.primaryColor, AppColors.secondaryColor],
    //           begin: Alignment.topLeft,
    //           end: Alignment.bottomRight,
    //         ),
    //       ),
    //     ),
    //   ),
    //   body: engineAsyncValue.when(
    //     // 1. Loading State
    //     data: (engines) {
    //       if (engines.isEmpty) {
    //         return const Center(child: SelectableText(Constants.noEngineAvailableText));
    //       }

    //       // Determine the number of items per row based on the screen size
    //       double width = MediaQuery.of(context).size.width;
    //       int columns = (width > 600)
    //           ? 3
    //           : (width > 400)
    //               ? 2
    //               : 1; // 1 item for small screen, 2 for medium, 3 for large screens

    //       return Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: GridView.builder(
    //           scrollDirection: Axis.vertical,
    //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount:
    //                 columns, // Number of columns based on screen width
    //             crossAxisSpacing: 10,
    //             mainAxisSpacing: 10,
    //             childAspectRatio:
    //                 0.8, // Adjusted aspect ratio for better responsiveness
    //           ),
    //           itemCount: engines.length,
    //           itemBuilder: (context, index) {
    //             return EngineTileWidget(
    //               engine: engines[index],
    //               onTileSelected: () => Navigator.pushNamed(
    //                 context,
    //                 AppRoutes.engineDetailScreen,
    //                 arguments: engines[index],
    //               ),
    //             );
    //           },
    //         ),
    //       );
    //     },
    //     loading: () => const Center(child: CircularProgressIndicator()),

    //     // 2. Error State
    //     error: (error, stackTrace) {
    //       return Center(
    //         child: SelectableText(
    //           'Failed to load Engine: $error',
    //           style: const TextStyle(color: Colors.red),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
