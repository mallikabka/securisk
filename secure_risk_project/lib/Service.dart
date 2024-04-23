import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  //Fresh Details
  //local url
  // static String baseUrl = 'http://192.168.5.67:9763';

  static String baseUrl = 'http://14.99.138.131:9981';

  //New AWs

  //static String baseUrl = 'http://15.207.90.135:9763';

  // static String add_Rfq_Endpoint = '/rfq/createRfq';
  static Future<Map<String, String>> getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  // static Future<Map<String, String>> getHeaders2() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? accessToken = prefs.getString('accessToken');
  //   return {
  //     'Content-Type': 'multipart/form-data',
  //     'Authorization': 'Bearer $accessToken',
  //   };
  // }

  static String all_Rfq_Endpoint = '/rfq/corporateDetails/allRfq';

  static String all_Rfq_SendRfq = '/rfq/corporateDetails/sendRFQ/';

  static String download_Rfq = '/rfq/download/pdf/';

  static String createcoverageDetails_Endpoint = '/rfq/coverage/createCoverage';
  static String updatecoverageDetails_Endpoint =
      '/rfq/coverage/updateCovergae?rfqId=';
  static String getcoveragesByIdDetails_Endpoint =
      '/rfq/coverage/getCoverageDetailsById?rfqId=';
  static String Coverage_Upload_Endpoint = '/rfq/coverage/uploadFile';

  static String EmpData_Headers_validation = '/rfq/coverage/headerValidation';
  static String ClaimsMis_Headers_validation =
      '/rfq/coverage/headerClaimsMiscValidation';

  static String Claims_policy_details =
      "/rfq/coverage/getClaimsDetailsAfterUpload?rfqId";

  static String getAll_usersBy_Location = "/roles/getAllUsersByLocationIdLogin";

  static String Send_Email_Downloaded_Template =
      '/rfq/coverage/sendEmailWithDownloadTemplateAttachement';
  static String Coverage_EmpDepData = '/rfq/coverage/getAllEmpDepData?rfqId=';
  static String Coverage_ClaimsMis = '/rfq/coverage/getAllClaimsMis?rfqId=';
  static String GetAllEmpDepDataWithStatus =
      '/rfq/coverage/getAllEmpDepDataWithStatus';
  static String GetAllClaimsMisWithStatus =
      '/rfq/coverage/getAllClaimsMisWithStatus';
  static String AddFileNames = '/rfq/header/addEmpDepHeader';
  static String GetAllEmployeeHeaders = '/rfq/header/getAllEmpDependentHeaders';

  static String createCorporateDetails_Endpoint =
      '/rfq/corporateDetails/createCorporateDetails';

  static String createPloicyTerms_Endpoint =
      '/rfq/policyTerms/createPolicyTerms';

  //nature of business
  static String getAllnatureOfBusiness =
      "/rfq/NatureofBusiness/getllNatureofBusiness";
  static String saveNatureofBusiness =
      "/rfq/NatureofBusiness/saveNatureofBusiness";

  //
  static String getPloicyTermsByProductId_Endpoint =
      '/rfq/intermediatrydetails/getCoveragesByProductId/';

  static String updatePloicyTerms_Endpoint =
      '/rfq/policyTerms/updatePolicyTerms';

  static String product_Category_Endpoint = '/rfq/category/prodCategory';

  static String product_List_Endpoint = '/products/getProductcategory/';
  static String product_getAll_Endpoint = '/products/get/all';

  static String send_email = '/rfq/coverage/sendEmail';
  //renewal details
  static String renewal_Corporate_Details =
      '/rfq/corporateDetails/createCorporateDetails';

  static String renewal_Coverage_CreateCoverage =
      '/rfq/coverage/createCoverage';
  static String renewal_Coverage_UpdateCoverage =
      '/rfq/coverage/updateCovergae?rfqId=';
  static String renewal_Expiry_Details =
      '/rfq/expiryDetails/createExpiryDetails';

  static String claims_Feilds_data_EndPoint =
      '/rfq/claimDetails/getClaimsDump/';

  static String renewal_Claims_Details = '/rfq/claimDetails/createClaimDetails';

  static String renewal_PolicyTerms_Details =
      'rfq/RenewalPolicyTermsDetails/createPolicyTerms';
  // static String Send_Emails_with_attachement ='/rfq/coverage/sendEmailWithDownloadTemplateAttachement';

  static String renewal_Coverage_getAllEmpdata =
      '/rfq/coverage/getAllEmpDepData?rfqId=';

  //Intermediatory Details
  static String intermediatoryDetails_getAll =
      '/rfq/intermediatrydetails/getAll';

  static String intermediatoryDetails_getAllInsurerListByName_EndPoint =
      '/rfq/intermediatrydetails/getAllInsurerListByName';

  static String intermediatoryDetails_getClinetListWithUserEmails_EndPoint =
      '/rfq/intermediatrydetails/getClientListWithUserEmails';

  static String intermediatoryDetails_add_EndPoint =
      '/rfq/intermediatrydetails/add';
  static String intermediatoryDetails_addUser_EndPoint = '/rfq/users/add/';
  static String intermediatoryDetails_getAllByInsureList =
      '/rfq/users/getAllByInsureList/';
  static String intermediatoryDetails_updateUser = '/rfq/users/update/';
  static String intermediatoryDetails_deleteUser = '/rfq/users/delete/';
  static String intermediatoryDetails_update =
      '/rfq/intermediatrydetails/update/';
  static String intermediatoryDetails_delete =
      '/rfq/intermediatrydetails/delete/';

  static String intermediatoryDetails_get_products_EndPoint =
      ' /rfq/intermediatrydetails/getAllIntermediaryDetails';

  //Edit all rfq details
  static String EditCorporate_Details_EndPoint =
      '/rfq/corporateDetails/getRfqById?rfqId=';

  static String Update_Corporate_Details_EndPoint =
      '/rfq/corporateDetails/updateRFQ?rfqIdValue=';

  static String EditPolicyTerms_Details_EndPoint =
      '/rfq/policyTerms/getPolicyTermsById?rfqId=';

  static String Renewal_EditExpiry_Details_EndPoint =
      '/rfq/expiryDetails/getExpiryDetailsById?rfqId=';

  static String Renewal_EditClaims_Details_EndPoint =
      '/rfq/claimDetails/getClaimDetailsById/';

  static String fresh_Edit_Coverages_EndPiont =
      '/rfq/coverage/updateCovergae?rfqId=';

  static String renewal_Ghi_ClaimDetails_update =
      "/rfq/claimDetails/updateClaimDetails/";
  //Clinet List
  static String ClientList_getAll_EndPoint = '/rfq/clientList/getAllClientList';

  static String ClientList_location_EndPoint = '/location/getAllLocations';

  static String ClientList_productType_EndPoint = '/products/getAllProduct';
  static String ClientList_getAll_Insurance =
      '/rfq/intermediatrydetails/getAllInsurers';
  static String ClientList_designation_EndPoint =
      '/rfq/designation/getAllDesignation';
  static String ClientList_tpa_EndPoint = '/tpa/getAllTpa';

  static String ClientList_add_EndPoint = '/rfq/clientList/add';

  static String ClientList_adduser_EndPoint = '/clientList/addUser';

  static String ClientList_fetchuserList_EndPoint = '/clientList/getAllUsers';

  static String ClientList_fetchproductList_EndPoint =
      '/products/getAllProductsWithClientListId';

  static String ClientList_edituserList_EndPoint =
      '/clientList/updateClientUserById';

  static String ClientList_deleteuser_EndPoint =
      '/clientList/deleteUserByClientListId';

  static String ClientList_deleteproduct_EndPoint =
      '/products/deleteClientListProduct';

  static String ClientList_editclient_EndPoint = '/rfq/clientList/updateClient';

  static String ClientList_deleteclient_EndPoint =
      '/rfq/clientList/deleteClientByClientListId';

  static String ClientList_addproduct_EndPoint = '/products/addProduct';

  static String ClientList_editproduct_EndPoint =
      '/products/updateClientListProduct/';

//Intermediate

  //Products
  static String ClientList_getAll_Product = '/products/get/all';
  static String InsurerList_ProductType_EndPoint = '/rfq/category/prodCategory';
  static String InsurerList_AddProduct_EndPoint = '/products/addProduct';
  static String InsurerList_AddCovarage_EndPoint =
      '/rfq/intermediatrydetails/createCoverageByProductId/';
  static String InsurerList_showCovarage_EndPoint =
      '/rfq/intermediatrydetails/getCoveragesByProductId/';
  static String InsurerList_editProduct_EndPoint =
      '/products/updateproductById/';
  static String InsurerList_deleteProduct_EndPoint =
      '/products/deleteproductById/';
  static String InsurerList_deleteCoverage_EndPoint =
      '/rfq/intermediatrydetails/deleteCoverage/';
  static String InsurerList_editCoverage_EndPoint =
      '/rfq/intermediatrydetails/updateCoverage/';
  static String InsurerList_AddInsurer_EndPoint =
      '/rfq/intermediatrydetails/add';
  //Insurer
  static String InsurerList_getAllInsurer_EndPoint =
      '/rfq/intermediatrydetails/getClientListWithUserEmails';

  static String InsurerList_Adduser_EndPoint = '/rfq/users/add/';
  static String InsurerList_fetchuserList_EndPoint =
      '/rfq/users/getAllByInsureList/';
  static String InsurerList_editUser_EndPoint = '/rfq/users/update/';
  static String InsurerList_deleteUser_EndPoint = '/rfq/users/delete/';
  static String InsurerList_editInsurer_EndPoint =
      '/rfq/intermediatrydetails/update/';
  static String InsurerList_deleteInsurer_EndPoint =
      '/rfq/intermediatrydetails/delete/';
  static String Location_Edit = '/location/updateLocation/';
  static String Delete_location = '/location/deleteLocation/';
  static String Location_add_user = '/roles/create-userLogin?';

  //forgot
  static String Forgot_EndPoint = '/roles/forgotPassword/sendOtp';

  static String user_login_EndPoint = '/user/authenticate';

  static String location_getall_EndPoint = '/location/getAllLocations';

  //TPA Details
  static String Tpa_getall_EndPoint = '/tpa/getAllTpa';
  static String Tpa_Create_EndPoint = '/tpa/createTpa';
  static String Tpa_Update_EndPoint = '/tpa/updateTpa/';
  static String Tpa_Delete_EndPoint = '/tpa/deleteTpa/';
  static String Tpa_List_EndPoint = '/tpa/getTpaList';

  //Downloads
  static String Age_Binding = '/rfq/getAgebandingReport/';
  static String IRDA_Format = '/rfq/download/irda?rfqId=';
  static String RFQ_Coverage = '/rfq/download/coveragePdf/';
  static String Mandate_Letter = '/rfq/coverage/downloadMandateLetter/';
  static String Employee_Dependent_Data = '/rfq/download/employeeData?id=';
  // static String Claims_Summary = '/rfq/download/employeeData?id=';
  static String Coverages_Sought = '/rfq/download/employeeData?id=';
  static String Claims_Mis = '/rfq/coverage/downloadclaimMis/';
  static String Claims_Analysis = '/rfq/getclaimAnalysisReportById/';
  static String Archives_file = '/clientList/addUser/';
  static String Download_Template = '/rfq/excel/getDownloadedTemplate';

// Emails
  static String Emails =
      '/rfq/intermediatrydetails/getClientListWithUserEmails';

  //update renewal details
  static String update_Renewal_CorporateDetails_EndPoint =
      '/rfq/corporateDetails/updateRFQ?rfqIdValue=';

  static String update_Renewal_ExpiryDetails_EndPoint =
      '/rfq/expiryDetails/updateExpiryDetails/';

  static String update_Renewal_EditClaims_Details_EndPoint =
      '/rfq/claimDetails/updateClaimDetails/';

  //Location

  static String CreateLocation_GetLocationEndPoint =
      '/location/getAllLocations';

  //Roles

  static String rolesGetAllOperation = '/roles/getAllOperation';
  static String createAndUpdateRoles = '/login/roles/create';
  static String getAllDesignations = '/roles/getAllDesignation';
  static String fetchAllPermissionsByDesignationId =
      '/login/roles/getAllPermittedOperationIdsByDesignationId?designationId=';

  //Templates
  static String getAll_Templates = '/api/templates/byType/rfq';
  static String get_ByID_Template = '/api/templates/data';
  static String download_TemplateById = '/api/templates/';

  //Reset Passwords
  static String reset_Password = '/user/reset';

  //locations
  static String roles_getAllDepartment = '/roles/getAllDepartment';

  //Template Data

  static String getAll_TemplatesData = '/api/templates/byType/';

  static String create_Templates = '/api/templates/create';
  static String update_Templates = '/api/templates/update/';

  static String edit_Templates = '/api/templates/data/';

  static String delete_Templates = '/api/templates/delete/';

  static String dashboard_api =
      '/rfq/corporateDetails/getdashboardrfqmonthCount';

  static String dashboard_api_locationbased = '/location/getAllLocations';

  static String dashboard_api_locationbased_count =
      '/rfq/corporateDetails/getdashboardCountBasedOnLocation/';

  static String dashboard_api_monthyear =
      '/rfq/corporateDetails/getDashboardRfqMonthYearCount?month=';

  static String get_all_locations = '/location/getAllLocations';

  static String get_dashboard_count =
      '/rfq/corporateDetails/getdashboardCountBasedOnLocation';

  static String download_all = '/dowloadZip/reports?rfqId=';

  //Endorsement
  static String createEndorsement = "/clientlist/endorsement/createEndorsement";
  static String getAllEndorsement = "/clientlist/endorsement/getAllEndorsement";
  static String deleteEndorsement =
      "/clientlist/endorsement/deleteEndorsement/";
  static String getByIDEndorsement =
      "/clientlist/endorsement/getByIdEndorsement?endorsementId=";
  static String updateEndorsementApi =
      "/clientlist/endorsement/updateEndorsement/";

  static String downloadApi =
      "/clientlist/endorsement/downloadFileByEndorsementId?endorsementId=";
  //ClientList dashboard
  static String endorsementDownloadapi = "/clientlist/endorsement/downloadAll";

//policy
  static String client_addPolicy = '/rfq/policy/addPolicy';
  static String getPolicyById = "/rfq/policy/getAPolicy?";

  static String getAllActiveList_memberDetails =
      "/clientList/memberDetails/getAllMemberDetailsForActiveList";

// Client List Memeber details
  static String getAllMasterList_EndPoint =
      "/clientList/memberDetails/getAllMembersDetailsForMasterList";

  static String getAllMemberdetailsForAdditions_Endpoint =
      "/clientList/memberDetails/getAllAdditionList";

  static String deletionMemberDetails =
      "/clientList/memberDetails/getAllDeletedList";
  static String createEmployeeMemberDetails =
      "/clientList/memberDetails/createMemberDetails";

  static String getAllMemberDetailsById_EndPoint =
      "/clientList/memberDetails/getMemberDetailsByClientListProduct?memberDetailsId=";

  static String updateMemberdetails_InAdditionsEndpoint =
      "/clientList/memberDetails/updateMemberDetails";

  static String deleteMemberDetails =
      "/clientList/memberDetails/deleteMemberDetails?memberDetailsId=";

  static String correctionMemberDetails =
      "/clientList/memberDetails/getAllCorrectionsList";

  static String getAllMemberdetailsPending =
      "/clientList/memberDetails/getAllPendingList";

  static String exportMemberDetails =
      "/clientList/memberDetails/getAllMembersDetailsInExcelFormatByClientListProduct";

  static String exportMemberDetailsAdditionsApi =
      "/clientList/memberDetails/getAllAdditionListInExcel?";

  static String exportMemberDetailsDeletionApi =
      "/clientList/memberDetails/getAllDeletedListInExcel?";

  static String exportMemberDetailsCorrectionApi =
      "/clientList/memberDetails/getAllCorrectionListInExcel?";

  static String exportMemberDetailsActiveApi =
      "/clientList/memberDetails/getAllActiveListInExcel?";

  static String exportMemberDetailsPendingApi =
      "/clientList/memberDetails/getAllPendingListInExcel?";
  static String activeListDownloadTemplate =
      "/clientList/memberDetails/getActiveListDownloadedTemplate";
  static String additionsDownloadTemplate =
      "/clientList/memberDetails/getAdditionListDownloadedTemplate";
  static String correctionsDownloadTemplate =
      "/clientList/memberDetails/getCorrectionListDownloadedTemplate";
  static String deletedListDownloadTemplate =
      "/clientList/memberDetails/getDeletedListDownloadedTemplate";
  static String pendingListDownloadTemplate =
      "/clientList/memberDetails/getPendingListDownloadedTemplate";
  static String enrollmentListDownloadTemplate =
      "/clientList/memberDetails/getEnrollementListDownloadedTemplate";
  // client list claims mis

  static String Clientlist_claimsMis_masterList_Endpoint =
      "/ClientDetails/ClaimsMis/getAllClaimsMis";

  static String clientList_ClaimsMis_headervalidation_endpoint =
      "/ClientDetails/ClaimsMis/headerClaimsMiscValidation";
  static String clientList_ClaimsMis_uploadFile =
      "/ClientDetails/ClaimsMis/uploadFile";
  static String clamisMisGetAllStatus =
      "/ClientDetails/ClaimsMis/getAllClaimsMisWithStatus";

  static String clientListClaimsMisExportEndPoint =
      "/ClientDetails/ClaimsMis/clientDetailsClaimsMisDetailsExport";

  static String clientListclaimsMisCount =
      "/ClientDetails/ClaimsMis/clientClaimsTotalCount";

  //Client-Details

  static String getAllClientDetails =
      "/clientlist/ClientDetails/getAllClientDetails";

  static String createClientDetails =
      "/clientlist/ClientDetails/createClientDetails";
  static String deleteClientDetails =
      "/clientlist/ClientDetails/deleteClientDetails/";

  static String clientDetailsDownloadAll_endpoint =
      "/clientlist/ClientDetails/downloadAll";

  static String clientDetailsdownloadByClientListId =
      "/clientlist/ClientDetails/downloadFileByClientDetailsId?clientDetailsId=";

  static String getClientDetailsByClientListId =
      "/clientlist/ClientDetails/getByIdClientDetails?clientDetailsId=";

  static String updateClientDetails_endpoint =
      "/clientlist/ClientDetails/updateClientDetails";
  static String generatePdfMemberdetailsApiEndpoint =
      "/rfq/download/clientListCoverage";
//rfq/download/clientListCoverage
  //contact Api
  static String contactGetAllContacts =
      "/clientList/contactDetails/getAllContactDetails";
  static String createmanagement =
      "/clientList/contactDetails/createContactDetails";
  static String deleteManagement =
      "/clientList/contactDetails/deleteContactDetailsByContactId?contactId=";
  static String updateManagement =
      "/clientList/contactDetails/updateContactDetailsByContactId?contactId=";

  //insurer bank details
  static String createInsurerBank =
      "/clientlist/insurerBankDetails/createInsurer";
  static String getAllInsurerbankdetails =
      "/clientlist/insurerBankDetails/getAllInsurer";
  static String deleteInsure = "/clientlist/insurerBankDetails/deleteInsurer/";
  static String updateInsure = "/clientlist/insurerBankDetails/updateInsurer/";
  static String exportInsure =
      "/clientlist/insurerBankDetails/insurerBankDetailsExport?";

  //Ecards
  static String getAllEcards = "/clientList/ECard/getAllECard?";
  static String createEcards = "/clientList/ECard/createECard?";
  static String deleteEcards = "/clientList/ECard/deleteECard/";
  static String downloadByEcards =
      "/clientList/ECard/downloadFileByECardId?eCardId=";
  static String getByEcards = "/clientList/ECard/getByIdECard?eCardId=";
  static String updateEcards = "/clientList/ECard/updateECard/";

  //premium Family Calculator
  static String createPremiumFamily =
      "/rfq/PreFamilyPremium_Calcuater/saveClientList_PreFamilyPremium_Calcuater";
  static String getAllfamilyDetails =
      "/rfq/PreFamilyPremium_Calcuater/getAllPremiumCalcuaters";
  static String deleteFamilyDetails =
      "/rfq/PreFamilyPremium_Calcuater/deleteClientList_PreFamilyPremium_Calcuater?primary_Id=";
  static String exportFamily = "/rfq/PreFamilyPremium_Calcuater/exportExcel?";

  //Entrollment upload
  static String headerValiderApi =
      "/clientList/memberDetails/headerValidationEnrollment?";
  static String valueValidaterApi =
      "/clientList/memberDetails/getEnrollmentWithStatus?tpaName=";
  static String getAllClientEntrollmentDetails =
      "/clientList/memberDetails/getAllclientListEnrollmentData?";
  static String uploadEntrollermentDetail =
      "/clientList/memberDetails/uploadEnrollementData?";
  static String exportEntrollermentDetail =
      "/clientList/memberDetails/getAllEnrollementListInExcel";
  static String updatePremiumFamilyDeatils =
      "/rfq/PreFamilyPremium_Calcuater/updateClientListFamilyPremiumCalcuater";

  //Premium Life Calculator
  static String getAllLifePremiumCalculator =
      "/rfq/Pre_Life_Premium_Calcuater/getAll_Life_PremiumCalcuaters";
  static String deleteLifeCalculator =
      "/rfq/Pre_Life_Premium_Calcuater/deleteClientList_Pre_Life_Premium_Calcuater?primary_Id=";
  static String exportLifeCalculator =
      "/rfq/Pre_Life_Premium_Calcuater/exportExcel?";
  static String createPremiumLifeCalculator =
      "/rfq/Pre_Life_Premium_Calcuater/saveClientList_Pre_LifePremium_Calcuater";
  static String updateLifePremiumCalculator =
      "/rfq/Pre_Life_Premium_Calcuater/updateClientList_Life_PremiumCalcuaterDto";

//CD Balance
  static String uploadCdBalance =
      "/rfq/Cd_balanceHeaderUploadController/Cd_balanceheaderSave";
  static String getCdBalanceDetails =
      "/rfq/Cd_balanceHeaderUploadController/cd_balanceheadergetDataByClientIdAndProductId";
  static String cdBalanceHeaderValidationApi =
      "/rfq/Cd_balanceHeaderUploadController/Cd_balanceheaderValidation";
  static String exportCdBalanceDetails =
      "/rfq/Cd_balanceHeaderUploadController/exportExcel?";
  static String cdBalanceValueValidation =
      "/rfq/Cd_balanceHeaderUploadController/Cd_balancevaluevalidation";

  static String updateCdBalance =
      "/rfq/Cd_balanceHeaderUploadController/updateCdBalanceData?cd_balanceId=";
  static String deleteCdBalance =
      "/rfq/Cd_balanceHeaderUploadController/deleteCd_balanceheadergetDataById?cd_balanceId=";

  //Network Hospital
  static String headerValidation_networkHospital =
      "/clientList/networkDetails/headerValidationForHospital?tpaName=";
  static String getAllNetworkHospitalDetails =
      "/clientList/networkDetails/getAllClientListNetWorkHospital";
  static String valueValidationNetworkHospital =
      "/clientList/networkDetails/getNetworkHospitalWithStatus?tpaName=";
  static String uploadNetworkHospital =
      "/clientList/networkDetails/uploadNetWorkHospital";
}
