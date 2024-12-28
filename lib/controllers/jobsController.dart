import 'package:findjobs/modals/jobs_modal.dart';
import 'package:get/get.dart';

class JobController extends GetxController {
  // Observable lists and variables
  final RxList<Job> _jobListings = <Job>[
    Job(
      id: 1,
      title: 'Software Engineer',
      company: 'TechCorp Inc.',
      location: 'Noida, sector 2',
      type: 'Full-time',
      salary: '\$120,000 - \$150,000',
      logoPath: 'assets/tech_logo.png',
    ),
    Job(
      id: 2,
      title: 'Product Manager',
      company: 'Innovative Solutions',
      location: 'Delhi',
      type: 'Remote',
      salary: '\$110,000 - \$140,000',
      logoPath: 'assets/innovative_logo.png',
    ),
    Job(
      id: 3,
      title: 'UX Designer',
      company: 'Creative Design Studio',
      location: 'Okhla, Delhi',
      type: 'Contract',
      salary: '\$90,000 - \$120,000',
      logoPath: 'assets/design_logo.png',
    ),
  ].obs;

  final RxString _searchTerm = ''.obs;
  final Rx<String?> _selectedLocation = Rx<String?>(null);
  final Rx<String?> _selectedJobType = Rx<String?>(null);

  // Getters
  List<Job> get jobListings => _jobListings;
  String get searchTerm => _searchTerm.value;
  String? get selectedLocation => _selectedLocation.value;
  String? get selectedJobType => _selectedJobType.value;

  // Filtering method
  List<Job> get filteredJobs {
    return _jobListings.where((job) {
      final searchLower = _searchTerm.value.toLowerCase();
      final matchesSearch = job.title.toLowerCase().contains(searchLower) ||
          job.company.toLowerCase().contains(searchLower);

      final matchesLocation = _selectedLocation.value == null ||
          job.location
              .toLowerCase()
              .contains(_selectedLocation.value!.toLowerCase());

      final matchesJobType = _selectedJobType.value == null ||
          job.type.toLowerCase() == _selectedJobType.value!.toLowerCase();

      return matchesSearch && matchesLocation && matchesJobType;
    }).toList();
  }

  // Methods to update state
  void updateSearchTerm(String value) {
    _searchTerm.value = value;
  }

  void updateLocation(String? location) {
    _selectedLocation.value = location;
  }

  void updateJobType(String? jobType) {
    _selectedJobType.value = jobType;
  }

  void applyToJob(Job job) {
    // Implement job application logic
    Get.snackbar(
      'Application Submitted',
      'You applied to ${job.title} at ${job.company}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
