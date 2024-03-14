import 'package:get/get.dart';

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/maintabview/main_tabview.dart';
import '../../presentation/screens/order/oder_list/order_list_view.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../modules/main_tabview/bindings/main_tabview_binding.dart';
import '../modules/order_list/bindings/order_list_binding.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../../presentation/screens/settings/setting_view.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(name: Routes.initial, page: () => const SplashScreen()),
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: Routes.maintabview,
      page: () => MainTabView(),
      binding: MainTabviewBinding(),
    ),
    GetPage(
      name: Routes.orderList,
      page: () => const OrderListView(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
