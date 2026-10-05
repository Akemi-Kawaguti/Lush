//
//  AppFlow.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//


//  Ação de "terminar a análise", disponível para todas as telas do fluxo.
//  Quem abre o fluxo decide o que acontece no final:
//  - primeira vez (RootView): marca a análise como feita e mostra o app
//  - "Refazer análise" (MyAreaView): fecha o fluxo e volta para a Minha área

import SwiftUI

extension EnvironmentValues {
    @Entry var finishAnalysis: () -> Void = {}
}
