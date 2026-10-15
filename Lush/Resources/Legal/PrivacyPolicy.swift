//
//  PrivacyPolicy.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import Foundation

enum PrivacyPolicy {

    static let lastUpdated = "Última atualização: 8 de outubro de 2026"

    static let contactEmail = "lushestilopessoal@gmail.com"

    static let content = sections(prefix: "")

    static func sections(prefix: String) -> String {
        """
        Esta Política de Privacidade explica como o Lush trata as suas informações, de acordo com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 – LGPD). O Lush foi pensado para funcionar sem cadastro e sem login: as suas informações ficam guardadas no seu próprio iPhone.

        \(prefix)1. Quais dados usamos

        Para funcionar, o Lush utiliza informações fornecidas por você. Para realizar as análises, são utilizadas uma foto do seu rosto (obrigatória), as cores de pele, cabelo e olhos selecionadas por você e, para a análise do biotipo, uma foto do seu corpo ou as suas medidas de ombros, cintura e quadril. Para personalizar a sua área no aplicativo, você pode informar seu nome e adicionar uma foto de perfil, ambos opcionais. As fotos das roupas cadastradas, as categorias selecionadas, os resultados das análises e os looks favoritados também são armazenados exclusivamente no seu dispositivo pessoal e não são compartilhados com terceiros.

        \(prefix)2. Para que usamos

        Usamos essas informações para realizar as análises dos tons de cores referentes à sua pele, cabelo, olhos e de biotipo, mostrar a compatibilidade das suas roupas com você e personalizar as sugestões de looks. Não usamos os seus dados para nenhuma outra finalidade.

        \(prefix)3. Onde os dados ficam

        As suas fotos, medidas, cores, resultados, roupas cadastradas e favoritos ficam armazenados no seu próprio iPhone. As análises das fotos são feitas no próprio dispositivo, com recursos do sistema da Apple. O Lush não cria contas e não envia essas informações pessoais para a equipe responsável pelo aplicativo nem para terceiros. Caso você utilize o backup do iCloud, as informações do aplicativo podem fazer parte desse backup, que segue as regras de privacidade da Apple.

        Para apresentar sugestões de looks, o Lush precisa consultar um serviço online que ajuda a encontrar referências de roupas de acordo com a sua paleta de cores e o estilo escolhido no filtro. Para isso, são enviados apenas o nome da sua paleta de cores (por exemplo, "Outono Profundo") e o estilo selecionado (por exemplo, "Trabalho"). Fotos, medidas, nome, roupas cadastradas e outros dados pessoais não são enviados nessa consulta. Como o serviço funciona pela internet, podem ser registrados dados técnicos da conexão, como o endereço IP, para fins de funcionamento e segurança.

        \(prefix)4. Compartilhamento de dados

        O Lush não vende, não aluga e não compartilha as suas informações pessoais com terceiros. O aplicativo não exibe anúncios e não utiliza ferramentas de rastreamento.

        \(prefix)5. Imagens de terceiros

        As imagens utilizadas nas sugestões de looks são fornecidas pelo Pexels (pexels.com), com crédito aos respectivos fotógrafos. Essas imagens são carregadas diretamente dos servidores do Pexels. Nesse acesso, o serviço pode receber informações técnicas da conexão, como o endereço IP. O tratamento dessas informações segue a Política de Privacidade do próprio Pexels.

        \(prefix)6. Câmera e fotos

        O Lush pede acesso à câmera apenas quando você escolhe tirar uma foto pelo aplicativo. Ao escolher uma imagem da galeria, o aplicativo acessa somente a foto que você selecionar. Você pode alterar essas permissões a qualquer momento em Ajustes do iPhone.

        \(prefix)7. Fotos do rosto e do corpo

        A foto do rosto é necessária para a análise dos tons de cores referentes à sua pele, cabelo e olhos, e a foto do corpo pode ser usada na análise do biotipo (se preferir, você pode informar suas medidas no lugar dela). Essas fotos são usadas exclusivamente para identificar cores e proporções na análise de estilo. O Lush não usa essas imagens para reconhecer ou identificar pessoas. Ao enviar as fotos, você concorda com esse uso.

        \(prefix)8. Seus direitos

        De acordo com a LGPD, você pode consultar, corrigir e excluir os seus dados. No Lush, você pode alterar seu nome e sua foto em Configurações e refazer a sua análise a qualquer momento. Para excluir todas as informações, basta apagar o aplicativo do seu iPhone: como os dados ficam apenas no aparelho, eles são removidos junto com o aplicativo.

        \(prefix)9. Por quanto tempo guardamos

        As informações permanecem no seu aparelho enquanto o aplicativo estiver instalado ou até que você as altere ou apague.

        \(prefix)10. Menores de idade

        O Lush é destinado a pessoas com 18 anos ou mais. Não recomendamos o uso por menores de idade.

        \(prefix)11. Alterações nesta política

        Esta política pode ser atualizada. Quando isso acontecer, a nova versão ficará disponível no aplicativo, com a data da última atualização.

        \(prefix)12. Contato

        Em caso de dúvidas sobre esta Política de Privacidade ou sobre os seus dados, entre em contato pelo e-mail: \(contactEmail)
        """
    }
}
