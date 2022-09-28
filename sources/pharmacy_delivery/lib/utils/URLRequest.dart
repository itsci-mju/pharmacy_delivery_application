class URLRequest {
  static const String URL = "http://172.16.1.77:8081/PharmacyDelivery";
  //static const String URL = "http://10.15.16.165:8081/PharmacyDelivery";

  static const String URL_list_drugstore = URL+"/drugstore/list";

  static const String URL_list_coupon = URL+"/coupon/list";
  static const String URL_coupon_check = URL+"/coupon/check";
  static const String URL_coupon_min = URL+"/coupon/min";


  static const String URL_list_review = URL+"/review/list";
  static const String URL_review_getmember = URL+"/review/getmember";
  static const String URL_review_add = URL+"/review/add";


  static const String URL_member_login = URL+"/member/login";
  //static const String URL_member_getprofile= URL+"/member/getprofile";

  static const String URL_pharmacist_login= URL+"/pharmacist/login";
  static const String URL_pharmacist_logout= URL+"/pharmacist/logout";

  //static const String URL_pharmacist_getprofile= URL+"/pharmacist/getprofile";
  static const String URL_pharmacist_checkonline= URL+"/pharmacist/checkonline";

  static const String URL_member_register= URL+"/member/register";
  static const String URL_list_member= URL+"/member/list";

  static const String URL_advice_add= URL+"/advice/add";
  static const String URL_advice_update_orderId= URL+"/advice/update_orderId";
  static const String URL_advice_end = URL+"/advice/end";
  static const String URL_advice_get = URL+"/advice/get";
  //static const String URL_advice_end_member = URL+"/advice/end_member";


  static const String URL_message_list = URL+"/message/list";
  static const String URL_message_add = URL+"/message/add";

  static const String URL_medicine_list = URL+"/medicine/list";

  static const String URL_stock_list = URL+"/stock/list";
  static const String URL_stock_get = URL+"/stock/get";

  static const String URL_orders_add = URL+"/orders/add";
  static const String URL_orders_get = URL+"/orders/get";
  static const String URL_orders_pCancel = URL+"/orders/pCancel";
  static const String URL_orders_confirm = URL+"/orders/confirm";
  static const String URL_orders_cancel_member = URL+"/orders/cancel_member";
  static const String URL_orders_list_status = URL+"/orders/list_status";
  static const String URL_orders_list_status_pharmacist = URL+"/orders/list_status_pharmacist";
  static const String URL_orders_success_store = URL+"/orders/success_store";
  static const String URL_orders_add_shipping = URL+"/orders/add_shipping";
  static const String URL_orders_pay = URL+"/orders/pay";




  static const String URL_order_detail_add= URL+"/order_detail/add";
  static const String URL_order_detail_list= URL+"/order_detail/list";

  static const String URL_address_list = URL+"/address/list";
  static const String URL_address_add = URL+"/address/add";
  static const String URL_address_remove = URL+"/address/remove";
  static const String URL_address_get = URL+"/address/get";


}















