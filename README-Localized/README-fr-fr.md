# <a name="microsoft-graph-ios-objective-c-snippets-sample"></a>Exemple d’extraits de code Microsoft Graph iOS Objective C

**Sommaire**

* [Introduction](#introduction)
* [Conditions préalables](#prerequisites)
* [Enregistrement et configuration de l’application](#register)
* [Activation du partage du trousseau](#keychain)
* [Création et débogage](#build)
* [Exécution de l’exemple](#run)
* [Impact de l’exemple sur vos données client](#how-the-sample-affects-your-tenant-data)
* [Questions et commentaires](#questions)
* [Ressources supplémentaires](#additional-resources)

<a name="introduction"></a>
##<a name="introduction"></a>Introduction

Cet exemple contient un référentiel des extraits de code qui illustrent l’utilisation du kit de développement Microsoft Graph pour envoyer des messages électroniques, gérer les groupes et effectuer d’autres activités avec les données d’Office 365. Il utilise le [kit de développement logiciel Microsoft Graph pour iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) pour exploiter les données renvoyées par Microsoft Graph.

Ce référentiel vous montre comment accéder à plusieurs ressources, notamment Microsoft Azure Active Directory (AD) et les API d’Office 365, en envoyant des requêtes HTTP à l’API Microsoft Graph dans une application iOS. 

En outre, l’exemple utilise [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) pour l’authentification. Pour effectuer des requêtes, vous devez fournir un élément **MSAuthenticationProvider** capable d’authentifier les requêtes HTTPS avec un jeton de support OAuth 2.0 approprié. Nous allons utiliser cette infrastructure pour un exemple d’implémentation de MSAuthenticationProvider qui peut être utilisé pour commencer rapidement votre projet.

 > **Remarque** **msgraph-sdk-ios-nxoauth2-adapter** est un exemple d’implémentation OAuth pour l’authentification dans cette application. Il est fourni à titre de démonstration.

Ces extraits sont simples et autonomes, et vous pouvez les copier-coller dans votre propre code, le cas échéant, ou les utiliser comme ressource d’apprentissage sur l’utilisation du kit de développement logiciel Microsoft Graph pour iOS. Pour obtenir la liste de tous les extraits bruts utilisés dans cet exemple à titre de référence, voir [Liste des exemples d’opérations](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/wiki/Sample-Operations-List) dans le site wiki.

**Remarque :** Si possible, utilisez cet exemple avec un compte de test ou « non professionnel ». L’exemple ne nettoie pas toujours les objets créés dans votre boîte aux lettres et votre calendrier. À ce stade, vous devrez supprimer manuellement les exemples de messages électroniques et les événements de calendrier. Notez également que les extraits de code qui obtiennent et envoient des messages et qui obtiennent, créent, mettent à jour et suppriment des événements qui ne fonctionnent pas avec tous les comptes personnels. Ces opérations fonctionneront finalement lorsque ces comptes seront mis à jour pour fonctionner avec le point de terminaison Azure AD v2.0.

 

<a name="prerequisites"></a>
## <a name="prerequisites"></a>Conditions préalables ##

Cet exemple nécessite les éléments suivants :  
* [Xcode](https://developer.apple.com/xcode/downloads/) d’Apple
* Installation de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) comme gestionnaire de dépendances.
* Un compte de messagerie professionnel ou personnel Microsoft comme Office 365 ou outlook.com, hotmail.com, etc. Vous pouvez vous inscrire à [Office 365 Developer](https://aka.ms/devprogramsignup) pour accéder aux ressources dont vous avez besoin afin de commencer à créer des applications Office 365.
* Un ID client de l’application enregistrée auprès du [portail d’inscription de l’application Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Comme indiqué ci-dessus, pour effectuer des requêtes d’authentification, vous devez fournir un **MSAuthenticationProvider** capable d’authentifier les requêtes HTTPS avec un jeton de support OAuth 2.0 approprié. 


      
<a name="register"></a>
##<a name="register-and-configure-the-app"></a>Enregistrement et configuration de l’application

1. Connectez-vous au [portail d’inscription des applications](https://apps.dev.microsoft.com/) en utilisant votre compte personnel, professionnel ou scolaire.  
2. Sélectionnez **Ajouter une application**.  
3. Entrez un nom pour l’application, puis sélectionnez **Créer une application**. La page d’inscription s’affiche, répertoriant les propriétés de votre application.  
4. Sous **Plateformes**, sélectionnez **Ajouter une plateforme**.  
5. Sélectionnez **Application mobile**.  
6. Copiez l’ID client (ID d’application) à des fins d’utilisation ultérieure. Vous devrez saisir cette valeur dans l’exemple d’application. L’ID d’application est un identificateur unique pour votre application.   
7. Cliquez sur **Enregistrer**.  

<a name="keychain"></a>
## <a name="enable-keychain-sharing"></a>Activation du partage du trousseau
 
Pour Xcode 8, vous devez ajouter le groupe de trousseau, sinon votre application ne pourra pas y accéder. Pour ajouter le groupe de trousseau :
 
1. Sélectionnez le projet dans le volet du responsable de projet dans Xcode (⌘ + 1).
 
2. Sélectionnez **iOS-objectivec-snippets-sample**.
 
3. Sous l’onglet Fonctionnalités, activez **Partage du trousseau**.
 
4. Ajoutez **com.microsoft.iOS-objectivec-snippets-sample** aux groupes de trousseau.

<a name="build"></a>
## <a name="build-and-debug"></a>Création et débogage ##

1. Cloner ce référentiel
2. Utilisez CocoaPods pour importer les dépendances d’authentification et le kit de développement logiciel Microsoft Graph :

        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Cet exemple d’application contient déjà un podfile qui recevra les pods dans le projet. Ouvrez simplement le projet à partir de **Terminal** et exécutez :

        pod install

   Pour plus d’informations, consultez **Utilisation de CocoaPods** dans [Ressources supplémentaires](#AdditionalResources).

3. Ouvrez **O365-iOS-Microsoft-Graph-SDK.xcworkspace**.
4. Ouvrez **AuthenticationConstants.m**. Vous verrez que l’**ID client** du processus d’inscription peut être ajouté à la partie supérieure du fichier :

        // You will set your application's clientId
        NSString * const kClientId    = @"ENTER_YOUR_CLIENT_ID";

    > Remarque : Pour plus d’informations sur les étendues d’autorisation requises pour utiliser cet exemple, consultez la section **Exécution de l’exemple** ci-dessous.
5. Exécutez l’exemple.

<a name="run"></a>
## <a name="running-the-sample"></a>Exécution de l’exemple

Une fois lancée, l’application affiche une série de cases représentant les tâches courantes de l’utilisateur. Ces tâches peuvent être exécutées en fonction du niveau d’autorisations et du type de compte :

- Tâches qui s’appliquent à la fois aux comptes professionnels, scolaires et personnels, telles que l’obtention et l’envoi de messages électroniques, la création de fichiers, etc.
- Tâches qui s’appliquent uniquement aux comptes professionnels ou scolaires, telles que l’obtention de la photo de compte ou du responsable d’un utilisateur.
- Tâches qui s’appliquent uniquement aux comptes professionnels ou scolaires avec des autorisations administratives appropriées, telles que l’obtention de membres du groupe ou la création de comptes d’utilisateur.

Sélectionnez la tâche que vous souhaitez effectuer et cliquez dessus pour l’exécuter. N’oubliez pas que si vous vous connectez avec un compte qui ne dispose pas des autorisations applicables pour les tâches sélectionnées, celles-ci échoueront. Par exemple si vous essayez d’exécuter un extrait spécifique, tel que l’obtention de tous les groupes du client, à partir d’un compte qui ne dispose pas de privilèges d’administrateur dans l’organigramme, l’opération échoue. Sinon, si vous vous connectez avec un compte personnel comme hotmail.com et essayez d’obtenir le responsable de l’utilisateur connecté, l’opération échoue.

Actuellement, cet exemple d’application est configuré avec les étendues suivantes situées dans Authentication\AuthenticationConstants.m :

    "https://graph.microsoft.com/User.Read",
    "https://graph.microsoft.com/User.ReadWrite",
    "https://graph.microsoft.com/User.ReadBasic.All",
    "https://graph.microsoft.com/Mail.Send",
    "https://graph.microsoft.com/Calendars.ReadWrite",
    "https://graph.microsoft.com/Mail.ReadWrite",
    "https://graph.microsoft.com/Files.ReadWrite",

Vous pourrez effectuer plusieurs opérations simplement à l’aide des étendues définies ci-dessus. Toutefois, certaines tâches qui exigent des privilèges d’administrateur pour s’exécuter correctement et les tâches dans l’interface utilisateur seront marquées comme nécessitant un accès administrateur. Les administrateurs peuvent ajouter les étendues suivantes à Authentication.constants.m pour exécuter ces extraits de code :

    "https://graph.microsoft.com/Directory.AccessAsUser.All",
    "https://graph.microsoft.com/User.ReadWrite.All"
    "https://graph.microsoft.com/Group.ReadWrite.All"

En outre, pour savoir quels extraits peuvent être exécutés sur un compte administrateur, professionnel ou personnel, consultez Snippets Library/Snippets.m. Chaque description de l’extrait de code détaille le niveau d’accès.

<a name="#how-the-sample-affects-your-tenant-data"></a>
##<a name="how-the-sample-affects-your-tenant-data"></a>Impact de l’exemple sur vos données client
Cet exemple exécute des commandes qui permettent de créer, lire, mettre à jour ou supprimer des données. Lorsque vous exécutez des commandes qui suppriment ou modifient des données, l’exemple crée des entités de test. L’exemple épargne certaines de ces entités sur votre client.

<a name="contributing"></a>
## <a name="contributing"></a>Contribution ##

Si vous souhaitez contribuer à cet exemple, voir [CONTRIBUTING.MD](/CONTRIBUTING.md).

Ce projet a adopté le [code de conduite Microsoft Open Source](https://opensource.microsoft.com/codeofconduct/). Pour plus d’informations, reportez-vous à la [FAQ relative au code de conduite](https://opensource.microsoft.com/codeofconduct/faq/) ou contactez [opencode@microsoft.com](mailto:opencode@microsoft.com) pour toute question ou tout commentaire.

<a name="questions"></a>
## <a name="questions-and-comments"></a>Questions et commentaires

Nous serions ravis de connaître votre opinion sur l’exemple de projet d’extraits de code Microsoft Graph iOS Objective C. Vous pouvez nous faire part de vos questions et suggestions dans la rubrique [Problèmes](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/issues) de ce référentiel.

Votre avis compte beaucoup pour nous. Communiquez avec nous sur [Stack Overflow](http://stackoverflow.com/questions/tagged/office365+or+microsoftgraph). Posez vos questions avec la balise [MicrosoftGraph].

<a name="additional-resources"></a>
## <a name="additional-resources"></a>Ressources supplémentaires ##

- [Présentation de Microsoft Graph](http://graph.microsoft.io)
- [Exemples de code du développeur Office](http://dev.office.com/code-samples)
- [Centre de développement Office](http://dev.office.com/)


## <a name="copyright"></a>Copyright
Copyright (c) 2016 Microsoft. Tous droits réservés.
