//
//  SessionManager.swift
//  KUTeach
//
//  Created by Zeynep Aydın on 1/23/24.
//
import Foundation
class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUserType: UserType?
}
