//
//  Constant.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/5/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#ifndef Constant_h
#define Constant_h



#define TAG_USERTYPE_CONSULTING 1001
#define TAG_USERTYPE_AWARENESS 1002






#define IsSectorApiHit @"IsSectorApiHit"
#define IsCountryCodeHit @"IsCountryCodeHit"

#define BoolValueKey @"BoolValue"
#define AlertKey @"Alert"

//Cloud Related


//Api related


#define loginPassword @"password"
#define loginemail @"email"
#define loginfirstname @"first_name"
#define loginlastname @"last_name"
#define loginDob @"date_of_birth"
#define loginPrimarymobile @"mobile_primary"
#define loginSecondarymobile @"mobile_number"
#define loginusergroup @"user_group"
#define loginuserId @"user_id"
#define loginuserType @"user_type"
#define loginuserGender @"gender"
#define loginuseIsComplete @"is_complete"
#define loginUserToken @"token"
#define loginUser @"user"
#define isLoggedIn @"isLoggedIn"
#define isCartApiHIt @"isCardHIt"
#define Nationality @"nationality"
#define Residence @"residence"
#define WorkPlace @"workplace"
#define HomeLocation @"home_location"
#define Passport @"passport"
#define Specialist @"specialist"
#define currentGrade @"current_grade"
#define SubSpecialist @"sub_specialist"
#define classification @"classification"
#define Experience @"experience"
#define HospitalName @"hospital_name"
#define WorkedSince @"worked_since"
#define ResignedSince @"resigned_since"
#define IBAN @"iban"
#define Photo @"photo"
#define Document @"document"
#define API_Status @"status"


#define codeForActivatedAccount @"NP001"
//Color related

#define primary_Button_Color @"E91463"
#define Primary_Text_Color @"ED1C24"

//Url Related
#define firstName @"firstName"
#define lastName @"lastName"
#define emailId @"emailId"
#define mobileNo @"mobileNo"
#define recordID @"recordId"
#define isdCode @"isdCode"
#define passwordToStore @"password"
#define productCategory_id @"category_id"
#define productsubcategory_id @"subcategory_id"


#define isValidHitGB @"GB001"
#define isValidHitOther @"SA001"
#define LoginData @"userPojo"
#define NPHeaderName @""
#define ShreeHeaderName @"np-appusr-rest:Xy#!@#@123"
#define LocationHeaderName @"np-loc-rest:internal@123"



#define selected_Nationality @"Nationality"



#define Privacy @"Privacy"
#define TermsAndCondition @"Terms"
#define FarePolicy @"Fair"
#define ContactUS @"Contact"

#define UPCOMING @"upcoming"
#define COMPLETED @"completed"
#define CANCELED @"canceled"

//testing url


static NSString* const COLORCODE = @"#E91463";
static NSString* const COLORCODE_FOR_TEXTFIELD = @"#00b1dd";



static NSString* const API_BASE_URL = @"http://dataheadstudio.com/bazar/api/";
static NSString* const API_Header = @"ummuhlLUAqkxEINRyKbg7Lzt5sEKzOEg";


static NSString* const API_REGISTER_USER_URL = @"users/register";
static NSString* const API_LOGIN_URL = @"users/login";
static NSString* const API_CHANGE_PASSWORD_URL = @"manage/AdminUser";
static NSString* const API_RESET_PASSWORD_URL = @"users/forgot";
static NSString* const API_FOR_ADDRESS = @"http://postalpincode.in/api/pincode/";
static NSString* const API_FOR_CREATE_ADDRESS = @"users/createaddress";
static NSString* const API_FOR_Update_ADDRESS = @"users/updateaddress";
static NSString* const API_FOR_ADDRESS_LIST = @"users/addresses";
static NSString* const API_FOR_DELETE_ADDRESS = @"users/deladdress";
static NSString* const API_FOR_CATEGORIES = @"product/categories";
static NSString* const API_FOR_PRODUCTLIST = @"product/productbycategories";
static NSString* const API_FOR_UPDATE_PROFILE = @"users/updateuser";
static NSString* const API_FOR_CART_ITEMS = @"product/cart";
static NSString* const API_FOR_ADD_TO_CART = @"product/addcart";
static NSString* const API_FOR_DELETE_FROM_CART = @"product/deletecart";
static NSString* const API_FOR_PLACE_ORDER = @"order/orderitem";
static NSString* const API_FOR_MY_ORDERS = @"order/userorders";


static NSString* const API_FOR_CHANGE_PASSWORD = @"users/updateuser";
#endif /* Constant_h */ 
