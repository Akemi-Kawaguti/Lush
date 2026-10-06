//
//  PaletteDescription.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 06/10/26.
//

import Foundation

struct PaletteDetails {
    let description: String
    let temperature: String
    let temperatureDesc: String
    let brightness: String
    let brightnessDesc: String
    let saturation: String
    let saturationDesc: String
    let contrast: String
    let contrastDesc: String
}

struct PaletteDescriptionProvider {
    static func details(for seasonName: String) -> PaletteDetails {
        // Tenta encontrar a estação correspondente pelo nome em português
        let season = PaleteSeason.allCases.first { $0.rawValue == seasonName } ?? .autumnDeep
        
        switch season {
        // MARK: - Primavera
        case .springClear:
            return PaletteDetails(
                description: "A paleta Primavera Clara é fresca e luminosa, com cores claras e vivas que refletem leveza.",
                temperature: "Quente", temperatureDesc: "Tons quentes e luminosos harmonizam melhor com você.",
                brightness: "Alta", brightnessDesc: "Cores claras e iluminadas destacam seus traços.",
                saturation: "Alta", saturationDesc: "Tons vibrantes e vivos trazem vivacidade.",
                contrast: "Médio-Alto", contrastDesc: "Combinações com contraste moderado funcionam muito bem."
            )
        case .springWarn:
            return PaletteDetails(
                description: "A paleta Primavera Quente possui cores puramente quentes e douradas, sem nenhuma presença de fundo frio.",
                temperature: "Quente", temperatureDesc: "Tons terrosos dourados e quentes harmonizam perfeitamente.",
                brightness: "Média-Alta", brightnessDesc: "Cores com boa luminosidade equilibram sua aparência.",
                saturation: "Média-Alta", saturationDesc: "Tons ricos e aquecidos valorizam sua beleza.",
                contrast: "Médio", contrastDesc: "Harmonias equilibradas realçam seus traços naturais."
            )
        case .springLight:
            return PaletteDetails(
                description: "A paleta Primavera Brilhante (ou viva) destaca-se por cores intensas, alegres e de alto brilho.",
                temperature: "Quente", temperatureDesc: "Tons quentes e vibrantes trazem harmonia.",
                brightness: "Alta", brightnessDesc: "Cores luminosas e claras abrem o visual.",
                saturation: "Muito Alta", saturationDesc: "Tons saturados e marcantes realçam sua energia.",
                contrast: "Alto", contrastDesc: "Contrastes marcantes criam um visual impactante."
            )
            
        // MARK: - Verão
        case .summerSoft:
            return PaletteDetails(
                description: "A paleta Verão Suave é caracterizada por tons acinzentados, calmos, suaves e de baixa saturação.",
                temperature: "Frio", temperatureDesc: "Tons frios e suaves equilibram sua beleza natural.",
                brightness: "Média", brightnessDesc: "Luminosidade equilibrada, nem muito clara nem escura.",
                saturation: "Baixa", saturationDesc: "Tons opacos, acinzentados e suaves valorizam você.",
                contrast: "Baixo", contrastDesc: "Combinações de cores próximas criam harmonia."
            )
        case .summerCool:
            return PaletteDetails(
                description: "A paleta Verão Frio possui subtom predominantemente frio, com cores elegantes e suavemente abafadas.",
                temperature: "Frio", temperatureDesc: "Tons frios e limpos trazem frescor à aparência.",
                brightness: "Média", brightnessDesc: "Intensidade luminosa intermediária.",
                saturation: "Média-Baixa", saturationDesc: "Cores discretas, porém com presença.",
                contrast: "Médio-Baixo", contrastDesc: "Transições suaves entre as cores funcionam melhor."
            )
        case .summerLight:
            return PaletteDetails(
                description: "A paleta Verão Brilhante/Claro une frescor frio com uma leveza delicada e diáfana.",
                temperature: "Frio", temperatureDesc: "Tons frios e delicados suavizam os traços.",
                brightness: "Alta", brightnessDesc: "Cores claras iluminam e suavizam o rosto.",
                saturation: "Média", saturationDesc: "Tons nem muito apagados nem muito vibrantes.",
                contrast: "Baixo", contrastDesc: "Harmonias leves com pouca variação de tom."
            )
            
        // MARK: - Outono
        case .autumnSoft:
            return PaletteDetails(
                description: "A paleta Outono Suave transita entre o quente e o neutro, trazendo tons terrosos opacos e suaves.",
                temperature: "Quente", temperatureDesc: "Tons quentes e suaves harmonizam com seu subtom.",
                brightness: "Média", brightnessDesc: "Luminosidade moderada e aconchegante.",
                saturation: "Baixa", saturationDesc: "Cores opacas e fechadas trazem equilíbrio.",
                contrast: "Baixo", contrastDesc: "Combinações tom sobre tom ficam harmoniosas."
            )
        case .autumnWarn:
            return PaletteDetails(
                description: "A paleta Outono Quente traz o verdadeiro espírito outonal: cores ricas, terrosas e acolhedoras.",
                temperature: "Quente", temperatureDesc: "Tons quentes e profundos realçam sua essência.",
                brightness: "Média", brightnessDesc: "Cores de intensidade moderada.",
                saturation: "Média", saturationDesc: "Tons ricos, porém sem excesso de brilho artificial.",
                contrast: "Médio", contrastDesc: "Equilíbrio entre cores quentes e fechadas."
            )
        case .autumnDeep:
            return PaletteDetails(
                description: "A paleta Outono Profundo é composta por cores quentes, profundas e intensas, que trazem harmonia e equilíbrio para a sua aparência natural.",
                temperature: "Quente", temperatureDesc: "Tons quentes e terrosos harmonizam melhor com você.",
                brightness: "Média", brightnessDesc: "Cores de intensidade média equilibram seus traços.",
                saturation: "Suave", saturationDesc: "Tons mais suaves e menos vibrantes te valorizam.",
                contrast: "Baixo", contrastDesc: "Combinações de cores próximas ficam mais harmônicas."
            )
            
        // MARK: - Inverno
        case .winterClear:
            return PaletteDetails(
                description: "A paleta Inverno Brilhante destaca-se por cores frias, intensas, limpas e de alto contraste.",
                temperature: "Frio", temperatureDesc: "Tons frios e marcantes criam contraste.",
                brightness: "Alta", brightnessDesc: "Cores luminosas e vibrantes.",
                saturation: "Muito Alta", saturationDesc: "Tons extremamente vivos e puros.",
                contrast: "Alto", contrastDesc: "Combinações marcantes e contrastantes."
            )
        case .winterCool:
            return PaletteDetails(
                description: "A paleta Inverno Frio é a mais fria de todas, com cores intensas e sofisticadas.",
                temperature: "Frio", temperatureDesc: "Subtom frios evidentes valorizam sua pele.",
                brightness: "Média-Baixa", brightnessDesc: "Cores com boa profundidade.",
                saturation: "Alta", saturationDesc: "Tons limpos e marcantes.",
                contrast: "Médio-Alto", contrastDesc: "Contraste perceptível entre as peças."
            )
        case .winterDeep:
            return PaletteDetails(
                description: "A paleta Inverno Profundo combina o frio com alta profundidade, trazendo cores escuras e marcantes.",
                temperature: "Frio", temperatureDesc: "Tons frios e profundos dão sustentação ao visual.",
                brightness: "Baixa", brightnessDesc: "Cores escuras e densas.",
                saturation: "Alta", saturationDesc: "Tons intensos e profundos.",
                contrast: "Alto", contrastDesc: "Contraste marcante entre claro e escuro."
            )
        }
    }
}
