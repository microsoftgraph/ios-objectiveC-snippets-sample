# <a name="microsoft-graph-ios-objective-c-snippets-sample"></a>Beispiel für iOS-Objective C-Codeausschnitte für Microsoft Graph

**Inhaltsverzeichnis**

* [Einführung](#introduction)
* [Voraussetzungen](#prerequisites)
* [Registrieren und Konfigurieren der App](#register)
* [Aktivieren der Schlüsselbundfreigabe](#keychain)
* [Erstellen und Debuggen](#build)
* [Ausführen des Beispiels](#run)
* [Wie sich das Beispiel auf Ihre Mandantendaten auswirkt](#how-the-sample-affects-your-tenant-data)
* [Fragen und Kommentare](#questions)
* [Weitere Ressourcen](#additional-resources)

<a name="introduction"></a>
##<a name="introduction"></a>Einführung

Dieses Beispiel enthält ein Repository von Codeausschnitten, die zeigen, wie das Microsoft Graph-SDK zum Senden von E-Mails, Verwalten von Gruppen und Ausführen anderer Aktivitäten mit Office 365-Daten verwendet wird. Es verwendet das [Microsoft Graph-SDK für iOS](https://github.com/microsoftgraph/msgraph-sdk-ios), um mit Daten zu arbeiten, die von Microsoft Graph zurückgegeben werden.

In diesem Repository wird gezeigt, wie Sie auf mehrere Ressourcen, einschließlich Microsoft Azure Active Directory (AD) und die Office 365-APIs, zugreifen, indem Sie HTTP-Anforderungen an die Microsoft Graph-API in einer iOS-App ausführen. 

Außerdem verwendet das Beispiel [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) für die Authentifizierung. Um Anforderungen auszuführen, muss ein **MSAuthenticationProvider** bereitgestellt werden, der HTTPS-Anforderungen mit einem entsprechenden OAuth 2.0-Bearertoken authentifizieren kann. Wir verwenden dieses Framework für eine Beispielimplementierung von MSAuthenticationProvider, die Sie für einen Schnelleinstieg in Ihr Projekt verwenden können.

 > Hinweis **msgraph-sdk-ios-nxoauth2-adapter** ist eine Beispielimplementierung von OAuth für die Authentifizierung in dieser App und dient Demonstrationszwecken.

Diese Ausschnitte sind einfach und eigenständig, und Sie können sie ggf. in Ihren eigenen Code kopieren und einfügen oder als Ressource verwenden, um zu lernen, wie das Microsoft Graph-SDK für iOS verwendet wird. Eine Liste aller Rohcodeausschnitte, die in diesem Beispiel als Referenz verwendet werden, finden Sie im Wiki in der [Beispielvorgangsliste](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/wiki/Sample-Operations-List).

**Hinweis:** Verwenden Sie dieses Beispiel, wenn möglich, mit einem persönlichen Konto oder einem Testkonto. Das Beispiel bereinigt nicht immer die erstellten Objekte in Ihrem Postfach und Kalender. Derzeit müssen Sie Beispiel-E-Mails und -Kalenderereignisse manuell entfernen. Beachten Sie auch, dass die Codeausschnitte, die Nachrichten abrufen und senden und Ereignisse abrufen, erstellen, aktualisieren und löschen, nicht mit allen persönlichen Konten funktionieren. Diese Vorgänge funktionieren dann, wenn diese Konten so aktualisiert werden, dass sie mit dem Azure AD v2.0-Authentifizierungsendpunkt arbeiten.

 

<a name="prerequisites"></a>
## <a name="prerequisites"></a>Voraussetzungen ##

Für dieses Beispiel ist Folgendes erforderlich:  
* [Xcode](https://developer.apple.com/xcode/downloads/) von Apple
* Installation von [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) als ein Abhängigkeits-Manager.
* Ein geschäftliches oder persönliches Microsoft-E-Mail-Konto, z. B. Office 365 oder outlook.com, hotmail.com usw. Sie können sich für ein [Office 365-Entwicklerabonnement](https://aka.ms/devprogramsignup) registrieren. Dieses umfasst die Ressourcen, die Sie zum Erstellen von Office 365-Apps benötigen.
* Eine Client-ID aus der registrierten App unter dem [App-Registrierungsportal von Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Wie zuvor erwähnt, muss ein **MSAuthenticationProvider** bereitgestellt werden, der HTTPS-Anforderungen mit einem entsprechenden OAuth 2.0-Bearertoken authentifizieren kann, um Anforderungen auszuführen. 


      
<a name="register"></a>
##<a name="register-and-configure-the-app"></a>Registrieren und Konfigurieren der App

1. Melden Sie sich beim [App-Registrierungsportal](https://apps.dev.microsoft.com/) entweder mit Ihrem persönlichen oder geschäftlichen Konto oder mit Ihrem Schulkonto an.  
2. Klicken Sie auf **App hinzufügen**.  
3. Geben Sie einen Namen für die App ein, und wählen Sie **Anwendung erstellen** aus. Die Registrierungsseite wird angezeigt, und die Eigenschaften der App werden aufgeführt.  
4. Wählen Sie unter **Plattformen** die Option **Plattform hinzufügen** aus.  
5. Wählen Sie **Mobile Anwendung** aus.  
6. Kopieren Sie die Client-ID (App-ID) für die spätere Verwendung. Sie müssen diesen Wert in die Beispiel-App eingeben. Die App-ID ist ein eindeutiger Bezeichner für Ihre App.   
7. Klicken Sie auf **Speichern**.  

<a name="keychain"></a>
## <a name="enable-keychain-sharing"></a>Aktivieren der Schlüsselbundfreigabe
 
Für Xcode 8 müssen Sie die Schlüsselbundgruppe hinzufügen, sonst kann Ihre App nicht auf den Schlüsselbund zugreifen. So fügen Sie die Schlüsselbundgruppe hinzu
 
1. Wählen Sie im Projekt-Manager-Bereich in Xcode das Projekt aus. (⌘ + 1).
 
2. Wählen **iOS-Objectivec-Codeausschnitte-Sample** aus.
 
3. Aktivieren Sie auf der Registerkarte „Funktionen“ die Option **Schlüsselbundfreigabe**.
 
4. Fügen Sie der Schlüsselbundgruppe **com.microsoft.iOS-objectivec-snippets-sample** hinzu.

<a name="build"></a>
## <a name="build-and-debug"></a>Erstellen und Debuggen ##

1. Klonen dieses Repositorys
2. Verwenden Sie CocoaPods, um das Microsoft Graph-SDK und Authentifizierungsabhängigkeiten zu importieren:

        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Diese Beispiel-App enthält bereits eine POD-Datei, die die Pods in das Projekt überträgt. Navigieren Sie einfach über das **Terminal** zum Projekt, und führen Sie Folgendes aus:

        pod install

   Weitere Informationen finden Sie im Thema über das **Verwenden von CocoaPods** in [Zusätzliche Ressourcen](#AdditionalResources).

3. Öffnen Sie **O365-iOS-Microsoft-Graph-SDK.xcworkspace**.
4. Öffnen Sie **AuthenticationConstants.m**. Sie werden sehen, dass die **ClientID** aus dem Registrierungsprozess am Anfang der Datei hinzugefügt werden kann:

        // You will set your application's clientId
        NSString * const kClientId    = @"ENTER_YOUR_CLIENT_ID";

    > Hinweis: Weitere Informationen zu Berechtigungsbereichen, die für die Verwendung dieses Beispiels erforderlich sind, finden Sie im folgenden Abschnitt **Ausführen des Beispiels**.
5. Führen Sie das Beispiel aus.

<a name="run"></a>
## <a name="running-the-sample"></a>Ausführen des Beispiels

Nach dem Start wird in der App eine Reihe von Feldern angezeigt, die allgemeine Benutzeraufgaben darstellen. Diese Aufgaben können basierend auf Kontotyp und Berechtigungsstufe ausgeführt werden:

- Aufgaben, die sowohl für Geschäfts- oder Schulkonten als auch für persönliche Konten gelten, z. B. das Abrufen und Senden von E-Mails, das Erstellen von Dateien usw.
- Aufgaben, die nur für Geschäfts- oder Schulkonten gelten, z. B. das Abrufen eines Vorgesetzten eines Benutzers oder eines Kontofotos.
- Aufgaben, die nur für Geschäfts- oder Schulkonten mit Administratorberechtigungen gelten, z. B. das Abrufen von Gruppenmitgliedern oder das Erstellen neuer Benutzerkonten.

Wählen Sie die Aufgabe aus, die Sie ausführen möchten, und klicken Sie darauf, um sie auszuführen. Beachten Sie, dass die ausgewählten Aufgaben fehlschlagen, wenn Sie sich mit einem Konto anmelden, das nicht über die entsprechenden Berechtigungen für die Aufgaben verfügt. Wenn Sie beispielsweise versuchen, einen bestimmten Ausschnitt, z. B. das Abrufen aller Mandantengruppen, auf einem Konto auszuführen, das nicht über Administratorberechtigungen in der Organisation verfügt, schlägt der Vorgang fehl. Oder wenn Sie sich mit einem persönlichen Konto wie Hotmail.com anmelden und versuchen, den Vorgesetzten des angemeldeten Benutzers abzurufen, schlägt dieser Vorgang fehl.

Diese Beispiel-App ist derzeit mit den folgenden Bereichen in „Authentication\AuthenticationConstants.m“ konfiguriert.

    "https://graph.microsoft.com/User.Read",
    "https://graph.microsoft.com/User.ReadWrite",
    "https://graph.microsoft.com/User.ReadBasic.All",
    "https://graph.microsoft.com/Mail.Send",
    "https://graph.microsoft.com/Calendars.ReadWrite",
    "https://graph.microsoft.com/Mail.ReadWrite",
    "https://graph.microsoft.com/Files.ReadWrite",

Indem Sie nur die oben definierten Bereiche verwenden, können Sie mehrere Vorgänge ausführen. Es gibt allerdings einige Vorgänge, für deren ordnungsgemäßes Ausführen Administratorberechtigungen erforderlich sind, und die Aufgaben in der Benutzeroberfläche werden so gekennzeichnet, dass Administratorzugriff erforderlich ist. Administratoren können die folgenden Bereiche zu „Authentication.constants.m“ hinzufügen, um diese Ausschnitte auszuführen:

    "https://graph.microsoft.com/Directory.AccessAsUser.All",
    "https://graph.microsoft.com/User.ReadWrite.All"
    "https://graph.microsoft.com/Group.ReadWrite.All"

Informationen darüber, welche Ausschnitte für einen Administrator, eine Organisation oder persönliche Konten ausgeführt werden können, finden Sie unter „Snippets Library/Snippets.m“. In jeder Codeausschnittbeschreibung ist die Zugriffsstufe aufgeführt.

<a name="#how-the-sample-affects-your-tenant-data"></a>
##<a name="how-the-sample-affects-your-tenant-data"></a>Wie sich das Beispiel auf Ihre Mandantendaten auswirkt
In diesem Beispiel werden Befehle ausgeführt, mit denen Daten erstellt, aktualisiert oder gelöscht werden. Wenn Sie Befehle ausführen, die Daten löschen oder bearbeiten, erstellt das Beispiel Testentitäten. In dem Beispiel werden einige dieser Entitäten auf Ihrem Mandanten hinterlassen.

<a name="contributing"></a>
## <a name="contributing"></a>Mitwirkung ##

Wenn Sie einen Beitrag zu diesem Beispiel leisten möchten, finden Sie unter [CONTRIBUTING.MD](/CONTRIBUTING.md) weitere Informationen.

In diesem Projekt wurden die [Microsoft Open Source-Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/) übernommen. Weitere Informationen finden Sie unter [Häufig gestellte Fragen zu Verhaltensregeln](https://opensource.microsoft.com/codeofconduct/faq/), oder richten Sie Ihre Fragen oder Kommentare an [opencode@microsoft.com](mailto:opencode@microsoft.com).

<a name="questions"></a>
## <a name="questions-and-comments"></a>Fragen und Kommentare

Wir schätzen Ihr Feedback hinsichtlich des Microsoft Graph UWP Snippets Library-Projekts. Sie können uns Ihre Fragen und Vorschläge über den Abschnitt [Probleme](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/issues) dieses Repositorys senden.

Ihr Feedback ist uns wichtig. Nehmen Sie unter [Stack Overflow](http://stackoverflow.com/questions/tagged/office365+or+microsoftgraph) Kontakt mit uns auf. Taggen Sie Ihre Fragen mit [MicrosoftGraph].

<a name="additional-resources"></a>
## <a name="additional-resources"></a>Zusätzliche Ressourcen ##

- [Microsoft Graph-Übersicht](http://graph.microsoft.io)
- [Office-Entwicklercodebeispiele](http://dev.office.com/code-samples)
- [Office Dev Center](http://dev.office.com/)


## <a name="copyright"></a>Copyright
Copyright (c) 2016 Microsoft. Alle Rechte vorbehalten.
