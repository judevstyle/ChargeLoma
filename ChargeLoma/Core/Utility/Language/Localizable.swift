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
    public enum Timer: String, LocalizableDelegate {
        case seconds = "TIME_UNIT_SECONDS %d IN"
        case minutes = "TIME_UNIT_MINUTES %d IN"
        case hours = "TIME_UNIT_HOURS %d IN"
        case lessThanSec = "TIME_UNIT_LESS_THAN_SECONDS IN"
        case secondsAgo = "TIME_UNIT_SECONDS %d AGO"
        case minutesAgo = "TIME_UNIT_MINUTES %d AGO"
        case hoursAgo = "TIME_UNIT_HOURS %d AGO"
        case lessThanSecAgo = "TIME_UNIT_LESS_THAN_SECONDS AGO"
        case dayAgo = "day ago"
        case daysAgo = "days ago"
        case yesterday = "Yesterday"
        case hourAgo = "hour ago"
        case hrsAgo = "hours ago"
        case justNow = "just now"
        case minuteAgo = "A minutes ago"
        case oneMinuteAgo = "one minute ago"
    }
    
    public enum Biometric: String, LocalizableDelegate {
        case bioAuthenticateFaceId = "BIOMETRIC_AUTHENTICATE_PROMPT_MESSAGE_FOR_FACEID"
        case bioAuthenticateTouchId = "BIOMETRIC_AUTHENTICATE_PROMPT_MESSAGE_FOR_TOUCHID"
    }
}
