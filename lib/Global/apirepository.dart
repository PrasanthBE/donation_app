import 'package:akshaya_pathara/Apiservice/common_api.dart';
import 'package:akshaya_pathara/Apiservice/loginapi.dart';
import 'package:akshaya_pathara/Apiservice/save_online_donation_api.dart';
import 'package:akshaya_pathara/Apiservice/save_payment_status.dart';

class ApiRepository {
  final saveonlinedonation = SaveOnlineDonation();
  final savepaymentstausdonation = SavePaymentStausDonation();
  final loginapi = Loginapi();
  final commonapi = CommonApi();
  Future<dynamic> SubmitOnlineDonation(data) =>
      saveonlinedonation.SubmitOnlineDonation(data);
  Future<dynamic> CheckPaymentStatusDonation(donation_ref_id) =>
      savepaymentstausdonation.CheckPaymentStatusDonation(donation_ref_id);
  Future<dynamic> SavePayInfoDonation(
    donation_id,
    merchant_transaction_id,
    payment_url,
    payment_status,
  ) => savepaymentstausdonation.SavePayInfoDonation(
    donation_id,
    merchant_transaction_id,
    payment_url,
    payment_status,
  );
  Future<dynamic> convertCurrency(base, traget, amount) =>
      saveonlinedonation.convertCurrency(base, traget, amount);
  Future<dynamic> loginreqapi(mobile_number) =>
      loginapi.loginRequest(mobile_number);

  Future<dynamic> verifyotp(mobile_number, pin, fcmtoken) =>
      loginapi.verfiyOtp(mobile_number, pin, fcmtoken);
  Future<dynamic> fetchDistricts(selectstate) =>
      commonapi.fetchDistricts(selectstate);
}
