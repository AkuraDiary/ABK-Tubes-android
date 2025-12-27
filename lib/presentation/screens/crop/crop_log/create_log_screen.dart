import 'dart:io';

import 'package:asisten_buku_kebun/DI.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:asisten_buku_kebun/presentation/common/util/app_toast.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/app_button.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/dropdown_field.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/multiline_input_field.dart';
import 'package:asisten_buku_kebun/presentation/common/widgets/upload_box.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_colors.dart';
import 'package:asisten_buku_kebun/presentation/resources/app_constant.dart';
import 'package:asisten_buku_kebun/presentation/routing/app_routing.dart';
import 'package:asisten_buku_kebun/presenter/crop_log_presenter.dart';
import 'package:asisten_buku_kebun/presenter/crop_presenter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateLogScreen extends StatefulWidget {
  final CropPresenter cropPresenter = DI.cropPresenter;
  final CropLogPresenter cropLogPresenter = DI.cropLogPresenter;
   CreateLogScreen({super.key});

  @override
  State<CreateLogScreen> createState() => _CreateLogScreenState();
}

class _CreateLogScreenState extends State<CreateLogScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController notesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? selectedPhoto;
  String? selectedTag;

  bool isSubmitting = false;



  final List<String> logTags = [
    AppConstant.CROP_SEHAT,
    AppConstant.CROP_SAKIT,
    AppConstant.CROP_MATI,
    AppConstant.CROP_DIPANEN,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Log ${widget.cropPresenter.selectedCrop?.cropName ?? ''}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            selectedPhoto != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(selectedPhoto!.path),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : UploadBox(
                    onTap: () {
                      showImageSourceSheet(
                        context,
                        onSelected: (source) async {
                          final photo = await _picker.pickImage(source: source);
                          if (photo != null) {
                            setState(() => selectedPhoto = photo);
                          }
                        },
                      );
                    },
                  ),

            const SizedBox(height: 16),

            DropdownField<String>(
              label: "Kategori Log",
              hint: "Pilih kategori",
              value: selectedTag,
              items: logTags
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() => selectedTag = val);
              },
              validator: (val) => val == null ? 'Kategori wajib dipilih' : null,
            ),

            MultilineInputField(
              label: "Catatan",
              hint: "Tuliskan kondisi tanaman hari ini...",
              controller: notesController,
              validator: (val) => val == null || val.isEmpty
                  ? 'Catatan tidak boleh kosong'
                  : null,
            ),

            const SizedBox(height: 24),

            AppButton(
              backgroundColor: AppColors.primary900,
              textColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              buttonText: "Simpan Log",
              isLoading: isSubmitting,
              onPressed: _submitLog,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitLog() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedPhoto == null) {
      showAppToast(context, 'Foto tanaman wajib diambil', title: 'Validasi ❗');
      return;
    }

    final cropId = widget.cropPresenter.selectedCrop?.cropId;
    if (cropId == null) return;

    setState(() => isSubmitting = true);

    try {
      await widget.cropLogPresenter.addCropLog(
        cropId: cropId,
        notes: notesController.text,
        tag: selectedTag!,
        photo: selectedPhoto!,
      );
      if (!mounted) return;
      setState(() => isSubmitting = false);
      if (widget.cropLogPresenter.requestState == RequestState.success) {
        AppRouting().pop();
      } else {
        showAppToast(
          context,
          widget.cropLogPresenter.message ?? 'Gagal menyimpan log',
          title: 'Error ❌',
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      showAppToast(context, 'Gagal mengunggah foto: $e', title: 'Error ❌');
      return;
    }
  }

  void showImageSourceSheet(
    BuildContext context, {
    required Function(ImageSource source) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ImageSourceTile(
                icon: Icons.camera_alt,
                label: "Camera",
                onTap: () {
                  Navigator.pop(context);
                  onSelected(ImageSource.camera);
                },
              ),
              _ImageSourceTile(
                icon: Icons.photo_library,
                label: "Gallery",
                onTap: () {
                  Navigator.pop(context);
                  onSelected(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
  }
}
