import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/model/crop_model.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/dropdown_field.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/input_field.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presentation/resources/text_styles_resources.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/util/app_toast.dart' show showAppToast;

class AddEditCropScreen extends StatefulWidget {
  CropPresenter cropPresenter = DI.cropPresenter;

  AddEditCropScreen({super.key});

  @override
  State<AddEditCropScreen> createState() => _AddEditCropScreenState();
}

class _AddEditCropScreenState extends State<AddEditCropScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  // String selectedCropType = '';
  // String selectedCropStatus = '';

  final List<String> cropTypes = [
    'Sayur',
    'Buah',
    'Rempah',
    'Pohon',
    "Bunga",
    "Tanaman Hias",
    'Lainnya',
  ];

  final List<String> cropStatuses = [
    AppConstant.CROP_SEHAT,
    AppConstant.CROP_SAKIT,
    AppConstant.CROP_DIPANEN,
    AppConstant.CROP_MATI,
  ];

  @override
  void initState() {
    super.initState();
    isEdit = widget.cropPresenter.selectedCrop != null;
    if (isEdit) {
      var crop = widget.cropPresenter.selectedCrop!;
      cropNameController.text = crop.cropName ?? '';
      latController.text = crop.locationLat?.toString() ?? '';
      lonController.text = crop.locationLon?.toString() ?? '';
      typeController.text = crop.type ?? '';
      statusController.text = crop.cropStatus?.toLowerCase() ?? '';
    }
  }

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? 'Edit Data ${widget.cropPresenter.selectedCrop?.cropName}'
              : 'Tambah Data Tanaman',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _CropInfoSection(
              cropNameController: cropNameController,
              cropTypes: cropTypes,
              cropStatuses: cropStatuses,
              cropTypeController: typeController,
              cropStatusController: statusController,
            ),
            const SizedBox(height: 24),
            _CropLocationSection(
              latController: latController,
              lonController: lonController,
            ),
            const SizedBox(height: 32),
            _ActionSection(
              onSave: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (isEdit) {
                    CropModel editedCrop = widget.cropPresenter.selectedCrop!;
                    editedCrop.cropName = cropNameController.text;
                    editedCrop.type = typeController.text;
                    editedCrop.cropStatus = statusController.text;
                    editedCrop.locationLat = double.tryParse(
                      latController.text,
                    );
                    editedCrop.locationLon = double.tryParse(
                      lonController.text,
                    );

                    _editCrop(editedCrop);
                  } else {
                    CropModel newCrop = CropModel(
                      cropName: cropNameController.text,
                      type: typeController.text,
                      cropStatus: statusController.text,
                      locationLat: double.tryParse(latController.text),
                      locationLon: double.tryParse(lonController.text),
                    );

                    _addCrop(newCrop);
                  }
                }
              },
              onCancel: () {
                widget.cropPresenter.selectedCrop = null;
                AppRouting().pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editCrop(CropModel editedCrop) async {
    try {
      await widget.cropPresenter.editCrop(editedCrop);
      if (!mounted) return;
      if (widget.cropPresenter.requestState == RequestState.success) {
        // Successfully fetched crop logs, you can update the UI accordingly
        showAppToast(
          context,
          'Tanaman Berhasil Diedit',
          title: 'Berhasil',
          isError: false,
        );
      }
    } catch (e) {
      showAppToast(
        context,
        'Terjadi kesalahan: $e. Silakan coba lagi',
        title: 'Error Tidak Terduga 😢',
      );
    }
  }

  Future<void> _addCrop(CropModel newCrop) async {
    try {
      await widget.cropPresenter.addCrop(
        newCrop,
        DI.authPresenter.loggedInUser?.id ?? "",
      );
      if (!mounted) return;
      if (widget.cropPresenter.requestState == RequestState.success) {
        // Successfully fetched crop logs, you can update the UI accordingly
        showAppToast(
          context,
          'Tanaman Berhasil Ditambahkan',
          title: 'Berhasil',
          isError: false,
        );
        // setState(() {
        //
        // });
      } else {
        showAppToast(
          context,
          'Terjadi Kesalahan : ${widget.cropPresenter.message}',
          title: 'Gagal ❌',
        );
      }
    } catch (e) {
      showAppToast(
        context,
        'Terjadi kesalahan: $e. Silakan coba lagi',
        title: 'Error Tidak Terduga 😢',
      );
    }
  }
}

class _CropInfoSection extends StatelessWidget {
  final TextEditingController cropNameController;
  final TextEditingController cropStatusController;
  final TextEditingController cropTypeController;
  final List<String> cropTypes;
  final List<String> cropStatuses;


  _CropInfoSection({
    required this.cropNameController,
    required this.cropStatusController,
    required this.cropTypeController,
    required this.cropTypes,
    required this.cropStatuses,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Informasi Tanaman", style: semibold14),
        const SizedBox(height: 12),

        InputField(
          label: "Nama Tanaman",
          hint: "Contoh: Cabai Rawit Rooftop",
          controller: cropNameController,
          validator: (value) =>
              value == null || value.isEmpty ? 'Nama wajib diisi' : null,
        ),

        DropdownField<String>(
          label: "Jenis Tanaman",
          hint: "Pilih jenis tanaman",
          value: cropTypeController.text == '' ? null : cropTypeController.text,
          items: cropTypes
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            cropTypeController.text = val ?? "";
          },
        ),

        DropdownField<String>(
          label: "Status Tanaman",
          hint: "Pilih status",
          value: cropStatusController.text == '' ? null : cropStatusController.text,
          items: cropStatuses
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            cropStatusController.text = val ?? '';
          },
        ),
      ],
    );
  }
}

class _CropLocationSection extends StatefulWidget {
  final TextEditingController latController;
  final TextEditingController lonController;

  _CropLocationSection({
    required this.latController,
    required this.lonController,
  });

  @override
  State<_CropLocationSection> createState() => _CropLocationSectionState();
}

class _CropLocationSectionState extends State<_CropLocationSection> {
  bool isLoading = false;

  Future<void> _getLocation() async {
    setState(() {
      isLoading = true;
    });
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      return;
    }
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      isLoading = false;
      double lat = position.latitude;
      double long = position.longitude;
      // LatLng location = LatLng(lat, long);
      widget.latController.text = lat.toString();
      widget.lonController.text = long.toString();
      // _currentPosition = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Lokasi Tanaman", style: semibold14),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      label: "Latitude",
                      hint: "",
                      controller: widget.latController,
                      isDisabled: true,
                      isGrayed: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      label: "Longitude",
                      hint: "",
                      controller: widget.lonController,
                      isDisabled: true,
                      isGrayed: true,
                    ),
                  ),
                ],
              ),

              AppButton(
                buttonText: "Pilih Lokasi Saat Ini",
                buttonType: AppButtonType.outlined,
                outlineColor: AppColors.primary900,
                padding: const EdgeInsets.symmetric(vertical: 16),
                onPressed: () {
                  _getLocation();
                },
              ),
            ],
          );
  }
}

class _ActionSection extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _ActionSection({required this.onSave, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          buttonText: "Simpan",
          onPressed: onSave,
          outlineColor: AppColors.primary900,
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primary900,
        ),
        const SizedBox(height: 12),
        AppButton(
          buttonText: "Batal",
          padding: const EdgeInsets.symmetric(vertical: 16),
          buttonType: AppButtonType.outlined,
          outlineColor: AppColors.primary900,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
