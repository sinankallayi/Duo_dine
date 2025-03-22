import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/functions/restaurant.dart';
import 'package:get/get.dart';

import '../../../functions/location.dart';

class RestRegisterScreen extends GetView<RestRegisterController> {
  RestRegisterScreen({super.key});

  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(RestRegisterController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Registration'),
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: ListView(
            children: <Widget>[
              _buildTextFormField(
                label: 'Name *',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the restaurant name'
                    : null,
                onSaved: (value) => controller.name.value = value!,
              ),
              _buildTextFormField(
                label: 'Address *',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the address'
                    : null,
                onSaved: (value) => controller.address.value = value!,
              ),
              _buildTextFormField(
                label: 'Phone *',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the phone number'
                    : null,
                onSaved: (value) => controller.phone.value = value!,
              ),
              _buildLocationField(),
              _buildTextFormField(
                label: 'Tags',
                validator: (value) => null,
                onChanged: (value) {
                  controller.tags.value = value.replaceAll(',', ' ');
                },
                onSaved: (value) => controller.tags.value = value!,
              ),
              Obx(() => _buildTagsChips()),
              _buildTextFormField(
                label: 'Description',
                maxLines: 5,
                validator: (value) => null,
                onSaved: (value) => controller.description.value = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
    ValueChanged<String>? onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixText: label == 'Phone *' ? '+91 ' : null,
        labelStyle: TextStyle(
          color: label.endsWith('*') ? Colors.red : null,
        ),
      ),
      keyboardType: label == 'Phone *'
          ? TextInputType.phone
          : (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
      maxLength: label == 'Phone *' ? 10 : null,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      maxLines: maxLines,
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Location *',
        suffixIcon: IconButton(
          onPressed: () async {
            _locationController.text = await getLocation();
          },
          icon: const Icon(Icons.location_on),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter the location' : null,
      onSaved: (value) => controller.location.value = value!,
    );
  }

  Widget _buildTagsChips() {
    return Wrap(
      spacing: 8.0,
      children: controller.tags.value
          .split(' ')
          .where((tag) => tag.isNotEmpty)
          .map((tag) {
        return Chip(
          label: Text(tag),
          onDeleted: () {
            controller.tags.value = controller.tags.value
                .split(' ')
                .where((t) => t != tag)
                .join(' ');
          },
        );
      }).toList(),
    );
  }
}

class RestRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var name = ''.obs;
  var address = ''.obs;
  var phone = ''.obs;
  var location = ''.obs;
  RxString tags = ''.obs;
  var description = ''.obs;

  void register() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Process the registration data
      registerRestaurant(
        name: name.value,
        address: address.value,
        phone: phone.value,
        location: location.value,
        tags: tags.value,
        description: description.value,
      );
    }
  }
}
