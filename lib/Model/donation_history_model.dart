// class DonationHistoryModel {
//   final String donar_ref_id;
//   final String donar_name;
//   final String mobile_number;
//   final String email;
//   final String address;
//   final String birth_date;
//   final String pan_number;
//   final String pincode;
//   final String city;
//   final String state;
//   final String donation_type;
//   final String transcation_status;
//   final String created_date_formatted;
//
//   DonationHistoryModel({
//     required this.donar_ref_id,
//     required this.donar_name,
//     required this.mobile_number,
//     required this.email,
//     required this.address,
//     required this.birth_date,
//     required this.pan_number,
//     required this.pincode,
//     required this.city,
//     required this.state,
//     required this.donation_type,
//     required this.transcation_status,
//     required this.created_date_formatted,
//   });
// }
class DonationHistoryModel {
  final String charityName;
  final String description;
  final String registrationNo;
  final String contactEmail;
  final String website;
  final String donationType;
  final String amount;
  final String mobileNumber;
  final String transcation_status;
  final String donatedOn;

  DonationHistoryModel({
    required this.charityName,
    required this.description,
    required this.registrationNo,
    required this.contactEmail,
    required this.website,
    required this.donationType,
    required this.amount,
    required this.mobileNumber,
    required this.transcation_status,
    required this.donatedOn,
  });

  factory DonationHistoryModel.fromMap(Map<String, dynamic> map) {
    return DonationHistoryModel(
      charityName: map['charity_name'] ?? '',
      description: map['description'] ?? '',
      registrationNo: map['registration_no'] ?? '',
      contactEmail: map['contact_email'] ?? '',
      website: map['website'] ?? '',
      donationType: map['donation_type'] ?? '',
      amount: map['amount'] ?? '',
      mobileNumber: map['mobile_number'] ?? '',
      transcation_status: map['transcation_status'] ?? '',
      donatedOn: map['donated_on'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'charity_name': charityName,
      'description': description,
      'registration_no': registrationNo,
      'contact_email': contactEmail,
      'website': website,
      'donation_type': donationType,
      'amount': amount,
      'mobile_number': mobileNumber,
      'transcation_status': transcation_status,
      'donated_on': donatedOn,
    };
  }
}
