import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_state.dart';
import 'package:shopping_app/features/address/presentation/pages/add_edit_address.screen.dart';
import 'package:shopping_app/features/address/presentation/widgets/address_tile.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    return AppScaffold(
      appBar: GeneralAppBar(title: 'Addresses'),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AddressError) {
            return Center(child: Text(state.message));
          }

          if (state is AddressLoaded) {
            return Column(
              children: [
                Expanded(
                  child: state.addresses.isEmpty
                      ? Center(
                          child: Text(
                            'No saved addresses yet',
                            style: appTypography.bodyLarge.copyWith(
                              color: appColors.gray4,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(Dimens.largePadding),
                          itemCount: state.addresses.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: Dimens.padding),
                          itemBuilder: (context, index) {
                            return AddressTile(address: state.addresses[index]);
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(Dimens.largePadding),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: AppButton(
                      title: 'Add New Address',
                      onPressed: () {
                        appPush(context, const AddEditAddressScreen());
                      },
                      margin: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
