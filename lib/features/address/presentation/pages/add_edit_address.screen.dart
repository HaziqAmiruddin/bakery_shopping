import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/app_navigator.dart';
import 'package:shopping_app/core/widgets/app_button.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/address/domain/address_entities.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_bloc.dart';
import 'package:shopping_app/features/address/presentation/bloc/address_event.dart';
import 'package:shopping_app/features/address/presentation/widgets/field.dart';

class AddEditAddressScreen extends StatefulWidget {
  const AddEditAddressScreen({super.key, this.address});

  final Address? address;

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _labelController = TextEditingController(
    text: widget.address?.label ?? '',
  );
  late final _nameController = TextEditingController(
    text: widget.address?.recipientName ?? '',
  );
  late final _phoneController = TextEditingController(
    text: widget.address?.phone ?? '',
  );
  late final _line1Controller = TextEditingController(
    text: widget.address?.addressLine1 ?? '',
  );
  late final _line2Controller = TextEditingController(
    text: widget.address?.addressLine2 ?? '',
  );
  late final _cityController = TextEditingController(
    text: widget.address?.city ?? '',
  );
  late final _stateController = TextEditingController(
    text: widget.address?.state ?? '',
  );
  late final _postcodeController = TextEditingController(
    text: widget.address?.postcode ?? '',
  );
  late bool _isDefault = widget.address?.isDefault ?? false;

  bool get _isEditing => widget.address != null;

  @override
  void dispose() {
    _labelController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final address = Address(
      id: widget.address?.id ?? '',
      label: _labelController.text.trim(),
      recipientName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine1: _line1Controller.text.trim(),
      addressLine2: _line2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postcode: _postcodeController.text.trim(),
      isDefault: _isDefault,
    );

    if (_isEditing) {
      context.read<AddressBloc>().add(AddressUpdated(address));
    } else {
      context.read<AddressBloc>().add(AddressAdded(address));
    }

    appPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: GeneralAppBar(title: _isEditing ? 'Edit Address' : 'Add Address'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimens.largePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.largePadding,
            children: [
              field(_labelController, 'Label (e.g. Home, Work)'),
              field(_nameController, 'Recipient name'),
              field(
                _phoneController,
                'Phone number',
                keyboardType: TextInputType.phone,
              ),
              field(_line1Controller, 'Address line 1'),
              field(
                _line2Controller,
                'Address line 2 (optional)',
                required: false,
              ),
              field(_cityController, 'City'),
              field(_stateController, 'State'),
              field(
                _postcodeController,
                'Postcode',
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (value) =>
                        setState(() => _isDefault = value ?? false),
                  ),
                  const Text('Set as default address'),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: AppButton(
                  title: _isEditing ? 'Save Changes' : 'Add Address',
                  onPressed: _save,
                  margin: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
