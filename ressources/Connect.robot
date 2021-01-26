*** Settings ***
Library     SeleniumLibrary    
Resource    BrowserLauncher.robot




*** Keywords ***
Connect
    # vURL contient l'adresse URL de la page web
    # vBrowser contient l'identifiant du navigateur cible
    # vUsername contient le login
    # vPassword contient le mot de passe
    # vTitle contient le titre de la page de login 
    [Arguments]    ${vURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${vTitle}  ${TIMEOUT}  ${language}
    # Définir la valeur de timeout pour le cas de test
    Set Selenium Timeout    ${TIMEOUT}
    # Ouvrir le navigateur en précisant l'URL et le navigateur
    BrowserLauncher.OpenBrowserInLanguage    ${vURL}  ${language}  ${vBrowser}
    # Maximiser la fenêtre du navigateur
    Maximize Browser Window
    # Vérification du titre de la page
    Title Should Be    ${vTitle}
    # Saisie du login
    Input Text    id=page_x002e_components_x002e_slingshot-login_x0023_default-username    ${vUsername}
    # Saisie du mot de passe
    Input Text    id=page_x002e_components_x002e_slingshot-login_x0023_default-password    ${vPassword}
    # Click sur le bouton Connexion
    Click Button    id=page_x002e_components_x002e_slingshot-login_x0023_default-submit-button
    # S'assurer que la page est chargéé
    Wait Until Element Is Visible    xpath://*[@id="HEADER_TITLE"]/span
    # S'assurer que l'utilisateur est connecté et que le tableau de bord est affiché
    Element Should Contain     xpath://*[@id="HEADER_TITLE"]/span    Tableau de bord de
	
		
		
		
		