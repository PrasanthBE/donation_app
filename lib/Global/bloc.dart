import 'dart:io';

import 'package:akshaya_pathara/Global/apirepository.dart';

class Bloc {
  ApiRepository _repository = ApiRepository();

  SubmitOnlineDonation(data) async {
    dynamic response = await _repository.SubmitOnlineDonation(data);
    return response;
  }

  CheckPaymentStatusDonation(donation_ref_id) async {
    dynamic response = await _repository.CheckPaymentStatusDonation(
      donation_ref_id,
    );
    return response;
  }

  SavePayInfoDonation(
    donation_id,
    merchant_transaction_id,
    payment_url,
    payment_status,
  ) async {
    print("INSIDE savePaymentInfo DETAILS");
    dynamic response = await _repository.SavePayInfoDonation(
      donation_id,
      merchant_transaction_id,
      payment_url,
      payment_status,
    );
    return response;
  }

  convertCurrency(base, traget, amount) async {
    dynamic response = await _repository.convertCurrency(base, traget, amount);
    return response;
  }

  loginRequest(mobile_number) async {
    print("INSIDE LOGIN REQUEST hello");
    dynamic response = await _repository.loginreqapi(mobile_number);
    return response;
  }

  verifyOTPRequest(mobile_number, pin, fcmtoken) async {
    print("INSIDE LOGIN REQUEST");
    dynamic response = await _repository.verifyotp(
      mobile_number,
      pin,
      fcmtoken,
    );
    return response;
  }

  fetchUnifiedLeadsDistricts(selectstate) async {
    print("INSIDE getUnifiedLeads Districts");
    dynamic response = await _repository.fetchDistricts(selectstate);
    return response;
  }
}
