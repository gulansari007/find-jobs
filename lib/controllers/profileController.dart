import 'package:findjobs/modals/profile_modal.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileController extends GetxController {
  final profile = Rx<UserProfile?>(null);
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      profile.value = UserProfile(
        name: "Gul Ansarii",
        title: "Senior Software Engineer",
        avatarUrl: "https://placeholder.com/150",
        location: "Okhla,Delhi",
        bio:
            "Passionate software engineer with 5+ years of experience in mobile development. Specialized in Flutter and native Android development.",
        experience: [
          Experience(
            company: "Tech Solutions Inc.",
            position: "Senior Software Engineer",
            duration: "2020 - Present",
            description:
                "Leading mobile development team, implementing new features and architectures.",
          ),
          Experience(
            company: "Mobile Apps Co",
            position: "Software Engineer",
            duration: "2018 - 2020",
            description:
                "Developed and maintained multiple mobile applications.",
          ),
        ],
        education: [
          Education(
            school: "Stanford University",
            degree: "M.S. Computer Science",
            duration: "2016 - 2018",
          ),
          Education(
            school: "UC Berkeley",
            degree: "B.S.c Computer Science",
            duration: "2020 - 2023",
          ),
        ],
        skills: [
          Skill(name: "Flutter", level: 5),
          Skill(name: "Dart", level: 5),
          Skill(name: "Android", level: 4),
          Skill(name: "iOS", level: 3),
          Skill(name: "React Native", level: 4),
          Skill(name: "Python", level: 4),
        ],
        email: "ansarii.gul@email.com",
        phone: "+91 656087654",
        linkedin: "linkedin.com/in/gulansarii",
      );
      isLoading.value = false;
    });
  }
}



//  RxString email = ''.obs;
//   RxString username = ''.obs;
//   RxString profileImageUrl = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       email.value = user.email ?? 'No Email Found';
//       username.value = user.displayName ?? 'No Username Found';
//       profileImageUrl.value = user.photoURL ??
//           'https://via.placeholder.com/150'; // Default if no profile image
//     }
//     isLoading.value = false;
//   }