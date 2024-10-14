import 'dart:async';

import 'package:anime_more/entity/provider_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simplytranslate/simplytranslate.dart';

class TranslatorNotifier extends AsyncNotifier<String> {
  late final SimplyTranslator translator;
  TranslatorNotifier() {
    translator = SimplyTranslator(EngineType.google);
  }
  @override
  build() async {
    return '';
  }

  Future<void> translate(text) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await translator
          .translateLingva(text, 'en',
              ref.watch(ProviderRepository.languageProvider), InstanceMode.Loop)
          .then((translation) => translation[0]);
    });
  }
}
