class BusinessUnit {
  final String id;
  final String name;
  final String description;

  const BusinessUnit({
    required this.id,
    required this.name,
    required this.description,
  });
}

class Organization {
  final String id;
  final String name;
  final String code;
  final String logoUrl;
  final bool hasMultipleBusinessUnits;
  final List<BusinessUnit> businessUnits;

  const Organization({
    required this.id,
    required this.name,
    required this.code,
    required this.logoUrl,
    required this.hasMultipleBusinessUnits,
    required this.businessUnits,
  });

  // Mock data for demonstration
  static Organization yopmail() {
    return const Organization(
      id: 'org_1',
      name: "Yashang's Company",
      code: 'yopmail',
      logoUrl: 'assets/logo.svg',
      hasMultipleBusinessUnits: true,
      businessUnits: [
        BusinessUnit(
          id: 'bu_1',
          name: 'Yopmails',
          description: 'Primary Business Unit',
        ),
        BusinessUnit(
          id: 'bu_2',
          name: 'Star',
          description: 'Secondary Business Unit',
        ),
      ],
    );
  }

  static Organization bluewhale() {
    return const Organization(
      id: 'org_2',
      name: 'Bluewhale Techno Soft',
      code: 'bluewhale',
      logoUrl: 'assets/logo.svg', // Assuming same logo or dynamic
      hasMultipleBusinessUnits: false,
      businessUnits: [
        BusinessUnit(
          id: 'bu_3',
          name: 'Bluewhale Techno Soft',
          description: 'Main Office',
        ),
      ],
    );
  }

  static Organization? fromCode(String code) {
    if (code.toLowerCase() == 'yopmail' || code.toLowerCase() == 'yashang') {
      return yopmail();
    } else if (code.toLowerCase() == 'bluewhale' ||
        code.toLowerCase() == 'kamlesh') {
      return bluewhale();
    }
    return null;
  }
}
