import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<String> bookmarkedJobs = <String>[].obs;
  RxString selectedCategory = 'All Jobs'.obs;

  void toggleBookmark(String jobTitle) {
    if (bookmarkedJobs.contains(jobTitle)) {
      bookmarkedJobs.remove(jobTitle);
    } else {
      bookmarkedJobs.add(jobTitle);
    }
  }

  bool isBookmarked(String jobTitle) => bookmarkedJobs.contains(jobTitle);

  // void selectCategory(String category) {
  //   selectedCategory.value = category;
  //   // Add logic to fetch or filter jobs based on the selected category.
  // }

  var allJobs = <Job>[].obs;
  var filteredJobs = <Job>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Mock job data
    allJobs.addAll([
      Job(
          companyName: 'Google',
          jobTitle: 'Flutter Developer',
          category: 'Remote'),
      Job(
          companyName: 'Amazon',
          jobTitle: 'Full Stack Developer',
          category: 'Full Time'),
      Job(
          companyName: 'Microsoft',
          jobTitle: 'Part-Time Engineer',
          category: 'Part Time'),
      // Add more mock data
    ]);
    filterJobs(); // Initial load
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    filterJobs();
  }

  void filterJobs() {
    if (selectedCategory.value == 'All Jobs') {
      filteredJobs.assignAll(allJobs);
    } else {
      filteredJobs.assignAll(allJobs
          .where((job) => job.category == selectedCategory.value)
          .toList());
    }
  }
}

class Job {
  final String companyName;
  final String jobTitle;
  final String category;

  Job(
      {required this.companyName,
      required this.jobTitle,
      required this.category});

  // // Observables for selected category and bookmarked jobs
  // var selectedCategory = 'All Jobs'.obs;
  // var bookmarkedJobs = <String>[].obs;

  // // Method to change the selected category
  // void changeCategory(String category) {
  //   selectedCategory.value = category;
  // }

  // // Method to toggle bookmark for a job
  // void toggleBookmark(String jobTitle) {
  //   if (bookmarkedJobs.contains(jobTitle)) {
  //     bookmarkedJobs.remove(jobTitle);
  //   } else {
  //     bookmarkedJobs.add(jobTitle);
  //   }
  // }

  // // Check if a job is bookmarked
  // bool isBookmarked(String jobTitle) {
  //   return bookmarkedJobs.contains(jobTitle);
  // }
}
