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
    }

}
