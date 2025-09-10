class UpcomingDonationModel {
  final String donorId;
  final String donorName;
  final String charityName;
  final String donationType;
  final int donationAmount;
  final int totalMonths;
  final int monthsRemaining;
  final String lastPaymentDate;
  final String upcomingDueDate;
  final List<Map<String, dynamic>> donationSchedule; // updated here
  final String charityContact;
  final String charityEmail;
  final String notes;
  final String createdDate;

  UpcomingDonationModel({
    required this.donorId,
    required this.donorName,
    required this.charityName,
    required this.donationType,
    required this.donationAmount,
    required this.totalMonths,
    required this.monthsRemaining,
    required this.lastPaymentDate,
    required this.upcomingDueDate,
    required this.donationSchedule,
    required this.charityContact,
    required this.charityEmail,
    required this.notes,
    required this.createdDate,
  });

  factory UpcomingDonationModel.fromMap(Map<String, dynamic> map) {
    return UpcomingDonationModel(
      donorId: map['donor_id'] ?? '',
      donorName: map['donor_name'] ?? '',
      charityName: map['charity_name'] ?? '',
      donationType: map['donation_type'] ?? '',
      donationAmount: map['donation_amount'] ?? 0,
      totalMonths: map['total_months'] ?? 0,
      monthsRemaining: map['months_remaining'] ?? 0,
      lastPaymentDate: map['last_payment_date'] ?? '',
      upcomingDueDate: map['upcoming_due_date'] ?? '',
      donationSchedule: List<Map<String, dynamic>>.from(
        map['donation_schedule'] ?? [],
      ), // updated
      charityContact: map['charity_contact'] ?? '',
      charityEmail: map['charity_email'] ?? '',
      notes: map['notes'] ?? '',
      createdDate: map['created_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donor_id': donorId,
      'donor_name': donorName,
      'charity_name': charityName,
      'donation_type': donationType,
      'donation_amount': donationAmount,
      'total_months': totalMonths,
      'months_remaining': monthsRemaining,
      'last_payment_date': lastPaymentDate,
      'upcoming_due_date': upcomingDueDate,
      'donation_schedule': donationSchedule,
      'charity_contact': charityContact,
      'charity_email': charityEmail,
      'notes': notes,
      'created_date': createdDate,
    };
  }
}
