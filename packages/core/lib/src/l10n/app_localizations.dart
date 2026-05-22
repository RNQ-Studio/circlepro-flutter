import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// Nama aplikasi
  ///
  /// In id, this message translates to:
  /// **'Flutter Starter'**
  String get appName;

  /// Label halaman beranda
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// Label halaman pengaturan
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settings;

  /// Teks sambutan di halaman beranda
  ///
  /// In id, this message translates to:
  /// **'Selamat datang!'**
  String get welcome;

  /// Judul seksi tampilan di settings
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get appearance;

  /// Pilihan tema: ikuti sistem
  ///
  /// In id, this message translates to:
  /// **'Ikuti sistem'**
  String get themeSystem;

  /// Pilihan tema: terang
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get themeLight;

  /// Pilihan tema: gelap
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get themeDark;

  /// Subjudul mode gelap di variant settings
  ///
  /// In id, this message translates to:
  /// **'Tampilan gelap'**
  String get themeDarkSubtitle;

  /// Judul seksi bahasa di settings
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// Pilihan bahasa: Indonesia
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get langIndonesia;

  /// Pilihan bahasa: Inggris
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// Subjudul pilihan bahasa Inggris di variant settings
  ///
  /// In id, this message translates to:
  /// **'Use English language'**
  String get langEnglishSubtitle;

  /// Label versi di settings
  ///
  /// In id, this message translates to:
  /// **'Versi'**
  String get version;

  /// Label versi aplikasi di variant settings
  ///
  /// In id, this message translates to:
  /// **'Versi Aplikasi'**
  String get appVersion;

  /// Judul halaman login
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signIn;

  /// Tombol OK
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get ok;

  /// Tombol batal
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// Tombol simpan
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// Tombol hapus
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get delete;

  /// Teks loading
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get loading;

  /// Pesan error umum
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Coba lagi.'**
  String get errorGeneral;

  /// Pesan error jaringan
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet.'**
  String get errorNetwork;

  /// Validasi email tidak valid
  ///
  /// In id, this message translates to:
  /// **'Masukkan email yang valid'**
  String get errorInvalidEmail;

  /// Validasi password terlalu pendek
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter'**
  String get errorPasswordTooShort;

  /// Tombol masuk
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get login;

  /// Tombol keluar
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// Tombol daftar
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get register;

  /// Label email
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// Label kata sandi
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get password;

  /// Label halaman profil
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profile;

  /// Label nama pengguna
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get name;

  /// Konfirmasi dialog logout
  ///
  /// In id, this message translates to:
  /// **'Yakin ingin keluar?'**
  String get logoutConfirm;

  /// No description provided for @galleryTitle.
  ///
  /// In id, this message translates to:
  /// **'UI Component Gallery'**
  String get galleryTitle;

  /// No description provided for @gallerySubtitle.
  ///
  /// In id, this message translates to:
  /// **'8 kategori komponen interaktif'**
  String get gallerySubtitle;

  /// No description provided for @galleryMenuDialogTitle.
  ///
  /// In id, this message translates to:
  /// **'Dialog & Popup'**
  String get galleryMenuDialogTitle;

  /// No description provided for @galleryMenuDialogSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Alert, bottom sheet, custom dialog'**
  String get galleryMenuDialogSubtitle;

  /// No description provided for @galleryMenuFormTitle.
  ///
  /// In id, this message translates to:
  /// **'Form & Input'**
  String get galleryMenuFormTitle;

  /// No description provided for @galleryMenuFormSubtitle.
  ///
  /// In id, this message translates to:
  /// **'TextField, dropdown, date picker'**
  String get galleryMenuFormSubtitle;

  /// No description provided for @galleryMenuCardsTitle.
  ///
  /// In id, this message translates to:
  /// **'Cards & List'**
  String get galleryMenuCardsTitle;

  /// No description provided for @galleryMenuCardsSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Card variants dan dismissible list'**
  String get galleryMenuCardsSubtitle;

  /// No description provided for @galleryMenuNavTitle.
  ///
  /// In id, this message translates to:
  /// **'Navigation'**
  String get galleryMenuNavTitle;

  /// No description provided for @galleryMenuNavSubtitle.
  ///
  /// In id, this message translates to:
  /// **'TabBar, stepper, drawer demo'**
  String get galleryMenuNavSubtitle;

  /// No description provided for @galleryMenuLoadingTitle.
  ///
  /// In id, this message translates to:
  /// **'Loading & Empty'**
  String get galleryMenuLoadingTitle;

  /// No description provided for @galleryMenuLoadingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Shimmer, progress, empty states'**
  String get galleryMenuLoadingSubtitle;

  /// No description provided for @galleryMenuAnimTitle.
  ///
  /// In id, this message translates to:
  /// **'Animation'**
  String get galleryMenuAnimTitle;

  /// No description provided for @galleryMenuAnimSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hero, animated container, stagger'**
  String get galleryMenuAnimSubtitle;

  /// No description provided for @galleryMenuFeedbackTitle.
  ///
  /// In id, this message translates to:
  /// **'Feedback'**
  String get galleryMenuFeedbackTitle;

  /// No description provided for @galleryMenuFeedbackSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Rating, like, poll, OTP input'**
  String get galleryMenuFeedbackSubtitle;

  /// No description provided for @galleryMenuUtilitiesTitle.
  ///
  /// In id, this message translates to:
  /// **'Utilities'**
  String get galleryMenuUtilitiesTitle;

  /// No description provided for @galleryMenuUtilitiesSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Chip, badge, search, clipboard'**
  String get galleryMenuUtilitiesSubtitle;

  /// No description provided for @galleryDialogScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Dialog & Popup'**
  String get galleryDialogScreenTitle;

  /// No description provided for @galleryFormScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Form & Input Components'**
  String get galleryFormScreenTitle;

  /// No description provided for @galleryCardsScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Cards & List Variants'**
  String get galleryCardsScreenTitle;

  /// No description provided for @galleryNavScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Navigation & Tab Patterns'**
  String get galleryNavScreenTitle;

  /// No description provided for @galleryLoadingScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Loading & Empty States'**
  String get galleryLoadingScreenTitle;

  /// No description provided for @galleryAnimScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Animation Showcase'**
  String get galleryAnimScreenTitle;

  /// No description provided for @galleryFeedbackScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Feedback & Interaksi'**
  String get galleryFeedbackScreenTitle;

  /// No description provided for @galleryUtilitiesScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Utilities & Helpers'**
  String get galleryUtilitiesScreenTitle;

  /// No description provided for @galleryTabCards.
  ///
  /// In id, this message translates to:
  /// **'Cards'**
  String get galleryTabCards;

  /// No description provided for @galleryTabLists.
  ///
  /// In id, this message translates to:
  /// **'Lists'**
  String get galleryTabLists;

  /// No description provided for @galleryTabTabBar.
  ///
  /// In id, this message translates to:
  /// **'Tab Bar'**
  String get galleryTabTabBar;

  /// No description provided for @galleryTabBottomNav.
  ///
  /// In id, this message translates to:
  /// **'Bottom Nav'**
  String get galleryTabBottomNav;

  /// No description provided for @galleryTabStepper.
  ///
  /// In id, this message translates to:
  /// **'Stepper'**
  String get galleryTabStepper;

  /// No description provided for @galleryTabDrawer.
  ///
  /// In id, this message translates to:
  /// **'Drawer'**
  String get galleryTabDrawer;

  /// No description provided for @galleryTabLoading.
  ///
  /// In id, this message translates to:
  /// **'Loading'**
  String get galleryTabLoading;

  /// No description provided for @galleryTabEmptyState.
  ///
  /// In id, this message translates to:
  /// **'Empty State'**
  String get galleryTabEmptyState;

  /// No description provided for @gallerySectionAlertDialogs.
  ///
  /// In id, this message translates to:
  /// **'Alert Dialogs'**
  String get gallerySectionAlertDialogs;

  /// No description provided for @gallerySectionAlertDialogsDesc.
  ///
  /// In id, this message translates to:
  /// **'Berbagai jenis alert dialog'**
  String get gallerySectionAlertDialogsDesc;

  /// No description provided for @gallerySectionBottomSheets.
  ///
  /// In id, this message translates to:
  /// **'Bottom Sheets'**
  String get gallerySectionBottomSheets;

  /// No description provided for @gallerySectionBottomSheetsDesc.
  ///
  /// In id, this message translates to:
  /// **'Modal sheet dari bawah layar'**
  String get gallerySectionBottomSheetsDesc;

  /// No description provided for @gallerySectionCustomDialogs.
  ///
  /// In id, this message translates to:
  /// **'Custom Dialogs'**
  String get gallerySectionCustomDialogs;

  /// No description provided for @gallerySectionCustomDialogsDesc.
  ///
  /// In id, this message translates to:
  /// **'Dialog animasi dan loading'**
  String get gallerySectionCustomDialogsDesc;

  /// No description provided for @gallerySectionSnackbarVariants.
  ///
  /// In id, this message translates to:
  /// **'SnackBar Variants'**
  String get gallerySectionSnackbarVariants;

  /// No description provided for @gallerySectionSnackbarVariantsDesc.
  ///
  /// In id, this message translates to:
  /// **'Info, sukses, warning, error'**
  String get gallerySectionSnackbarVariantsDesc;

  /// No description provided for @gallerySectionTextFields.
  ///
  /// In id, this message translates to:
  /// **'Text Fields'**
  String get gallerySectionTextFields;

  /// No description provided for @gallerySectionTextFieldsDesc.
  ///
  /// In id, this message translates to:
  /// **'Berbagai jenis input teks'**
  String get gallerySectionTextFieldsDesc;

  /// No description provided for @gallerySectionSelectors.
  ///
  /// In id, this message translates to:
  /// **'Selectors'**
  String get gallerySectionSelectors;

  /// No description provided for @gallerySectionSelectorsDesc.
  ///
  /// In id, this message translates to:
  /// **'Dropdown, date picker, radio, checkbox'**
  String get gallerySectionSelectorsDesc;

  /// No description provided for @gallerySectionTogglesSliders.
  ///
  /// In id, this message translates to:
  /// **'Toggles & Sliders'**
  String get gallerySectionTogglesSliders;

  /// No description provided for @gallerySectionTogglesSlidersDesc.
  ///
  /// In id, this message translates to:
  /// **'Switch dan range input'**
  String get gallerySectionTogglesSlidersDesc;

  /// No description provided for @gallerySectionShimmer.
  ///
  /// In id, this message translates to:
  /// **'1. Shimmer Loading'**
  String get gallerySectionShimmer;

  /// No description provided for @gallerySectionShimmerDesc.
  ///
  /// In id, this message translates to:
  /// **'Manual tanpa library, ShaderMask + LinearGradient'**
  String get gallerySectionShimmerDesc;

  /// No description provided for @gallerySectionSkeleton.
  ///
  /// In id, this message translates to:
  /// **'2. Skeleton Screen'**
  String get gallerySectionSkeleton;

  /// No description provided for @gallerySectionSkeletonDesc.
  ///
  /// In id, this message translates to:
  /// **'Layout placeholder sebelum konten siap'**
  String get gallerySectionSkeletonDesc;

  /// No description provided for @gallerySectionLinearProgress.
  ///
  /// In id, this message translates to:
  /// **'3. Linear Progress Indicator'**
  String get gallerySectionLinearProgress;

  /// No description provided for @gallerySectionLinearProgressDesc.
  ///
  /// In id, this message translates to:
  /// **'Determinate, 0–100% dalam 3 detik'**
  String get gallerySectionLinearProgressDesc;

  /// No description provided for @gallerySectionCircularProgress.
  ///
  /// In id, this message translates to:
  /// **'4. Circular Progress'**
  String get gallerySectionCircularProgress;

  /// No description provided for @gallerySectionCircularProgressDesc.
  ///
  /// In id, this message translates to:
  /// **'Determinate dengan % di tengah'**
  String get gallerySectionCircularProgressDesc;

  /// No description provided for @gallerySectionPullToRefresh.
  ///
  /// In id, this message translates to:
  /// **'5. Pull-to-Refresh'**
  String get gallerySectionPullToRefresh;

  /// No description provided for @gallerySectionPullToRefreshDesc.
  ///
  /// In id, this message translates to:
  /// **'Tarik ke bawah untuk refresh list'**
  String get gallerySectionPullToRefreshDesc;

  /// No description provided for @gallerySectionEmptyNoData.
  ///
  /// In id, this message translates to:
  /// **'6. Empty State — Tidak Ada Data'**
  String get gallerySectionEmptyNoData;

  /// No description provided for @gallerySectionEmptyNoDataDesc.
  ///
  /// In id, this message translates to:
  /// **'Ilustrasi + CTA'**
  String get gallerySectionEmptyNoDataDesc;

  /// No description provided for @gallerySectionEmptyNoInternet.
  ///
  /// In id, this message translates to:
  /// **'7. Empty State — Tidak Ada Koneksi'**
  String get gallerySectionEmptyNoInternet;

  /// No description provided for @gallerySectionEmptyNoInternetDesc.
  ///
  /// In id, this message translates to:
  /// **'Retry dengan loading simulasi'**
  String get gallerySectionEmptyNoInternetDesc;

  /// No description provided for @gallerySectionEmptyError.
  ///
  /// In id, this message translates to:
  /// **'8. Empty State — Error'**
  String get gallerySectionEmptyError;

  /// No description provided for @gallerySectionEmptyErrorDesc.
  ///
  /// In id, this message translates to:
  /// **'Something went wrong'**
  String get gallerySectionEmptyErrorDesc;

  /// No description provided for @gallerySectionHeroAnim.
  ///
  /// In id, this message translates to:
  /// **'1. Hero Animation'**
  String get gallerySectionHeroAnim;

  /// No description provided for @gallerySectionHeroAnimDesc.
  ///
  /// In id, this message translates to:
  /// **'Tap kotak untuk navigasi dengan Hero transition'**
  String get gallerySectionHeroAnimDesc;

  /// No description provided for @gallerySectionAnimContainer.
  ///
  /// In id, this message translates to:
  /// **'2. Animated Container'**
  String get gallerySectionAnimContainer;

  /// No description provided for @gallerySectionAnimContainerDesc.
  ///
  /// In id, this message translates to:
  /// **'Toggle ukuran, warna, border radius'**
  String get gallerySectionAnimContainerDesc;

  /// No description provided for @gallerySectionPageTransition.
  ///
  /// In id, this message translates to:
  /// **'3. Page Transition Custom'**
  String get gallerySectionPageTransition;

  /// No description provided for @gallerySectionPageTransitionDesc.
  ///
  /// In id, this message translates to:
  /// **'Fade, slide, scale'**
  String get gallerySectionPageTransitionDesc;

  /// No description provided for @gallerySectionAnimatedList.
  ///
  /// In id, this message translates to:
  /// **'4. Animated List'**
  String get gallerySectionAnimatedList;

  /// No description provided for @gallerySectionAnimatedListDesc.
  ///
  /// In id, this message translates to:
  /// **'Tambah dan hapus item dengan animasi'**
  String get gallerySectionAnimatedListDesc;

  /// No description provided for @gallerySectionAnimatedIcons.
  ///
  /// In id, this message translates to:
  /// **'5. Animated Icons'**
  String get gallerySectionAnimatedIcons;

  /// No description provided for @gallerySectionAnimatedIconsDesc.
  ///
  /// In id, this message translates to:
  /// **'Toggle animasi ikon Flutter bawaan'**
  String get gallerySectionAnimatedIconsDesc;

  /// No description provided for @gallerySectionStaggered.
  ///
  /// In id, this message translates to:
  /// **'6. Staggered Animation'**
  String get gallerySectionStaggered;

  /// No description provided for @gallerySectionStaggeredDesc.
  ///
  /// In id, this message translates to:
  /// **'Card muncul satu per satu dengan delay'**
  String get gallerySectionStaggeredDesc;

  /// No description provided for @gallerySectionStarRating.
  ///
  /// In id, this message translates to:
  /// **'1. Star Rating'**
  String get gallerySectionStarRating;

  /// No description provided for @gallerySectionStarRatingDesc.
  ///
  /// In id, this message translates to:
  /// **'Tap atau drag untuk beri rating'**
  String get gallerySectionStarRatingDesc;

  /// No description provided for @gallerySectionLikeButton.
  ///
  /// In id, this message translates to:
  /// **'2. Like Button'**
  String get gallerySectionLikeButton;

  /// No description provided for @gallerySectionLikeButtonDesc.
  ///
  /// In id, this message translates to:
  /// **'Animasi pop saat di-tap'**
  String get gallerySectionLikeButtonDesc;

  /// No description provided for @gallerySectionReactionPicker.
  ///
  /// In id, this message translates to:
  /// **'3. Reaction Picker'**
  String get gallerySectionReactionPicker;

  /// No description provided for @gallerySectionReactionPickerDesc.
  ///
  /// In id, this message translates to:
  /// **'Long press untuk emoji reactions'**
  String get gallerySectionReactionPickerDesc;

  /// No description provided for @gallerySectionCommentInput.
  ///
  /// In id, this message translates to:
  /// **'4. Comment Input'**
  String get gallerySectionCommentInput;

  /// No description provided for @gallerySectionCommentInputDesc.
  ///
  /// In id, this message translates to:
  /// **'Kirim komentar, masuk ke list'**
  String get gallerySectionCommentInputDesc;

  /// No description provided for @gallerySectionQuickPoll.
  ///
  /// In id, this message translates to:
  /// **'5. Quick Poll'**
  String get gallerySectionQuickPoll;

  /// No description provided for @gallerySectionQuickPollDesc.
  ///
  /// In id, this message translates to:
  /// **'Pilih satu opsi, lihat hasil persentase'**
  String get gallerySectionQuickPollDesc;

  /// No description provided for @gallerySectionOtpInput.
  ///
  /// In id, this message translates to:
  /// **'6. OTP / PIN Input'**
  String get gallerySectionOtpInput;

  /// No description provided for @gallerySectionOtpInputDesc.
  ///
  /// In id, this message translates to:
  /// **'Coba masukkan 123456'**
  String get gallerySectionOtpInputDesc;

  /// No description provided for @gallerySectionChipVariants.
  ///
  /// In id, this message translates to:
  /// **'1. Chip Variants'**
  String get gallerySectionChipVariants;

  /// No description provided for @gallerySectionChipVariantsDesc.
  ///
  /// In id, this message translates to:
  /// **'Input, filter, action, choice chip'**
  String get gallerySectionChipVariantsDesc;

  /// No description provided for @gallerySectionBadge.
  ///
  /// In id, this message translates to:
  /// **'2. Badge & Notification Dot'**
  String get gallerySectionBadge;

  /// No description provided for @gallerySectionBadgeDesc.
  ///
  /// In id, this message translates to:
  /// **'Angka badge +1 / reset'**
  String get gallerySectionBadgeDesc;

  /// No description provided for @gallerySectionSearchFilter.
  ///
  /// In id, this message translates to:
  /// **'3. Search Bar + Filter'**
  String get gallerySectionSearchFilter;

  /// No description provided for @gallerySectionSearchFilterDesc.
  ///
  /// In id, this message translates to:
  /// **'Filter list real-time saat mengetik'**
  String get gallerySectionSearchFilterDesc;

  /// No description provided for @gallerySectionTooltip.
  ///
  /// In id, this message translates to:
  /// **'4. Tooltip'**
  String get gallerySectionTooltip;

  /// No description provided for @gallerySectionTooltipDesc.
  ///
  /// In id, this message translates to:
  /// **'Long press untuk lihat tooltip custom'**
  String get gallerySectionTooltipDesc;

  /// No description provided for @gallerySectionClipboard.
  ///
  /// In id, this message translates to:
  /// **'5. Copy to Clipboard'**
  String get gallerySectionClipboard;

  /// No description provided for @gallerySectionClipboardDesc.
  ///
  /// In id, this message translates to:
  /// **'Tap salin untuk copy token/kode'**
  String get gallerySectionClipboardDesc;

  /// No description provided for @gallerySectionImagePicker.
  ///
  /// In id, this message translates to:
  /// **'6. Image Picker Placeholder'**
  String get gallerySectionImagePicker;

  /// No description provided for @gallerySectionImagePickerDesc.
  ///
  /// In id, this message translates to:
  /// **'Tap area foto untuk opsi pilih gambar'**
  String get gallerySectionImagePickerDesc;

  /// No description provided for @gallerySectionColorPicker.
  ///
  /// In id, this message translates to:
  /// **'7. Color Picker'**
  String get gallerySectionColorPicker;

  /// No description provided for @gallerySectionColorPickerDesc.
  ///
  /// In id, this message translates to:
  /// **'Tap palet warna untuk pilih warna'**
  String get gallerySectionColorPickerDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
