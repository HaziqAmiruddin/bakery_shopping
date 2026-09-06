import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/bordered_container.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_state.dart';
import 'package:shopping_app/features/address/presentation/pages/add_edit_address.screen.dart';
import 'package:shopping_app/features/address/presentation/pages/address_list_screenn.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;

    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is! AddressLoaded || state.addresses.isEmpty) {
          return BorderedContainer(
            child: ListTile(
              leading: const Icon(Icons.location_off_outlined),
              title: const Text('No address saved'),
              trailing: TextButton(
                onPressed: () => appPush(context, const AddEditAddressScreen()),
                child: const Text('Add'),
              ),
            ),
          );
        }

        final defaultAddress = state.addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => state.addresses.first,
        );

        return BorderedContainer(
          child: ListTile(
            leading: Icon(Icons.location_on_outlined, color: appColors.primary),
            title: Text(
              defaultAddress.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${defaultAddress.recipientName}\n'
              '${defaultAddress.addressLine1}, ${defaultAddress.city}, ${defaultAddress.postcode}',
            ),
            isThreeLine: true,
            trailing: TextButton(
              onPressed: () => appPush(context, const AddressListScreen()),
              child: const Text('Change'),
            ),
          ),
        );
      },
    );
  }
}
