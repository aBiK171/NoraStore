//
//  SettingsModel.swift
//  Uniqlo.uz
//
//  Created by Abboskhon Rakhimov on 14/02/26.
//


import UIKit

struct SettingsRow {
    let icon: UIImage?
    let title: String
    let subtitle: String
    let type: RowType
    
    enum RowType {
        case username
        case notifications
        case language
    }
}
