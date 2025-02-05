import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quittr/core/injection_container.dart';
import 'package:quittr/core/services/image_picker_service.dart';
import '../bloc/profile_bloc.dart';

Future<void> showProfilePhotoPicker(BuildContext context) async {
  final ImagePickerService picker = sl<ImagePickerService>();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext dialogContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(dialogContext);
                final imagePath = await picker.pickImage(ImageSource.camera);
                if (context.mounted && imagePath != null) {
                  context
                      .read<ProfileBloc>()
                      .add(UpdateProfilePhotoEvent(imagePath));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(dialogContext);
                final imagePath = await picker.pickImage(ImageSource.gallery);
                if (context.mounted && imagePath != null) {
                  context
                      .read<ProfileBloc>()
                      .add(UpdateProfilePhotoEvent(imagePath));
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
