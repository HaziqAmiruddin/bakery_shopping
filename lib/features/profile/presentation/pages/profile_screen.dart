import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/check_theme_status.dart';
import 'package:shopping_app/core/widgets/app_list_tile.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/bordered_container.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/core/widgets/user_profile_image_widget.dart';
import 'package:shopping_app/features/auth/domain/entities/app_user.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_state.dart';
import 'package:shopping_app/features/profile/utils/cloudinary_uploader.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _showEditOptions(
    BuildContext context,
    AuthCubit authCubit,
    AppUser user,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Change photo'),
              onTap: () => Navigator.pop(context, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit name'),
              onTap: () => Navigator.pop(context, 'name'),
            ),
          ],
        ),
      ),
    );

    if (action == 'photo') {
      await _showPhotoSourcePicker(context, authCubit, user.uid);
    } else if (action == 'name') {
      await _showEditNameDialog(context, authCubit, user);
    }
  }

  Future<void> _showPhotoSourcePicker(
    BuildContext context,
    AuthCubit authCubit,
    String uid,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final uploader = CloudinaryUploader();

    try {
      final url = await uploader.pickAndUpload(uid: uid, source: source);
      if (url != null) {
        await authCubit.updateProfilePhoto(url);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update photo: $e')));
      }
    }
  }

  Future<void> _showEditNameDialog(
    BuildContext context,
    AuthCubit authCubit,
    AppUser user,
  ) async {
    final controller = TextEditingController(text: user.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final trimmed = controller.text.trim();
              if (trimmed.isNotEmpty) {
                Navigator.pop(context, trimmed);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName != user.name) {
      await authCubit.updateProfileName(newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Profile', showBackIcon: false),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! Authenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.user;

          return Column(
            spacing: Dimens.largePadding,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BorderedContainer(
                child: ListTile(
                  leading: UserProfileImageWidget(
                    width: 56,
                    height: 56,
                    photoUrl: user.photoUrl,
                    name: user.name,
                  ),
                  title: Text(
                    user.name.isNotEmpty ? user.name : 'No Name Set',
                    style: appTypography.bodyLarge,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: Dimens.padding),
                    child: Text(
                      user.email,
                      style: appTypography.bodySmall.copyWith(
                        color: checkDarkMode(context)
                            ? appColors.white
                            : appColors.gray4,
                      ),
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _showEditOptions(context, authCubit, user),
                    child: AppSvgViewer(
                      Assets.icons.edit,
                      width: 19,
                      color: checkDarkMode(context)
                          ? appColors.white
                          : appColors.gray4,
                    ),
                  ),
                ),
              ),
              Text(
                'General',
                style: appTypography.bodyLarge.copyWith(fontSize: 20),
              ),
              BorderedContainer(
                child: Column(
                  spacing: Dimens.largePadding,
                  children: [
                    AppListTile(
                      onTap: () {},
                      title: 'Payment method',
                      leadingIconPath: Assets.icons.cardPos,
                      padding: EdgeInsets.zero,
                    ),
                    AppListTile(
                      onTap: () {},
                      title: 'Addresses',
                      leadingIconPath: Assets.icons.location,
                      padding: EdgeInsets.zero,
                    ),
                    AppListTile(
                      onTap: () {},
                      title: 'Dark theme',
                      leadingIconPath: Assets.icons.moon,
                      trailing: Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: checkDarkMode(context),
                          onChanged: (final value) {},
                          activeTrackColor: appColors.primary,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox.shrink(),
                  ],
                ),
              ),
              Text(
                'Support',
                style: appTypography.bodyLarge.copyWith(fontSize: 20),
              ),
              BorderedContainer(
                child: Column(
                  spacing: Dimens.largePadding,
                  children: [
                    AppListTile(
                      onTap: () {},
                      title: 'Feedback',
                      leadingIconPath: Assets.icons.noteText,
                      padding: EdgeInsets.zero,
                    ),
                    AppListTile(
                      onTap: () {},
                      title: 'Help and Support',
                      leadingIconPath: Assets.icons.infoCircle,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox.shrink(),
                  ],
                ),
              ),
              BorderedContainer(
                child: AppListTile(
                  onTap: () {
                    authCubit.logout();
                  },
                  title: 'Log out',
                  leadingIconPath: Assets.icons.logout,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
