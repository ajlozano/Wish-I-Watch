//
//  SettingsViewModel.swift
//  Wish-I-Watch
//
//  Created by Toni Lozano Fernández on 28/5/23.
//

import UIKit

final class SettingsViewModel {
    func makeHyperLink(_ contact: Contact) {
        if let url = URL(string: contact.path) {
            UIApplication.shared.open(url)
        }
    }
}
