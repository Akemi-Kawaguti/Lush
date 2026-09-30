//
//  TermsViewModel.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
//
import Foundation
import Observation

@Observable
final class TermsViewModel {

    private(set) var hasReachedEnd = false

    var hasAcceptedTerms = false

    var canContinue: Bool {
        hasReachedEnd && hasAcceptedTerms
    }

    func reachedEndOfTerms() {
        hasReachedEnd = true
    }
}
