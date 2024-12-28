class Experience {
  final String company;
  final String position;
  final String duration;
  final String description;

  Experience({
    required this.company,
    required this.position,
    required this.duration,
    required this.description,
  });
}

class Education {
  final String school;
  final String degree;
  final String duration;

  Education({
    required this.school,
    required this.degree,
    required this.duration,
  });
}

class Skill {
  final String name;
  final int level; // 1-5

  Skill({
    required this.name,
    required this.level,
  });
}

class UserProfile {
  final String name;
  final String title;
  final String avatarUrl;
  final String location;
  final String bio;
  final List<Experience> experience;
  final List<Education> education;
  final List<Skill> skills;
  final String email;
  final String phone;
  final String linkedin;

  UserProfile({
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.location,
    required this.bio,
    required this.experience,
    required this.education,
    required this.skills,
    required this.email,
    required this.phone,
    required this.linkedin,
  });
}