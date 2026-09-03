import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/profile/domain/address_entities.dart';
import 'package:shopping_app/features/profile/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/profile/presentation/bloc/address_event.dart';
import 'package:shopping_app/features/profile/presentation/bloc/address_state.dart';
import 'package:shopping_app/features/profile/presentation/pages/add_edit_address.screen.dart';

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
                            return _AddressTile(
                              address: state.addresses[index],
                            );
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

class _AddressTile extends StatelessWidget {
  const _AddressTile({required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    return Dismissible(
      key: ValueKey(address.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete address?'),
                content: Text('Remove "${address.label}" address?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        context.read<AddressBloc>().add(AddressDeleted(address.id));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.largePadding),
        margin: EdgeInsets.only(bottom: Dimens.padding),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(Dimens.corners),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.corners),
        onTap: () {
          appPush(context, AddEditAddressScreen(address: address));
        },
        child: Container(
          margin: EdgeInsets.only(bottom: Dimens.padding),
          padding: EdgeInsets.all(Dimens.largePadding),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(Dimens.corners),
            border: Border.all(
              color: address.isDefault
                  ? appColors.primary
                  : appColors.gray4.withValues(alpha: 0.3),
              width: address.isDefault ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.smallPadding,
            children: [
              Row(
                children: [
                  Text(
                    address.label,
                    style: appTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (address.isDefault) ...[
                    SizedBox(width: Dimens.smallPadding),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: appColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Default',
                        style: TextStyle(
                          fontSize: 11,
                          color: appColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '${address.recipientName} • ${address.phone}',
                style: appTypography.bodySmall,
              ),
              Text(
                [
                  address.addressLine1,
                  address.addressLine2,
                  address.city,
                  address.state,
                  address.postcode,
                ].where((s) => s.isNotEmpty).join(', '),
                style: appTypography.bodySmall.copyWith(color: appColors.gray4),
              ),
              if (!address.isDefault)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<AddressBloc>().add(
                        AddressSetDefault(address.id),
                      );
                    },
                    child: const Text('Set as default'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
