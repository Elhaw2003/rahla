import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/add_trip_request_model.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trip_manager_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trip_manager_states.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_states.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_bottom_action_bar.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_step1_basic_info.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_step2_price_dates.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_step3_media_services.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_step4_itinerary.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/add_trip_stepper_header.dart';

class AddTripPage extends StatefulWidget {
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  int _currentStep = 0;
  final ImagePicker _picker = ImagePicker();

  // Step 1: Basic Info
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedOrigin;
  String? _selectedDestination;

  // Step 2: Price, Dates & Capacity
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // Step 3: Media & Services
  XFile? _coverImageFile;
  final List<XFile> _galleryImageFiles = [];
  final _cancelPolicyController = TextEditingController();

  final List<String> _presetIncludedOptions = [
    'انتقالات مكيفة',
    'إقامة فندقية',
    'وجبات (إفطار وغداء)',
    'مرشد سياحي',
    'تذاكر دخول المزارات',
    'برنامج ترفيهي',
    'سهرة بدوية',
  ];
  final Set<String> _selectedIncluded = {'انتقالات مكيفة', 'إقامة فندقية'};
  final _customIncludedController = TextEditingController();

  final List<String> _presetExcludedOptions = [
    'المشروبات الإضافية',
    'المصاريف الشخصية',
    'الإكراميات (البقشيش)',
    'الألعاب المائية الفردية',
  ];
  final Set<String> _selectedExcluded = {'المصاريف الشخصية'};
  final _customExcludedController = TextEditingController();

  final List<Map<String, dynamic>> _days = [
    {
      'dayNumber': 1,
      'title': 'اليوم الأول: التجمع والاستقبال',
      'activities': [
        {
          'title': 'التحرك من نقطة التجمع',
          'description': 'التجمع والتحرك بالأتوبيسات المكيفة',
          'time': '06:00 ص',
          'location': 'ميدان التحرير',
          'imageFile': null as XFile?,
        },
      ],
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _cancelPolicyController.dispose();
    _customIncludedController.dispose();
    _customExcludedController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _coverImageFile = picked);
      }
    } catch (e) {
      debugPrint('Error picking cover image: $e');
    }
  }

  Future<void> _pickGalleryImages() async {
    try {
      final pickedList = await _picker.pickMultiImage();
      if (pickedList.isNotEmpty) {
        setState(() => _galleryImageFiles.addAll(pickedList));
      }
    } catch (e) {
      debugPrint('Error picking gallery images: $e');
    }
  }

  Future<void> _pickActivityImage(Map<String, dynamic> activity) async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => activity['imageFile'] = picked);
      }
    } catch (e) {
      debugPrint('Error picking activity image: $e');
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_titleController.text.trim().isEmpty ||
            _descriptionController.text.trim().isEmpty ||
            _selectedCategoryId == null ||
            _selectedOrigin == null ||
            _selectedDestination == null) {
          AppSnackbar.showError(
            context: context,
            message: 'أكمل بيانات الرحلة الأساسية',
          );
          return false;
        }
        return true;
      case 1:
        if (_priceController.text.trim().isEmpty ||
            _capacityController.text.trim().isEmpty ||
            _startDate == null ||
            _endDate == null) {
          AppSnackbar.showError(
            context: context,
            message: 'أكمل السعر والتواريخ والسعة',
          );
          return false;
        }
        return true;
      case 2:
        if (_selectedIncluded.isEmpty) {
          AppSnackbar.showError(
            context: context,
            message: 'اختر خدمة واحدة على الأقل مشمولة',
          );
          return false;
        }
        return true;
      case 3:
        if (_days.isEmpty) {
          AppSnackbar.showError(
            context: context,
            message: 'أضف يوم واحد على الأقل لبرنامج الرحلة',
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  CreateTripRequest _buildRequest() {
    final days = _days.map((day) {
      final activities = (day['activities'] as List<dynamic>)
          .map(
            (activity) => ActivityRequest(
              time: (activity['time'] as String?)?.trim() ?? '',
              title: (activity['title'] as String?)?.trim() ?? '',
              description: (activity['description'] as String?)?.trim() ?? '',
              location: (activity['location'] as String?)?.trim() ?? '',
            ),
          )
          .toList();

      return TripDayRequest(
        dayNumber: day['dayNumber'] as int? ?? 1,
        title: (day['title'] as String?)?.trim() ?? '',
        activities: activities,
      );
    }).toList();

    return CreateTripRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      origin: _selectedOrigin ?? '',
      destination: _selectedDestination ?? '',
      price: num.tryParse(_priceController.text.trim()) ?? 0,
      capacity: int.tryParse(_capacityController.text.trim()) ?? 0,
      category: _selectedCategoryId ?? '',
      startDate: _startDate,
      endDate: _endDate,
      status: 'published',
      isProtected: true,
      cancelPolicy: _cancelPolicyController.text.trim(),
      included: _selectedIncluded.toList(),
      excluded: _selectedExcluded.toList(),
      coverImage: _coverImageFile,
      gallery: List<XFile>.from(_galleryImageFiles),
      days: days,
    );
  }

  void _onNextPressed() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      return;
    }

    final request = _buildRequest();
    context.read<AdminTripManagerCubit>().addTrip(
      request,
      coverImage: _coverImageFile,
      gallery: _galleryImageFiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = [
      AppStrings.adminStepBasicInfo,
      AppStrings.adminStepPriceAndDates,
      AppStrings.adminStepMediaAndServices,
      AppStrings.adminStepItinerary,
    ];

    return BlocConsumer<AdminTripManagerCubit, AdminTripManagerStates>(
      listener: (context, state) {
        if (state is AdminTripAddSuccess) {
          final message = state.response.message.isNotEmpty
              ? state.response.message
              : 'تم إنشاء الرحلة بنجاح';
          AppSnackbar.showSuccess(context: context, message: message);
          context.pop(true);
        } else if (state is AdminTripManagerFailure) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminTripManagerLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: isLoading ? null : () => context.pop(),
            ),
            title: Text(
              AppStrings.adminAddTripTitle,
              style: AppTextStyles.titleLarge,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                AddTripStepperHeader(
                  currentStep: _currentStep,
                  stepTitles: stepTitles,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSizes.p20),
                    child: _buildStepContent(),
                  ),
                ),
                AddTripBottomActionBar(
                  currentStep: _currentStep,
                  isLoading: isLoading,
                  onPrevious: () => setState(() => _currentStep--),
                  onNext: _onNextPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return BlocConsumer<CategoriesCubit, CategoriesStates>(
          listener: (context, state) {
            if (state is CategoriesFailure) {
              AppSnackbar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            final List<CategoryModel> categories = state is CategoriesSuccess
                ? state.categories
                : const <CategoryModel>[];
            final isLoading =
                state is CategoriesLoading || state is CategoriesInitial;

            return AddTripStep1BasicInfo(
              titleController: _titleController,
              descriptionController: _descriptionController,
              categories: categories,
              isCategoriesLoading: isLoading,
              selectedCategoryId: _selectedCategoryId,
              selectedOrigin: _selectedOrigin,
              selectedDestination: _selectedDestination,
              onCategoryChanged: (value) {
                setState(() => _selectedCategoryId = value);
              },
              onOriginChanged: (value) {
                setState(() => _selectedOrigin = value);
              },
              onDestinationChanged: (value) {
                setState(() => _selectedDestination = value);
              },
            );
          },
        );
      case 1:
        return AddTripStep2PriceDates(
          priceController: _priceController,
          capacityController: _capacityController,
          startDate: _startDate,
          endDate: _endDate,
          onStartDateSelected: (date) => setState(() => _startDate = date),
          onEndDateSelected: (date) => setState(() => _endDate = date),
        );
      case 2:
        return AddTripStep3MediaServices(
          coverImageFile: _coverImageFile,
          galleryImageFiles: _galleryImageFiles,
          cancelPolicyController: _cancelPolicyController,
          presetIncludedOptions: _presetIncludedOptions,
          selectedIncluded: _selectedIncluded,
          customIncludedController: _customIncludedController,
          presetExcludedOptions: _presetExcludedOptions,
          selectedExcluded: _selectedExcluded,
          customExcludedController: _customExcludedController,
          onPickCoverImage: _pickCoverImage,
          onRemoveCoverImage: () => setState(() => _coverImageFile = null),
          onPickGalleryImages: _pickGalleryImages,
          onRemoveGalleryImage: (index) {
            setState(() => _galleryImageFiles.removeAt(index));
          },
          onToggleIncluded: (service) {
            setState(() {
              if (_selectedIncluded.contains(service)) {
                _selectedIncluded.remove(service);
              } else {
                _selectedIncluded.add(service);
              }
            });
          },
          onAddCustomIncluded: () {
            final text = _customIncludedController.text.trim();
            if (text.isNotEmpty) {
              setState(() {
                _presetIncludedOptions.add(text);
                _selectedIncluded.add(text);
                _customIncludedController.clear();
              });
            }
          },
          onToggleExcluded: (service) {
            setState(() {
              if (_selectedExcluded.contains(service)) {
                _selectedExcluded.remove(service);
              } else {
                _selectedExcluded.add(service);
              }
            });
          },
          onAddCustomExcluded: () {
            final text = _customExcludedController.text.trim();
            if (text.isNotEmpty) {
              setState(() {
                _presetExcludedOptions.add(text);
                _selectedExcluded.add(text);
                _customExcludedController.clear();
              });
            }
          },
        );
      case 3:
        return AddTripStep4Itinerary(
          days: _days,
          onAddDay: () {
            setState(() {
              _days.add({
                'dayNumber': _days.length + 1,
                'title': '',
                'activities': [
                  {
                    'title': '',
                    'description': '',
                    'time': '',
                    'location': '',
                    'imageFile': null,
                  },
                ],
              });
            });
          },
          onRemoveDay: (dayIndex) {
            setState(() => _days.removeAt(dayIndex));
          },
          onPickActivityImage: _pickActivityImage,
          onAddActivity: (dayIndex) {
            setState(() {
              (_days[dayIndex]['activities'] as List<dynamic>).add({
                'title': '',
                'description': '',
                'time': '',
                'location': '',
                'imageFile': null,
              });
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
