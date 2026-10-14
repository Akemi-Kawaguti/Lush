//
//  BodyCompatibility.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

// MARK: - Extensões de Regras para BodyShape
extension BodyShape {
    var styleGoal: String {
        switch self {
        case .hourglass: "marcar a cintura e acompanhar as curvas"
        case .triangle: "trazer destaque para a parte de cima e suavizar o quadril"
        case .invertedTriangle: "suavizar os ombros e trazer volume para a parte de baixo"
        case .rectangle: "criar curvas e marcar a cintura"
        case .oval: "alongar a silhueta com caimento fluido, sem apertar a região da cintura"
        }
    }
    
    func rules(for position: GarmentPosition) -> (high: Set<String>, low: Set<String>) {
        switch (self, position) {
        case (.hourglass, .top):
            return (["fitted", "baby_look", "wrap", "slim", "tie", "cropped", "high_cut"],
                    ["oversized", "boxy", "drop_shoulder"])
        case (.hourglass, .bottom):
            return (["skinny", "slim", "pencil", "a_line", "flare", "boot_cut", "mermaid", "wrap", "fitted", "tailored", "godet"],
                    ["baggy", "boyfriend", "cargo", "jogger", "bubble"])
        case (.hourglass, .onePiece):
            return (["bodycon", "wrap", "a_line", "mermaid", "fitted", "godet"],
                    ["trapeze", "dungarees"])
            
        case (.triangle, .top):
            return (["off_shoulder", "boxy", "strapless", "tube", "one_shoulder", "drop_shoulder"],
                    ["peplum", "longline", "halter", "raglan"])
        case (.triangle, .bottom):
            return (["a_line", "boot_cut", "wide_leg", "flare", "straight", "godet", "tailored", "wrap"],
                    ["skinny", "pencil", "biker", "mermaid", "bubble", "cargo", "hot_pants"])
        case (.triangle, .onePiece):
            return (["a_line", "empire", "wrap", "godet", "pantalona"],
                    ["bodycon", "mermaid", "fitted"])
            
        case (.invertedTriangle, .top):
            return (["wrap", "halter", "one_shoulder", "asymmetric", "raglan", "peplum"],
                    ["off_shoulder", "boxy", "strapless", "tube"])
        case (.invertedTriangle, .bottom):
            return (["wide_leg", "flare", "boot_cut", "a_line", "godet", "pleated", "bubble", "cargo", "culotte", "pantacourt", "baggy", "mom"],
                    ["skinny", "pencil", "biker", "fitted", "capri"])
        case (.invertedTriangle, .onePiece):
            return (["a_line", "godet", "wrap", "pantalona"],
                    ["bodycon", "fitted"])
            
        case (.rectangle, .top):
            return (["peplum", "wrap", "off_shoulder", "cropped", "tie", "ultra_cropped"],
                    ["boxy", "longline"])
        case (.rectangle, .bottom):
            return (["a_line", "godet", "pleated", "flare", "wide_leg", "mermaid", "bubble", "wrap", "tailored"],
                    ["boyfriend", "baggy", "jogger"])
        case (.rectangle, .onePiece):
            return (["wrap", "a_line", "godet", "mermaid"],
                    ["straight", "trapeze", "dungarees"])
            
        case (.oval, .top):
            return (["flowy", "longline", "wrap", "asymmetric", "one_shoulder"],
                    ["fitted", "baby_look", "cropped", "ultra_cropped", "tube", "tie", "peplum", "high_cut", "slim", "strapless"])
        case (.oval, .bottom):
            return (["straight", "boot_cut", "wide_leg", "tailored", "flare", "a_line"],
                    ["bubble", "cargo", "mermaid"])
        case (.oval, .onePiece):
            return (["empire", "a_line", "trapeze", "wrap", "straight", "pantalona"],
                    ["bodycon", "mermaid", "fitted"])
        }
    }
}
