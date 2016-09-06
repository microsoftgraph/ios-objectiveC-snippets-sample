# Ejemplo de fragmentos de código C del objetivo iOS de Microsoft Graph

**Tabla de contenido**

* [Introducción](#introducción)
* [Requisitos previos](#requisitos-previos)
* [Registrar y configurar la aplicación](#registrar-y-configurar-la-aplicación)
* [Compilar y depurar](#compilar-y-depurar)
* [Ejecución del ejemplo](#ejecución-del-ejemplo)
* [Repercusión de la muestra en los datos del inquilino](#repercusión-de-la-muestra-en-los-datos-del-inquilino)
* [Preguntas y comentarios](#preguntas-y-comentarios)
* [Recursos adicionales](#recursos-adicionales)

<a name="introduction"></a>
##Introducción

Este ejemplo contiene un repositorio de fragmentos de código que muestran cómo usar Microsoft Graph SDK para enviar correos electrónicos, administrar grupos y realizar otras actividades con los datos de Office 365. Usa [Microsoft Graph SDK para iOS](https://github.com/microsoftgraph/msgraph-sdk-ios) para trabajar con los datos devueltos por Microsoft Graph.

Este repositorio muestra cómo tener acceso a varios recursos, incluyendo Microsoft Azure Active Directory (AD) y las API de Office 365, realizando solicitudes HTTP a la API de Microsoft Graph en una aplicación de iOS. 

Además, el ejemplo usa [msgraph-sdk-ios-nxoauth2-adapter](https://github.com/microsoftgraph/msgraph-sdk-ios-nxoauth2-adapter) para la autenticación. Para realizar solicitudes, se debe proporcionar un **MSAuthenticationProvider** que sea capaz de autenticar solicitudes HTTPS con un token de portador OAuth 2.0 adecuado. Usaremos este marco de trabajo para una implementación del ejemplo de MSAuthenticationProvider que puede usarse para poner en marcha el proyecto.

 > **Nota** El **msgraph-sdk-ios-nxoauth2-adapter** es un ejemplo de implementación de OAuth para la autenticación en esta aplicación y está diseñado para fines ilustrativos.

Estos fragmentos de código son simples e independientes, y puede copiarlos y pegarlos en su propio código, cuando proceda o usarlos como un recurso para aprender a usar el SDK de Microsoft Graph para iOS. Para obtener una lista de todos los fragmentos de código sin procesar usada en este ejemplo como referencia, consulte la [Lista de operaciones de ejemplo](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/wiki/Sample-Operations-List) en la página wiki.

**Nota:** Si es posible, use este ejemplo con una cuenta de prueba o "no profesional". El ejemplo no siempre limpia los objetos creados en el buzón de correo y el calendario. En este momento, tendrá que eliminar manualmente los eventos del calendario y los correos del ejemplo. Tenga en cuenta que los fragmentos de código que reciben y envían mensajes, y que obtienen, crean, actualizan y eliminan eventos no funcionarán con todas las cuentas personales. Estas operaciones funcionarán finalmente cuando esas cuentas se actualicen para su funcionamiento con el modelo de autenticación v2.

 

<a name="prerequisites"></a>
## Requisitos previos ##

Este ejemplo necesita lo siguiente:  
* [Xcode](https://developer.apple.com/xcode/downloads/) de Apple
* Instalación de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como administrador de dependencias.
* Una cuenta de correo electrónico personal o profesional de Microsoft como Office 365, outlook.com, hotmail.com, etc. Puede registrarse para [una suscripción de Office 365 Developer](https://aka.ms/devprogramsignup), que incluye los recursos que necesita para comenzar a crear aplicaciones de Office 365.
* Un Id. de cliente de la aplicación registrada en el [Portal de registro de la aplicación de Microsoft Graph](https://graph.microsoft.io/en-us/app-registration)
* Como se mencionó anteriormente, para realizar solicitudes de autenticación, se debe proporcionar un **MSAuthenticationProvider** que sea capaz de autenticar solicitudes HTTPS con un token de portador OAuth 2.0 adecuado. 


      
<a name="register"></a>
##Registrar y configurar la aplicación

1. Inicie sesión en el [Portal de registro de la aplicación](https://apps.dev.microsoft.com/) mediante su cuenta personal, profesional o educativa.  
2. Seleccione **Agregar una aplicación**.  
3. Escriba un nombre para la aplicación y seleccione **Crear aplicación**. Se muestra la página de registro, indicando las propiedades de la aplicación.  
4. En **Plataformas**, seleccione **Agregar plataforma**.  
5. Seleccione **Aplicación móvil**.  
6. Copie el Id. del cliente (Id. de la aplicación) para usar más tarde. Deberá introducir este valor en la aplicación del ejemplo. El id. de la aplicación es un identificador único para su aplicación.   
7. Seleccione **Guardar**.  


<a name="build"></a>
## Compilar y depurar ##

1. Clone este repositorio.
2. Use CocoaPods para importar el SDK de Microsoft Graph y las dependencias de autenticación:

        pod 'MSGraphSDK'
        pod 'MSGraphSDK-NXOAuth2Adapter'


 Esta aplicación de ejemplo ya contiene un podfile que recibirá los pods en el proyecto. Simplemente vaya al proyecto desde **Terminal** y ejecute:

        pod install

   Para obtener más información, consulte **Usar CocoaPods** en [Recursos adicionales](#recursos-adicionales)

3. Abra **O365-iOS-Microsoft-Graph-SDK.xcworkspace**
4. Abra **AuthenticationConstants.m**. Verá que el **ClientID** del proceso de registro se puede agregar a la parte superior del archivo:

        // You will set your application's clientId
        NSString * const kClientId    = @"ENTER_YOUR_CLIENT_ID";

    > Nota: Para obtener más información sobre los ámbitos de permiso necesarios para usar este ejemplo, consulte la siguiente sección **Ejecución del ejemplo.**
5. Ejecute el ejemplo.

<a name="run"></a>
## Ejecución del ejemplo

Al iniciarse, la aplicación muestra una serie de cuadros que representan tareas de usuario comunes. Estas tareas se pueden ejecutar basándose en el tipo de cuenta y nivel de permiso:

- Tareas que son aplicables a cuentas profesionales, educativas y personales, como recibir y enviar correo electrónico, crear archivos, etc.
- Tareas que solamente son aplicables a cuentas profesionales o educativas, como obtener fotos de administrador o de la cuenta de un usuario.
- Tareas que solo son aplicables a una cuenta profesional o educativa con permisos administrativos, como obtener miembros del grupo o crear nuevas cuentas de usuario.

Seleccione la tarea que desea realizar y haga clic en ella para ejecutarla. Tenga en cuenta que, si inicia una sesión con una cuenta que no tiene permisos aplicables para las tareas que ha seleccionado, no se realizarán correctamente. Por ejemplo si intenta ejecutar un fragmento de código determinado, como obtener todos los grupos de inquilinos a partir de una cuenta que no tienen privilegios de administrador en la organización, se producirá un error en la operación. O bien, si inicia una sesión con una cuenta personal como hotmail.com e intenta obtener el administrador del usuario con la sesión iniciada, se producirá un error.

Esta aplicación de ejemplo está configurada actualmente con los siguientes ámbitos ubicados en Authentication\AuthenticationConstants.m:

    "https://graph.microsoft.com/User.Read",
    "https://graph.microsoft.com/User.ReadWrite",
    "https://graph.microsoft.com/User.ReadBasic.All",
    "https://graph.microsoft.com/Mail.Send",
    "https://graph.microsoft.com/Calendars.ReadWrite",
    "https://graph.microsoft.com/Mail.ReadWrite",
    "https://graph.microsoft.com/Files.ReadWrite",

Podrá realizar varias operaciones simplemente usando los ámbitos definidos anteriormente. Pero hay algunas tareas que requieren privilegios de administrador para poder ejecutarse correctamente, y se marcarán las tareas en la interfaz de usuario indicando que requieren acceso de administrador. Los administradores pueden agregar los siguientes ámbitos a Authentication.constants.m para ejecutar estos fragmentos de código:

    "https://graph.microsoft.com/Directory.AccessAsUser.All",
    "https://graph.microsoft.com/User.ReadWrite.All"
    "https://graph.microsoft.com/Group.ReadWrite.All"

Además, para ver qué fragmentos de código se pueden ejecutar con una cuenta de administrador, organizador o cuenta personal, consulte Snippets Library/Snippets.m. La descripción de cada fragmento detallará el nivel de acceso.

<a name="#how-the-sample-affects-your-tenant-data"></a>
##Repercusión de la muestra en los datos del inquilino
Este ejemplo ejecuta comandos que crean, leen, actualizan o eliminan datos. Cuando ejecuta comandos que eliminan o modifican datos, el ejemplo crea entidades de prueba. El ejemplo dejará atrás algunas de estas entidades en su inquilino.

<a name="contributing"></a>
## Colaboradores ##

Si le gustaría contribuir a este ejemplo, consulte [CONTRIBUTING.MD](/CONTRIBUTING.md).

Este proyecto ha adoptado el [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) (Código de conducta de código abierto de Microsoft). Para obtener más información, consulte las [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) (Preguntas más frecuentes del código de conducta) o póngase en contacto con [opencode@microsoft.com](mailto:opencode@microsoft.com) con otras preguntas o comentarios.

<a name="questions"></a>
## Preguntas y comentarios

Nos encantaría recibir sus comentarios acerca del proyecto del ejemplo de fragmentos de código Objective C para iOS de Microsoft Graph. Puede enviarnos sus preguntas y sugerencias a través de la sección [Problemas](https://github.com/microsoftgraph/iOS-objectiveC-snippets-sample/issues) de este repositorio.

Sus comentarios son importantes para nosotros. Conecte con nosotros en [Desbordamiento de pila](http://stackoverflow.com/questions/tagged/office365+or+microsoftgraph). Etiquete sus preguntas con [MicrosoftGraph].

<a name="additional-resources"></a>
## Recursos adicionales ##

- [Información general de Microsoft Graph](http://graph.microsoft.io)
- [Ejemplos de código de Office Developer](http://dev.office.com/code-samples)
- [Centro para desarrolladores de Office](http://dev.office.com/)


## Copyright
Copyright (c) 2016 Microsoft. Todos los derechos reservados.