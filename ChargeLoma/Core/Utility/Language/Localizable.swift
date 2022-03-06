//
//  Localizable.swift
//  ChargeLoma
//
//  Created by Nontawat Kanboon on 29/12/2564 BE.
//

import Foundation

/// Example
/// Text render :
/// ***
///    Text(Wording.TabBar.home.localized) // return string
/// ***


public enum Wording {
    public enum Profile: String, LocalizableDelegate {
        case TopReview = "TopReview"
        case Language = "Language"
        case About = "About"
        case Login = "Login"
        case Logout = "Logout"
        case Profile = "Profile"
        case Favorite = "Favorite"
    }
    
    public enum MainTabbar: String, LocalizableDelegate {
        case Home = "Home"
        case Go = "Go"
        case ForYou = "ForYou"
        case Add = "Add"
        case Me = "Me"
    }
    
    public enum About: String, LocalizableDelegate {
        case AboutDesc = "About_Desc"
        case AboutHeadVersion = "About_Head_Version"
        case AboutHeadUpdate = "About_Head_Update"
        case AboutHeadDeveloper = "About_Head_Developer"
        case AboutHeadContact = "About_Head_Contact"
        case AboutHeadThankYou = "About_Head_ThankYou"
        case AboutHeadCopyright = "About_Head_Copyright"
    }
    
    public enum EditProfile: String, LocalizableDelegate {
        case EditProfile_DisplayName = "EditProfile_DisplayName"
        case EditProfile_Email = "EditProfile_Email"
        case EditProfile_Tel = "EditProfile_Tel"
        case EditProfile_Car = "EditProfile_Car"
        case EditProfile_Save = "EditProfile_Save"
        case EditProfile_Register = "EditProfile_Register"
        case EditProfile_Password = "EditProfile_Password"
        case EditProfile_ConfirmPassword = "EditProfile_ConfirmPassword"
    }
    
    public enum Login: String, LocalizableDelegate {
        case Login_Email = "Login_Email"
        case Login_Password = "Login_Password"
        case Login_Register = "Login_Register"
        case Login_Login = "Login_Login"
        case Login_Or = "Login_Or"
    }
    
    public enum Map: String, LocalizableDelegate {
        case Map_Search = "Map_Search"
    }
    
    public enum Go: String, LocalizableDelegate {
        case Go_Head_Start = "Go_Head_Start"
        case Go_Current_Start = "Go_Current_Start"
        case Go_Target_Start = "Go_Target_Start"
        case Go_Head_End = "Go_Head_End"
        case Go_Position_End = "Go_Position_End"
    }
    
    
    public enum ForYou: String, LocalizableDelegate {
        case ForYou_Head_Favorite = "ForYou_Head_Favorite"
        case ForYou_Head_Recently = "ForYou_Head_Recently"
        case ForYou_Head_Information = "ForYou_Head_Information"
    }
    
    public enum AddStation: String, LocalizableDelegate {
        case AddStation_Head_StationName = "AddStation_Head_StationName"
        case AddStation_Head_Description = "AddStation_Head_Description"
        case AddStation_Placeholder_Tel = "AddStation_Placeholder_Tel"
        case AddStation_Head_Is24Hr = "AddStation_Head_Is24Hr"
        case AddStation_Head_Station = "AddStation_Head_Station"
        case AddStation_Head_ServiceCharge = "AddStation_Head_ServiceCharge"
        case AddStation_Head_PriceIsHas = "AddStation_Head_PriceIsHas"
        case AddStation_Head_Provider = "AddStation_Head_Provider"
        case AddStation_Btn_ChooseProvider = "AddStation_Btn_ChooseProvider"
        case AddStation_Head_Connectors = "AddStation_Head_Connectors"
        case AddStation_Btn_AddPlug = "AddStation_Btn_AddPlug"
        case AddStation_Btn_EditLocation = "AddStation_Btn_EditLocation"
        case AddStation_Placeholder_Address = "AddStation_Placeholder_Address"
        case AddStation_Btn_Save = "AddStation_Btn_Save"
        case AddStation_Head_Service = "AddStation_Head_Service"
    }

    public enum cb: String, LocalizableDelegate {
        case Checkbox_PublicStation = "Checkbox_PublicStation"
        case Checkbox_PrivateStation = "Checkbox_PrivateStation"
        case Checkbox_Normal = "Checkbox_Normal"
        case Checkbox_OpenSoon = "Checkbox_OpenSoon"
        case Checkbox_OnMaintanance = "Checkbox_OnMaintanance"
        case Checkbox_Parking = "Checkbox_Parking"
        case Checkbox_Food = "Checkbox_Food"
        case Checkbox_Coffee = "Checkbox_Coffee"
        case Checkbox_RestRoom = "Checkbox_RestRoom"
        case Checkbox_Shopping = "Checkbox_Shopping"
        case Checkbox_RestArea = "Checkbox_RestArea"
        case Checkbox_Wifi = "Checkbox_Wifi"
        case Checkbox_Other = "Checkbox_Other"
    }
    
    public enum MapFilter: String, LocalizableDelegate {
        case MapFilter_Head_Connectors = "MapFilter_Head_Connectors"
        case MapFilter_Head_Providers = "MapFilter_Head_Providers"
        case MapFilter_Head_All = "MapFilter_Head_All"
        case MapFilter_Head_Status = "MapFilter_Head_Status"
    }
    
    public enum StationDetail: String, LocalizableDelegate {
        case StationDetail_Unit_km = "StationDetail_Unit_km"
        case StationDetail_Unit_Min = "StationDetail_Unit_Min"
        case StationDetail_Unit_Hr = "StationDetail_Unit_Hr"
        case StationDetail_Btn_Direction = "StationDetail_Btn_Direction"
        case StationDetail_Btn_Favorite = "StationDetail_Btn_Favorite"
        case StationDetail_Btn_Share = "StationDetail_Btn_Share"
        case StationDetail_Head_Detail = "StationDetail_Head_Detail"
        case StationDetail_Head_PriceService = "StationDetail_Head_PriceService"
        case StationDetail_Btn_Edit = "StationDetail_Btn_Edit"
        case StationDetail_Head_Connectors = "StationDetail_Head_Connectors"
        case StationDetail_Btn_Review = "StationDetail_Btn_Review"
        case StationDetail_Head_Service = "StationDetail_Head_Service"
        case StationDetail_Head_ReviewFromUser = "StationDetail_Head_ReviewFromUser"
    }
    
    public enum AddReview: String, LocalizableDelegate {
        case AddReview_Btn_ChargedOK = "AddReview_Btn_ChargedOK"
        case AddReview_Btn_CouldNotCharge = "AddReview_Btn_CouldNotCharge"
        case AddReview_Btn_LeaveComment = "AddReview_Btn_LeaveComment"
        case AddReview_Head_Comment = "AddReview_Head_Comment"
        case AddReview_Head_Connectors = "AddReview_Head_Connectors"
        case AddReview_Btn_ChooseConnectors = "AddReview_Btn_ChooseConnectors"
        case AddReview_Head_Power = "AddReview_Head_Power"
        case AddReview_Head_Problem = "AddReview_Head_Problem"
        case AddReview_Btn_Review = "AddReview_Btn_Review"
    }
    
    public enum Problem: String, LocalizableDelegate {
        case Problem_Value_InUse = "Problem_Value_InUse"
        case Problem_Value_CouldNotActivate = "Problem_Value_CouldNotActivate"
        case Problem_Value_BlockByCar = "Problem_Value_BlockByCar"
        case Problem_Value_OutOfOrder = "Problem_Value_OutOfOrder"
        case Problem_Value_StationClose = "Problem_Value_StationClose"
    }
    
    public enum NavigationTitle: String, LocalizableDelegate {
        case NavigationTitle_Go = "NavigationTitle_Go"
        case NavigationTitle_ForYou = "NavigationTitle_ForYou"
        case NavigationTitle_AddStation = "NavigationTitle_AddStation"
        case NavigationTitle_Filter = "NavigationTitle_Filter"
        case NavigationTitle_Review = "NavigationTitle_Review"
        case NavigationTitle_About = "NavigationTitle_About"
        case NavigationTitle_Favorite = "NavigationTitle_Favorite"
        case NavigationTitle_TopReview = "NavigationTitle_TopReview"
        case NavigationTitle_EditProfile = "NavigationTitle_EditProfile"
        case NavigationTitle_EditStation = "NavigationTitle_EditStation"
        
        case NavigationTitle_GalleryPhoto = "NavigationTitle_GalleryPhoto"
        case NavigationTitle_Profile = "NavigationTitle_Profile"
        case NavigationTitle_ChoosePlugType = "NavigationTitle_ChoosePlugType"
        case NavigationTitle_InformationDetail = "NavigationTitle_InformationDetail"
        case NavigationTitle_SelectCurrentLocation = "NavigationTitle_SelectCurrentLocation"
    }
}
