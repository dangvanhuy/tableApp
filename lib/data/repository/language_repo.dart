import 'package:citgroupvn_efood_table/data/model/response/language_model.dart';
import 'package:citgroupvn_efood_table/app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({required BuildContext context}) {
    return AppConstants.languages;
  }
}