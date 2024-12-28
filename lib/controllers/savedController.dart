import 'package:get/get.dart';

class SavedJobsController extends GetxController {
  var savedJobs = <Job>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedJobs();
  }

  void fetchSavedJobs() {
    isLoading.value = true;
    // Simulate API call
    savedJobs.value = [
      Job(
        id: '1',
        title: 'Senior Flutter ',
        company: 'TechCorp',
        location: 'New York, NY',
        salary: '\$120k - \$150k',
        isSaved: true,
        postedDate: '2d ago',
      ),
      Job(
        id: '2',
        title: 'Mobile Developer',
        company: 'StartupCo',
        location: 'Remote',
        salary: '\$90k - \$120k',
        isSaved: true,
        postedDate: '3d ago',
      ),
    ];
    isLoading.value = false;
  }

  void toggleSaved(String jobId) {
    final index = savedJobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      savedJobs[index].isSaved = !savedJobs[index].isSaved;
      savedJobs.refresh();
    }
  }
}

// job_model.dart
class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  bool isSaved;
  final String postedDate;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.isSaved,
    required this.postedDate,
  });
}
