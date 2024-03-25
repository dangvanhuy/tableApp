import 'package:citgroupvn_efood_table/app/modules/login/controllers/login_controller.dart';
import 'package:citgroupvn_efood_table/app/modules/login/views/login_view.dart';
import 'package:citgroupvn_efood_table/app/modules/main_tabview/main_tabview.dart';
import 'package:citgroupvn_efood_table/app/modules/splash/check_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with WidgetsBindingObserver {
//   late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);

//     bool firstTime = true;
//     _onConnectivityChanged = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (!firstTime) {
//         bool isNotConnected = result != ConnectivityResult.wifi &&
//             result != ConnectivityResult.mobile;
//         isNotConnected
//             ? const SizedBox()
//             : ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: isNotConnected ? Colors.red : Colors.green,
//           duration: Duration(seconds: isNotConnected ? 6000 : 3),
//           content: Text(
//             isNotConnected ? 'no_connection' : 'connected',
//             textAlign: TextAlign.center,
//           ),
//         ));
//         if (!isNotConnected) {
//           _route();
//         }
//       }
//       firstTime = false;
//     });

//     Get.find<SplashController>().initSharedData();
//     // Get.find<SplashController>().removeSharedData();

//     Get.find<CartController>().getCartData();

//     _route();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (AppLifecycleState.resumed == state) {
//       if (Get.find<SplashController>().getBranchId() < 1) {
//         DialogHelper.openDialog(context, const SettingWidget(formSplash: true),
//             isDismissible: false);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     WidgetsBinding.instance.removeObserver(this);
//     _onConnectivityChanged.cancel();
//   }

//   void _route() {
//     Get.find<SplashController>().getConfigData().then((value) {
//       Timer(const Duration(seconds: 2), () async {
//         if (Get.find<SplashController>().getBranchId() < 1) {
//           Get.to(() => CheckInfoScreen());
//           // DialogHelper.openDialog(
//           //     context, const SettingWidget(formSplash: true),
//           //     isDismissible: false);
//         } else {
//           if (ResponsiveHelper.isTab(context) &&
//               (Get.find<PromotionalController>()
//                   .getPromotion('', all: true)
//                   .isNotEmpty)) {
//             Get.offAll(() => const PromotionalPageScreen());
//           } else {
//             Get.offNamed(Routes.maintabview);
//           }
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InkWell(
//         onTap: Get.find<SplashController>().getBranchId() < 1
//             ? () {
//                 DialogHelper.openDialog(
//                   context,
//                   const SettingWidget(formSplash: true),
//                   isDismissible: false,
//                 );
//               }
//             : null,
//         child: Stack(
//           children: [
//             Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(Images.splashImage, width: Get.height * 0.1),
//                   Image.asset(Images.logo, width: Get.height * 0.2),
//                 ],
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   width: Get.width,
//                   child: Lottie.asset(
//                     fit: BoxFit.fitWidth,
//                     Images.waveLoading,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    _checkCodeEntered();
    WidgetsBinding.instance.addObserver(this);
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Handle connectivity change
    });
    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    final loginController = Get.find<LoginController>();
    _route();
  }

  void _route() {
    Future.delayed(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? endpointApiUrl = prefs.getString('endpoint_api_url');
      String? accessToken = prefs.getString('token');

      if (endpointApiUrl == null || endpointApiUrl.isEmpty) {
        // Endpoint không tồn tại, chuyển hướng đến màn hình kiểm tra thông tin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CheckInfoScreen(),
          ),
        );
      } else if (accessToken != null && accessToken.isNotEmpty) {
        // Endpoint tồn tại và token đã được lưu, chuyển hướng đến trang chính
        Get.off(() => MainTabView());
      } else {
        // Endpoint tồn tại nhưng không có token, chuyển hướng đến màn hình đăng nhập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginView(),
          ),
        );
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (AppLifecycleState.resumed == state) {
      // Handle app lifecycle change
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _onConnectivityChanged.cancel();
  }

  Future<void> _checkCodeEntered() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool codeEntered = prefs.getBool('codeEntered') ?? false;
    if (codeEntered) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    if (ResponsiveHelper.isTab(context) &&
        (Get.find<PromotionalController>()
            .getPromotion('', all: true)
            .isNotEmpty)) {
      Get.offAll(() => const PromotionalPageScreen());
    } else {
      Get.offNamed(Routes.maintabview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Images.splashImage, width: Get.height * 0.1),
                  Image.asset(Images.logo, width: Get.height * 0.2),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: Get.width,
                  child: Lottie.asset(
                    fit: BoxFit.fitWidth,
                    Images.waveLoading,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
