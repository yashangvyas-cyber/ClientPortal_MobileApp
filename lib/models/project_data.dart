class TopUpRecord {
  final String comment;
  final String topUpHours;
  final String addedOn;

  TopUpRecord({
    required this.comment,
    required this.topUpHours,
    required this.addedOn,
  });
}

class TimesheetLog {
  final String date;
  final String description;
  final String hours;

  TimesheetLog({
    required this.date,
    required this.description,
    required this.hours,
  });
}

class DedicatedResource {
  final String name;
  final String dateFrom;
  final String dateTo;
  final String totalWorkingDays;
  final String expiresIn;
  final String hiredFor;
  final bool isCurrent;

  DedicatedResource({
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.totalWorkingDays,
    required this.expiresIn,
    required this.hiredFor,
    this.isCurrent = true,
  });
}

class Milestone {
  final String name;
  final String status;

  Milestone({
    required this.name,
    required this.status,
  });
}

class ChangeRequest {
  final String comment;
  final String addedOn;
  final String freeOfCost;

  ChangeRequest({
    required this.comment,
    required this.addedOn,
    required this.freeOfCost,
  });
}

class ProjectData {
  final String id;
  final String projectName;
  final String projectType;
  final String status;
  final String projectManagers;
  final String associatedDeal;
  final String dealOwnerName;
  final String dealOwnerEmail;
  final String addedOn;

  // Hourly Specific
  final int? initiallyBoughtHours;
  final int? topUpHours;
  final int? totalHours;
  final String? totalBilledHours;
  final String? balanceHours;
  final List<TopUpRecord>? topUpRecords;
  final List<TimesheetLog>? timesheetLogs;

  // Hirebase Specific
  final List<String>? requiredSkills;
  final String? startDate;
  final String? endDate;
  final String? signOffDate;
  final String? supportStartDate;
  final String? supportEndDate;
  final String? supportPeriod;
  final List<DedicatedResource>? dedicatedResources;

  // Fixed Cost Specific
  final List<Milestone>? milestones;
  final List<ChangeRequest>? changeRequests;

  ProjectData({
    required this.id,
    required this.projectName,
    required this.projectType,
    required this.status,
    required this.projectManagers,
    required this.associatedDeal,
    required this.dealOwnerName,
    required this.dealOwnerEmail,
    required this.addedOn,
    this.initiallyBoughtHours,
    this.topUpHours,
    this.totalHours,
    this.totalBilledHours,
    this.balanceHours,
    this.topUpRecords,
    this.timesheetLogs,
    this.requiredSkills,
    this.startDate,
    this.endDate,
    this.signOffDate,
    this.supportStartDate,
    this.supportEndDate,
    this.supportPeriod,
    this.dedicatedResources,
    this.milestones,
    this.changeRequests,
  });
}

// Mock Data representing the screenshot
final List<ProjectData> mockProjects = [
  ProjectData(
    // HOURLY PROJECT
    id: '1',
    projectName: 'IT Support & Development – Apex Consulting Group',
    projectType: 'Hourly Projects',
    status: 'Not Started',
    projectManagers: 'James Miller',
    associatedDeal: 'IT Support & Development – Apex Consulting Group',
    dealOwnerName: 'Super User',
    dealOwnerEmail: 'superuser.staging@yopmail.com',
    addedOn: '27-Feb-2026',
    
    initiallyBoughtHours: 1000,
    topUpHours: 500,
    totalHours: 1500,
    totalBilledHours: '00:00',
    balanceHours: '1500:00',
    topUpRecords: [
      TopUpRecord(comment: 'Client Portal Mobile App Development', topUpHours: '500', addedOn: '02-Mar-2026'),
      TopUpRecord(comment: 'Initial top up', topUpHours: '1000', addedOn: '27 Feb 2026'),
    ],
    timesheetLogs: [
      TimesheetLog(date: '05 Mar 2026', description: 'Worked on the different screen UI/UX creation', hours: '20:00'),
      TimesheetLog(date: '03 Mar 2026', description: 'API integration for dashboard module', hours: '06:30'),
      TimesheetLog(date: '01 Mar 2026', description: 'Bug fixes and QA review session', hours: '04:00'),
    ],
  ),
  ProjectData(
    // HIREBASE PROJECT
    id: '2',
    projectName: 'IT Staff Augmentation – Apex Consulting Group',
    projectType: 'Hirebase Projects',
    status: 'Not Started',
    projectManagers: 'Sarah Chen, Mike Patel',
    associatedDeal: 'IT Staff Augmentation – Apex Consulting Group',
    dealOwnerName: 'Super User',
    dealOwnerEmail: 'superuser.staging@yopmail.com',
    addedOn: '27-Feb-2026',
    
    requiredSkills: ['Java (Android)', 'Node', 'Node JS', 'Python', 'React JS'],
    startDate: '03-Jan-2026',
    endDate: '31-Aug-2026',
    signOffDate: '02-Sep-2026',
    supportStartDate: '01-Sep-2026',
    supportEndDate: '30-Nov-2026',
    supportPeriod: '2M 30D',
    dedicatedResources: [
      // Current Resources (20 generated for mock)
      ...List.generate(20, (index) => DedicatedResource(
        name: ['Sarah Lin', 'Tom Reed', 'James Mora', 'Priya Shah', 'Ken Watanabe', 'Dana Cruz', 'Aaditya Patel', 'Meera Nair', 'Lucas Silva', 'Fatima Hassan'][index % 10] + ' ${index + 1}',
        dateFrom: '01 Mar 2026',
        dateTo: '01 Aug 2026',
        totalWorkingDays: '30',
        expiresIn: '${90 + index * 3}d',
        hiredFor: ['Flutter', 'React JS', 'Node JS', 'Python', 'Java (Android)', 'AWS', 'Angular JS', 'Vue JS', 'Swift', 'Kotlin'][index % 10],
        isCurrent: true,
      )),
      // Past Resources (20 generated for mock)
      ...List.generate(20, (index) => DedicatedResource(
        name: ['Ben Carter', 'Lisa Ray', 'Omar Said', 'Diana Prince', 'Bruce Wayne'][index % 5] + ' (Past)',
        dateFrom: '01 Sep 2025',
        dateTo: '01 Feb 2026',
        totalWorkingDays: '100',
        expiresIn: 'Expired',
        hiredFor: ['C++', 'Ruby', 'PHP', 'Go', 'Rust'][index % 5],
        isCurrent: false,
      )),
    ],
  ),
  ProjectData(
    // FIXED COST PROJECT
    id: '3',
    projectName: 'IT Infrastructure Setup – Apex Consulting Group',
    projectType: 'Fixed Cost',
    status: 'Not Started',
    projectManagers: 'Alex Johnson, Rachel Lee, Tom Davis, Nina Patel',
    associatedDeal: 'IT Infrastructure Setup – Apex Consulting Group',
    dealOwnerName: 'Super User',
    dealOwnerEmail: 'superuser.staging@yopmail.com',
    addedOn: '27-Feb-2026',
    
    requiredSkills: ['AWS (server)', 'Network Configuration'],
    milestones: [
      Milestone(name: 'MILESTONE 1', status: 'Invoice raised'),
      Milestone(name: 'Milestone 2', status: 'Pending'),
    ],
    changeRequests: [
      ChangeRequest(comment: 'Change Request 1', addedOn: '02-Mar-2026', freeOfCost: 'No'),
    ],
  ),
];
