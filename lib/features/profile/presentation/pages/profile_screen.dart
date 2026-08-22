import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:shopping_app/features/auth/presentation/bloc/cubits/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;
    return AppScaffold(
      appBar: GeneralAppBar(title: 'Profile', showBackIcon: false),
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.largePadding,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BorderedContainer(
              child: ListTile(
                leading: UserProfileImageWidget(width: 56, height: 56),
                title: Text('Vanessa Lennox', style: appTypography.bodyLarge),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: Dimens.padding),
                  child: Text(
                    'VanessaLennox@gmail.com',
                    style: appTypography.bodySmall.copyWith(
                      color: checkDarkMode(context)
                          ? appColors.white
                          : appColors.gray4,
                    ),
                  ),
                ),
                trailing: AppSvgViewer(
                  Assets.icons.edit,
                  width: 19,
                  color: checkDarkMode(context)
                      ? appColors.white
                      : appColors.gray4,
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
        ),
      ),
    );
  }
}
