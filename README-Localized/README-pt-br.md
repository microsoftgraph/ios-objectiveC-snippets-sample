# <a name="microsoft-graph-ios-objective-c-snippets-sample"></a>Exemplo de Trechos de Código do iOS Objective C do Microsoft Graph

**Sumário**

* [Introdução](#introduction)
* [Pré-requisitos](#prerequisites)
* [Registrar e configurar o aplicativo](#register)
* [Habilitar o compartilhamento de chaves](#keychain)
* [Compilar e depurar](#build)
* [Executar o exemplo](#run)
* [Como o exemplo afeta os dados do locatário](#how-the-sample-affects-your-tenant-data)
* [Perguntas e comentários](#questions)
* [Recursos adicionais](#additional-resources)

<a name="introduction"></a>
##<a name="introduction"></a>Introdução

Este exemplo contém um repositório de trechos de código que mostram como usar o SDK do Microsoft Graph SDK enviar emails, gerenciar grupos e realizar outras atividades com os dados do Office 365. O exemplo usa o [SDK do Microsoft Graph para iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) para trabalhar com dados retornados pelo Microsoft Graph.

Este exemplo mostra como acessar vários recursos, incluindo o Microsoft Azure Active Directory (AD) e APIs do Office 365, fazendo solicitações HTTP para a API do Microsoft Graph em um aplicativo iOS. 

Além disso, o exemplo usa [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) para autenticação. Para realizar solicitações de autenticação, é necessário fornecer um **MSAuthenticationProvider** para autenticar solicitações HTTPS com um token de portador OAuth 2.0 apropriado. Usaremos essa estrutura para uma implementação de exemplo de MSAuthenticationProvider que pode ser usada para acelerar seu projeto.

 > **Observação** O adaptador **msgraph-sdk-ios-nxoauth2-adapter** é uma implementação OAuth para autenticação de exemplo neste aplicativo e serve para demonstrações.

Esses trechos são simples e autocontidos e você pode copiá-los e colá-los em seu próprio código, sempre que apropriado, ou usá-los como um recurso para aprender a usar o SDK do Microsoft Graph para iOS. Para obter uma lista de todos os trechos de código brutos usados neste exemplo para referência, consulte [Lista de operações de exemplo](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/wiki/Sample-Operations-List) na wiki.

**Observação:** Se possível, use este exemplo com uma conta "não comercial" ou de teste. O exemplo nem sempre limpa os objetos criados em sua caixa de correio e calendário. Neste momento, você terá que remover manualmente os exemplos de correios e eventos do calendário. Observe também que os trechos de código que recebem e enviam mensagens e que recebem, criam, atualizam e excluem eventos não funcionarão com todas as contas pessoais. Essas operações funcionarão quando essas contas forem atualizadas para funcionar com o ponto de extremidade do Microsoft Azure AD v2.0.

 

<a name="prerequisites"></a>
## <a name="prerequisites"></a>Pré-requisitos ##

Este exemplo requer o seguinte:  
* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple
* Instalação do [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como um gerente de dependências.
* Uma conta de email comercial ou pessoal da Microsoft como o Office 365, ou outlook.com, hotmail.com, etc. Inscreva-se em uma [Assinatura do Office 365 para Desenvolvedor](https://aka.ms/devprogramsignup) que inclua os recursos necessários para começar a criar aplicativos do Office 365.
* Uma ID de cliente do aplicativo registrado no [Portal de Registro de Aplicativos do Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Conforme mencionado acima, para realizar solicitações de autenticação, um **MSAuthenticationProvider** deve ser fornecido para autenticar solicitações HTTPS com um token de portador OAuth 2.0 apropriado. 


      
<a name="register"></a>
##<a name="register-and-configure-the-app"></a>Registrar e configurar o aplicativo

1. Entre no [Portal de Registro do Aplicativo](https://apps.dev.microsoft.com/) usando sua conta pessoal ou sua conta comercial ou escolar.  
2. Selecione **Adicionar um aplicativo**.  
3. Insira um nome para o aplicativo e selecione **Criar aplicativo**. A página de registro é exibida, listando as propriedades do seu aplicativo.  
4. Em **Plataformas**, selecione **Adicionar plataforma**.  
5. Escolha **Aplicativo móvel**.  
6. Copie a ID de Cliente (ID de Aplicativo) para usar posteriormente. Você precisará inserir esse valor no exemplo de aplicativo. Essa ID de aplicativo é o identificador exclusivo do aplicativo.   
7. Selecione **Salvar**.  

<a name="keychain"></a>
## <a name="enable-keychain-sharing"></a>Habilitar o compartilhamento de chaves
 
Para o Xcode 8, você deve adicionar o grupo de chaves para que o aplicativo não falhe ao acessar a chave. Para adicionar o grupo de chaves:
 
1. Escolha o projeto, no painel do gerente de projetos do Xcode. (⌘ + 1).
 
2. Escolha **iOS-objectivec-snippets-sample**.
 
3. Na guia Recursos, habilite o **Compartilhamento de chaves**.
 
4. Adicione **com.microsoft.iOS-objectivec-snippets-sample** ao grupo de chaves.

<a name="build"></a>
## <a name="build-and-debug"></a>Compilar e depurar ##

1. Clonar este repositório
2. Use o CocoaPods para importar as dependências de autenticação e o SDK do Microsoft Graph:

        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Este aplicativo de exemplo já contém um podfile que colocará os pods no projeto. Simplesmente navegue até o projeto do **Terminal** e execute:

        pod install

   Para saber mais, confira o artigo **Usar o CocoaPods** em [Recursos Adicionais](#AdditionalResources)

3. Abrir **O365-iOS-Microsoft-Graph-SDK.xcworkspace**
4. Abra **AuthenticationConstants.m**. Observe que você pode adicionar o valor de **ClientID** do processo de registro, na parte superior do arquivo.

        // You will set your application's clientId
        NSString * const kClientId    = @"ENTER_YOUR_CLIENT_ID";

    > Observação: Para obter mais informações sobre escopos de permissão necessários para usar esse exemplo, consulte a seção **Execução do exemplo** abaixo.
5. Execute o exemplo.

<a name="run"></a>
## <a name="running-the-sample"></a>Execução do exemplo

Quando iniciado, o aplicativo exibe uma série de caixas que representam tarefas comuns do usuário. Essas tarefas podem ser executadas com base no nível de permissão e de tipo de conta:

- Tarefas que são aplicáveis a contas comerciais ou escolares e contas pessoais, como receber e enviar emails, criar arquivos, etc.
- Tarefas que só são aplicáveis a contas comerciais ou escolares, como receber a foto da conta e o gerenciador do usuário.
- Tarefas que só são aplicáveis a contas comerciais ou escolares com permissões administrativas, como receber membros do grupo ou criar novas contas de usuário.

Escolha a tarefa que você deseja realizar e clique nela para executar. Lembre-se de que se você fizer logon com uma conta que não tem permissões aplicáveis para as tarefas selecionadas, elas falharão. Por exemplo, se você tentar executar um determinado trecho de código, como obter todos os grupos de um locatário, de uma conta que não tem privilégios de administrador na organização, a operação falhará. Ou, se você fizer logon usando uma conta pessoal, como hotmail.com, e tentar obter o gerenciador do usuário conectado, a operação falhará.

No momento, este exemplo de aplicativo está configurado com os seguintes escopos localizados em Authentication\AuthenticationConstants.m:

    "https://graph.microsoft.com/User.Read",
    "https://graph.microsoft.com/User.ReadWrite",
    "https://graph.microsoft.com/User.ReadBasic.All",
    "https://graph.microsoft.com/Mail.Send",
    "https://graph.microsoft.com/Calendars.ReadWrite",
    "https://graph.microsoft.com/Mail.ReadWrite",
    "https://graph.microsoft.com/Files.ReadWrite",

Você poderá realizar várias operações usando apenas os escopos definidos acima. No entanto, há algumas tarefas que exigem privilégios de administrador para serem executadas corretamente. Além disso, as tarefas na interface de usuário serão marcadas como precisando de acesso de administrador. Os administradores podem adicionar os seguintes escopos a Authentication.constants.m para executar esses trechos de código:

    "https://graph.microsoft.com/Directory.AccessAsUser.All",
    "https://graph.microsoft.com/User.ReadWrite.All"
    "https://graph.microsoft.com/Group.ReadWrite.All"

Além disso, para ver quais trechos de código podem ser executados em uma conta de administrador, da organização ou pessoal, consulte Snippets Library/Snippets.m. A descrição de cada trecho de código detalhará o nível de acesso.

<a name="#how-the-sample-affects-your-tenant-data"></a>
##<a name="how-the-sample-affects-your-tenant-data"></a>Como o exemplo afeta os dados do locatário
Este exemplo executa comandos que criam, leem, atualizam ou excluem dados. Durante a execução de comandos que excluem ou editam dados, o exemplo cria entidades de teste. O exemplo deixará algumas dessas entidades em seu locatário.

<a name="contributing"></a>
## <a name="contributing"></a>Colaboração ##

Se quiser contribuir para esse exemplo, confira [CONTRIBUTING.MD](/CONTRIBUTING.md).

Este projeto adotou o [Código de Conduta do Código Aberto da Microsoft](https://opensource.microsoft.com/codeofconduct/). Para saber mais, confira as [Perguntas frequentes do Código de Conduta](https://opensource.microsoft.com/codeofconduct/faq/) ou contate [opencode@microsoft.com](mailto:opencode@microsoft.com) se tiver outras dúvidas ou comentários.

<a name="questions"></a>
## <a name="questions-and-comments"></a>Perguntas e comentários

Adoraríamos receber seus comentários sobre o projeto Exemplo de Trechos de Código do iOS Objective C do Microsoft Graph. Você pode nos enviar suas perguntas e sugestões por meio da seção [Issues](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/issues) deste repositório.

Seus comentários são importantes para nós. Junte-se a nós na página [Stack Overflow](http://stackoverflow.com/questions/tagged/office365+or+microsoftgraph). Marque suas perguntas com [MicrosoftGraph].

<a name="additional-resources"></a>
## <a name="additional-resources"></a>Recursos adicionais ##

- [Visão geral do Microsoft Graph](http://graph.microsoft.io)
- [Exemplos de código para desenvolvedores do Office](http://dev.office.com/code-samples)
- [Centro de Desenvolvimento do Office](http://dev.office.com/)


## <a name="copyright"></a>Direitos autorais
Copyright © 2016 Microsoft. Todos os direitos reservados.
