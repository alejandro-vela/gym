class OnboardingStrings {
  const OnboardingStrings({
    required this.skip,
    required this.next,
    required this.start,
    required this.slide1Title,
    required this.slide1Body,
    required this.slide2Title,
    required this.slide2Body,
    required this.slide3Title,
    required this.slide3Body,
    required this.slide4Title,
    required this.slide4Body,
  });

  factory OnboardingStrings.fromJson(Map<String, dynamic> j) =>
      OnboardingStrings(
        skip: j['skip'] as String,
        next: j['next'] as String,
        start: j['start'] as String,
        slide1Title: j['slide1_title'] as String,
        slide1Body: j['slide1_body'] as String,
        slide2Title: j['slide2_title'] as String,
        slide2Body: j['slide2_body'] as String,
        slide3Title: j['slide3_title'] as String,
        slide3Body: j['slide3_body'] as String,
        slide4Title: j['slide4_title'] as String,
        slide4Body: j['slide4_body'] as String,
      );

  final String skip;
  final String next;
  final String start;
  final String slide1Title;
  final String slide1Body;
  final String slide2Title;
  final String slide2Body;
  final String slide3Title;
  final String slide3Body;
  final String slide4Title;
  final String slide4Body;
}
