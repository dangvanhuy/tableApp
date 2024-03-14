import 'package:citgroupvn_efood_table/app/components/button/custom_rounded_button.dart';
import 'package:citgroupvn_efood_table/app/core/common/dialog/dia_logs.dart';
import 'package:citgroupvn_efood_table/app/core/common/dialog/dialog_icon_button.dart';
import 'package:citgroupvn_efood_table/app/core/common/menu/common_scaffold.dart';
import 'package:citgroupvn_efood_table/app/core/constants/color_constants.dart';
import 'package:citgroupvn_efood_table/app/resources/theme/app_text_style.dart';
import 'package:citgroupvn_efood_table/presentation/controller/theme/theme_controller.dart';
import 'package:citgroupvn_efood_table/presentation/screens/cart/cart.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/payment.dart';
import 'package:citgroupvn_efood_table/presentation/screens/order/widget/order_success_screen.dart';
import 'package:citgroupvn_efood_table/presentation/screens/promotional_page/widget/setting_widget.dart';
import 'package:citgroupvn_efood_table/presentation/screens/settings/setting_item.dart';
import 'package:citgroupvn_efood_table/presentation/screens/settings/setting_switch.dart';
import 'package:ionicons/ionicons.dart';

import '../../controller/settings/settings_controller.dart';

class SettingsView extends BaseView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "Cài đặt",
                  style: AppTextStyle.textTitleAppBar,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Cài đặt",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Ngôn ngữ",
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: "Tiếng việt",
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Đổi chế độ",
                icon: Ionicons.moon,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () => Get.find<ThemeController>().toggleTheme(),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Trung tâm hỗ trợ",
                icon: Ionicons.person,
                bgColor: Colors.green,
                iconColor: Colors.white,
                onTap: () {
                  // Get.to(() => SupportCenterPage());
                },
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Điều khoản và Chính sách",
                icon: Ionicons.book_outline,
                bgColor: Colors.grey,
                iconColor: Colors.white,
                onTap: () {
                  // Get.to(() => TermsAndPrivacyPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
