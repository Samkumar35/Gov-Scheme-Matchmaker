class Scheme {
  final String schemeName;
  final String benefit;
  final String reason;
  final String officialWebsite; // Added this
  final String applySteps;      // Added this

  Scheme({
    required this.schemeName,
    required this.benefit,
    required this.reason,
    required this.officialWebsite,
    required this.applySteps,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      schemeName: json['name'] ?? 'Unknown Scheme',
      benefit: json['benefit'] ?? 'No benefit description available',
      reason: json['reason'] ?? 'Criteria met',
      // Map these to the names coming from your Spring Boot JSON
      officialWebsite: json['officialWebsite'] ?? 'https://www.india.gov.in/',
      applySteps: json['applySteps'] ?? 'Check official portal for steps.',
    );
  }
}