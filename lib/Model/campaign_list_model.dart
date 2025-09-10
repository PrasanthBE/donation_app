class CampaignModel {
  final String registerId;
  final String imageUrl;
  final String campaignFor;
  final String campaignName;
  final double raisedAmount;
  final double goalAmount;
  final String description;
  final String startDate;
  final String endDate;
  final String createdDate;

  CampaignModel({
    required this.registerId,
    required this.imageUrl,
    required this.campaignFor,
    required this.campaignName,
    required this.raisedAmount,
    required this.goalAmount,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdDate,
  });

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      registerId: map['registerId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      campaignFor: map['campaignFor'] ?? '',
      campaignName: map['campaignName'] ?? '',
      raisedAmount: (map['raisedAmount'] ?? 0).toDouble(),
      goalAmount: (map['goalAmount'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      createdDate: map['created_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'registerId': registerId,
      'imageUrl': imageUrl,
      'campaignFor': campaignFor,
      'campaignName': campaignName,
      'raisedAmount': raisedAmount,
      'goalAmount': goalAmount,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'created_date': createdDate,
    };
  }
}
