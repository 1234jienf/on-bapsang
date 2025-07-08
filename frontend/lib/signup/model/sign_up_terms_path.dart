import '../provider/sign_up_language_provider.dart';

final signUpTermsPath = {
  SignUpLanguage.ko: {
    1: 'asset/terms/ko/terms_of_service.md',
    2: 'asset/terms/ko/privacy_consent.md',
    3: 'asset/terms/ko/location_service.md',
  },
  SignUpLanguage.en: {
    1: 'asset/terms/en/terms_of_service.md',
    2: 'asset/terms/en/privacy_consent.md',
    3: 'asset/terms/en/location_service.md',
  },
  SignUpLanguage.zh: {
    1: 'asset/terms/zh/terms_of_service.md',
    2: 'asset/terms/zh/privacy_consent.md',
    3: 'asset/terms/zh/location_service.md',
  },
  SignUpLanguage.jp: {
    1: 'asset/terms/jp/terms_of_service.md',
    2: 'asset/terms/jp/privacy_consent.md',
    3: 'asset/terms/jp/location_service.md',
  },
};

final termsTitles = {
  SignUpLanguage.ko: {
    1: '이용 약관',
    2: '개인정보 수집 및 이용 동의',
    3: '위치기반 서비스 이용 약관',
  },
  SignUpLanguage.en: {
    1: 'Terms of Service',
    2: 'Privacy Consent',
    3: 'Location-Based Terms',
  },
  SignUpLanguage.zh: {
    1: '服务条款',
    2: '隐私同意',
    3: '基于位置的服务条款',
  },
  SignUpLanguage.jp: {
    1: '利用規約',
    2: '個人情報の取扱い',
    3: '位置情報サービス利用規約',
  },
};