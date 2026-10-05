//
//  PrivacyPolicy.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import Foundation

enum PrivacyPolicy {

    static let lastUpdated = "Última atualização: 5 de outubro de 2026"

    // E-mail de contato (usado nos dois textos e transformado em link no LegalText)
    static let contactEmail = "lushestilopessoal@gmail.com"

    // Texto completo, numerado a partir de "1."
    static let content = sections(prefix: "")

    // Monta as seções com um prefixo na numeração.
    // Ex.: prefix "14." gera "14.1. Quais dados usamos" (usado dentro dos Termos de Uso).
    static func sections(prefix: String) -> String {
        """
        Esta Política de Privacidade explica como o Lush trata as suas informações, de acordo com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 – LGPD). O Lush foi pensado para funcionar sem cadastro e sem login: as suas informações ficam guardadas no seu próprio iPhone.

        \(prefix)1. Quais dados usamos

        Para funcionar, o Lush usa as seguintes informações, sempre fornecidas por você. Para realizar a análise: uma foto do seu rosto (obrigatória), as cores de pele, cabelo e olhos selecionadas por você e, para o biotipo, uma foto do seu corpo ou as suas medidas de ombros, cintura e quadril. Para personalizar a sua área no aplicativo: seu nome e uma foto sua (opcionais). Além disso, o Lush guarda as fotos das roupas que você cadastrar, os resultados das suas análises e os looks que você favoritar.

        \(prefix)2. Para que usamos

        Usamos essas informações apenas para realizar as análises de paleta de cores e de biotipo, mostrar a compatibilidade das suas roupas com você e personalizar as sugestões de looks. Não usamos os seus dados para nenhuma outra finalidade.

        \(prefix)3. Onde os dados ficam

        Todas as informações ficam armazenadas apenas no seu aparelho. As análises das fotos são feitas no próprio iPhone, com recursos do sistema da Apple. O Lush não possui servidores próprios, não cria contas e não envia as suas fotos, medidas ou resultados para a equipe do Lush nem para terceiros. Caso você utilize o backup do iCloud, as informações do aplicativo podem fazer parte desse backup, que segue as regras de privacidade da Apple.

        \(prefix)4. Compartilhamento

        Não vendemos, não alugamos e não compartilhamos os seus dados com terceiros. O Lush não exibe anúncios e não utiliza ferramentas de rastreamento.

        \(prefix)5. Câmera e fotos

        O Lush pede acesso à câmera apenas quando você escolhe tirar uma foto dentro do aplicativo. Ao escolher uma imagem da galeria, o aplicativo acessa somente a foto que você selecionar. Você pode alterar essas permissões a qualquer momento em Ajustes do iPhone.

        \(prefix)6. Fotos do rosto e do corpo

        A foto do rosto é necessária para a análise da paleta de cores, e a foto do corpo pode ser usada na análise do biotipo (se preferir, você pode informar suas medidas no lugar dela). Essas fotos são usadas exclusivamente para identificar cores e proporções na análise de estilo. O Lush não usa essas imagens para reconhecer ou identificar pessoas. Ao enviar as fotos, você concorda com esse uso.

        \(prefix)7. Seus direitos

        De acordo com a LGPD, você pode consultar, corrigir e excluir os seus dados. No Lush, você pode alterar seu nome e sua foto em Configurações e refazer a sua análise a qualquer momento. Para excluir todas as informações, basta apagar o aplicativo do seu iPhone: como os dados ficam apenas no aparelho, eles são removidos junto com o aplicativo.

        \(prefix)8. Por quanto tempo guardamos

        As informações permanecem no seu aparelho enquanto o aplicativo estiver instalado ou até que você as altere ou apague.

        \(prefix)9. Menores de idade

        O Lush é destinado a pessoas com 18 anos ou mais. Não coletamos intencionalmente dados de menores de idade.

        \(prefix)10. Alterações nesta política

        Esta política pode ser atualizada. Quando isso acontecer, a nova versão ficará disponível no aplicativo, com a data da última atualização.

        \(prefix)11. Contato

        Em caso de dúvidas sobre esta Política de Privacidade ou sobre os seus dados, entre em contato pelo e-mail: \(contactEmail)
        """
    }
}
