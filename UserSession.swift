//
//  UserSession.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 19/12/25.
//

import Foundation

final class UserSession {

    static let shared = UserSession()
        private init() {}

        // Estado
        var isLoggedIn: Bool = false
        var isGuest: Bool = false

        // Datos usuario
        var uid: String?
        var username: String?
        var firstName: String?
        var lastName: String?
        var email: String?

        func clear() {
            isLoggedIn = false
            isGuest = false

            uid = nil
            username = nil
            firstName = nil
            lastName = nil
            email = nil
    }
}
