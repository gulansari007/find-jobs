import 'package:findjobs/controllers/locationController.dart';
import 'package:findjobs/screens/education_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: Column(
        children: [
          // Current Location Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => locationController.isLoadingLocation.value
                ? const CircularProgressIndicator(color: Colors.deepPurple)
                : SizedBox(
                    width: Get.width * .59,
                    child: ElevatedButton(
                      onPressed: () {
                        locationController.getCurrentLocation();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Use current location'),
                        ],
                      ),
                    ),
                  )),
          ),

          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: locationController.locationController,
              decoration: _inputDecoration('Search City'),
              onChanged: (value) {
                locationController.searchQuery.value = value;
              },
            ),
          ),

          // Cities List
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: locationController.filteredCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(locationController.filteredCities[index]),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => locationController
                          .selectCity(locationController.filteredCities[index]),
                    );
                  },
                )),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: locationController.isNextButtonEnabled.value
                      ? () => Get.to(const EducationScreen())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        locationController.isNextButtonEnabled.value
                            ? Get.theme.primaryColor
                            : Colors.grey, // Disabled color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
