import 'package:hive_flutter/adapters.dart';

class HiveData {
  // basicDetail() async {
  //   // Initialize Hive (ensure you have a directory to store the data)
  //   Hive.init('path_to_hive_directory');

  //   // Open a box (you can choose a specific name for your box)
  //   var box = await Hive.openBox('userBox');

  //   // Create a map with user data
  //   Map<String, dynamic> userData = {
  //     'fullName': 'John Doe',
  //     'phoneNumber': '+1234567890',
  //     'email': 'johndoe@example.com',
  //     'dateOfBirth': '1990-01-01', // Format: YYYY-MM-DD
  //     'gender': 'Male', // Example: Male, Female, Non-binary
  //   };

  //   // Save the map to Hive
  //   await box.put('userData', userData);

  //   // Retrieve the data from Hive
  //   var retrievedData = box.get('userData');
  //   print('Retrieved User Data: $retrievedData');

  //   // Close the box when done
  //   await box.close();
  // }
}
