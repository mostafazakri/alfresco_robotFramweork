*** Settings ***
Library    DateTime
Library    String
Library    SeleniumLibrary     


*** Variables ***
${maxImplicitWait}  60
${buttonText}  Créer un type personnalisé
${modalText}   Créer un type personnalisé
${timeout}  3
${ATTEMPTS}  15
${LARGER_TIMEOUT}  30

*** Keywords *** 

Init Date
    ${vDateSys}=    Get Current Date    exclude_millis=yes
    ${vDate}=    Get Substring   ${vDateSys}    0    10
    ${vHeure}=    Get Substring   ${vDateSys}    11    13
    ${vMinute}=    Get Substring   ${vDateSys}    14    16
    ${vSeconde}=    Get Substring   ${vDateSys}    17    19
    ${vCompleteDate}=    catenate    ${vDate}-${vHeure}${vMinute}${vSeconde}
    [return]    ${vCompleteDate}


DragAndDropPanneaux
    [Arguments]     ${nombreDePanneaux}   ${IdPanneau}
    FOR    ${nbActual}    IN RANGE  0  ${nombreDePanneaux}  
        ###Debut DRAGnDROP
        Scroll Element Into View           //span[text()='Enregistrer']
        sleep                              1
        Click Element                      //div[@id='${IdPanneau}']/div
        Mouse Down                         //div[@id='${IdPanneau}']/div
        Mouse Over                         //div[@id='NON_PROPERTY_PALETTE']
        sleep                              1
        Mouse Over                         //div[@class='alfresco-dnd-DragAndDropTarget']
        Wait Until Page Contains Element   //div[@class='alfresco-dnd-DragAndDropTarget']/div[@data-dojo-attach-point='previewNode']  15
        ${result}    Execute Javascript    let box = document.querySelector('.alfresco-dnd-DragAndDropTarget > div:nth-child(1)'); return dims = new Array(box.offsetWidth, box.offsetHeight);
        ${x} =       Evaluate    (${result}[0] /2) * -1
        #${y} =       Evaluate    (${result}[1] /2) * -1
        Click Element At Coordinates       //div[@class='alfresco-dnd-DragAndDropTarget']/div[@data-dojo-attach-point='previewNode']  ${x}  0
        ###Fin DRAGnDROP
        Log    panneau N ${nbActual} ajouté
    END


DragAndDropProperties
    [Arguments]     ${nombreDePanneaux}   ${IdPanneau}  ${typeWrapper}
    ###Debut DRAGnDROP
    Click Element                      //div[@id='${IdPanneau}']/div
    Mouse Down                         //div[@id='${IdPanneau}']/div
    Mouse Over                         //div[@id='${IdPanneau}']/parent::div
    sleep                              1
    Mouse Over                         //div[@class='alfresco-dnd-DragAndDropTarget']
    Wait Until Page Contains Element   //div[@class='alfresco-dnd-DragAndDropTarget']/div[@data-dojo-attach-point='previewNode']  15
    Mouse Over                         //div[contains(@class,'${typeWrapper}')]
    Mouse Over                         //div[contains(@class,'${typeWrapper}')]/span[@class='dojoDndHandle']
    Mouse Up                           //div[contains(@class,'${typeWrapper}')]/span/div/div[@data-dojo-attach-point='previewNode']
    ###Fin DRAGnDROP

    
CreerTypePerso
    [Arguments]  ${modele}  ${nomTypePerso}  ${typeParent}  ${libelleAffichage}  ${description} 
    
    #aller sur la page gestion des modeles (keyword declaré en bas)
    Click Element    //a[contains(text(), 'Outils admin')]
    Click Element    //a[contains(text(), 'Gestionnaire de modèles')]
    Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${modele}')]  ${maxImplicitWait} 
    Click Element  //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][text() ='${modele}']
    
    #cliquer sur le boutton ajouter type personalisé
    Click Element  //div[@id='alfresco-console']/descendant::span[text() = '${buttonText}']
    
    #remplire les champs text
    Input Text     //div/span[text() = "${modalText}"]/parent::div/following-sibling::div/div/div/div/form/div[1]/div[2]/div/div/div[2]/input  ${nomTypePerso}    
    Input Text    //div/span[text() = "${modalText}"]/parent::div/following-sibling::div/div/div/div/form/div[3]/div[2]/div/div/div[2]/input  ${libelleAffichage} 
    Input Text    //div/span[text() = "${modalText}"]/parent::div/following-sibling::div/div/div/div/form/div/div[2]//textarea    ${description}
    
    #choisir l'option du type parent
    Wait Until Element Is Visible    //div/span[text() = "${modalText}"]/parent::div/following-sibling::div/div/div/div/form/div[2]/div[2]/div/table/tbody/tr/td[1]/div/span[@role='option']  ${maxImplicitWait}     
    Click Element    //div/span[text() = "${modalText}"]/parent::div/following-sibling::div/div/div/div/form/div[2]/div[2]/div/table/tbody/tr/td[2]
    Click Element  //div/span[text() = "${modalText}"]/parent::div/parent::div/following-sibling::div/following-sibling::div/table/tbody//descendant::td[text() = '${typeParent}']
    
    #cliquer sur ajouter
    Click Element    id=CMM_CREATE_TYPE_DIALOG_OK_label
    Wait Until Page Contains Element    //span[contains(text(), '${nomTypePerso}')]  ${maxImplicitWait}
    
supprimerTypePerso
    [Arguments]  ${modele}  ${typePerso}  
    
    #aller sur la page gestion des modeles
    goToModel    ${modele}
    
    #cliquer sur actions sur la page liste des modeles
    Click Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${modele}')]//ancestor::td[1]//following-sibling::td[3]
    
    #Desactiver le modele, si activé, afin d'etre capable de supprimer un type personalise de modele
    ${present} =    Run Keyword And Return Status    Page Should Contain Element   //div[contains(@class, 'Popup')]/div/div/div[2]/table/tbody/tr[1]/td[2][contains(text(), 'Désactiver')]
    Run Keyword If    ${present}    Click Element    //div[contains(@class, 'Popup')]/div/div/div[2]/table/tbody/tr[1]/td[2][contains(text(), 'Désactiver')]
     
    #cliquer sur la page du modele
    Click Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${modele}')]
    sleep  ${timeout}
    
    #cliquer sur actions pour afficher le dropdown
    Wait Until Page Contains Element    //div[@id='TYPES_LIST']//span[contains(text(), '${typePerso}')]/ancestor::td/following-sibling::td[4]  ${maxImplicitWait}
    Click Element    //div[@id='TYPES_LIST']//span[contains(text(), '${typePerso}')]/ancestor::td/following-sibling::td[4]/div/div/div/span[2]
    
    #recuperer l'identifiant dur dropDown dynamique
    ${idDropDown}=   Get Element Attribute  //div[@id='TYPES_LIST']//span[contains(text(), '${typePerso}')]/ancestor::td/following-sibling::td[4]/div[1]/div[1]  id
    
    #cliquer sur supprimer
    Wait Until Page Contains Element   //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[3]/td[2][text() = 'Supprimer']  ${maxImplicitWait}
    Click Element    //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[3]/td[2][text() = 'Supprimer']
    
    #confirmer la suppression
    Wait Until Page Contains Element  //div[@id='CMM_DELETE_TYPE_DIALOG']/div[2]/div[2]/span/span/span/span[contains(text(),'Supprimer')]  ${maxImplicitWait}
    Click Element    //div[@id='CMM_DELETE_TYPE_DIALOG']/div[2]/div[2]/span/span/span/span[contains(text(),'Supprimer')]
    
    #Si on a desactive le modele pour supprimer le type personalise, on le reactive
    Run Keyword If    ${present}    goToModel    ${modele}
    Run Keyword If    ${present}    Click Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${modele}')]//ancestor::td[1]//following-sibling::td[3]
    Run Keyword If    ${present}    Click Element    //div[contains(@class, 'Popup')]/div/div/div[2]/table/tbody/tr[1]/td[2][contains(text(), 'Activer')]

    
goToModel
    [Arguments]  ${modele}
    #aller sur la page gestion des modeles
    Reload Page
    Click Element                        //a[contains(text(), 'Outils admin')]
    Click Element                        //a[contains(text(), 'Gestionnaire de modèles')]
    Wait Until Page Contains Element     //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${modele}')]  ${maxImplicitWait}
    
supprimerProprieteTypePersonalise
    [Arguments]    ${vModel}    ${Type personnalise}    ${propriete}
    # Clicker sur le bouton 'Outils admin'
    Click link     //*[@id="HEADER_ADMIN_CONSOLE_text"]/a
    sleep     2
    # Clicker sur le lien "Gestionnaire de modèles"
    Click Element    //a[@title="Gestionnaire de modèles"]
    sleep   2
    # Clicker sur le lien du "Model" choisi
    Click Element    //span[text()="${vModel}"]
    sleep    2
    # Clicker sur le lien du "Types personnalisés" choisi
    Click Element   //span[text()="${Type personnalise}"]
    sleep   2
    # Clicker sur le bouton "Action" correspondant a la "Propiete choisi"
    Click Element    //span[text()="${propriete}"]/ancestor::tr//span[text()='Actions']
    # Clicker sur le "Supprimer"  
    Click Element    //div//span[text()="${propriete}"]/ancestor::body//div[@role='region']//tr[@title='Supprimer']                     
    sleep   1
    # Clicker sur le bouton"Supprimer" pour confirmer
    Click Element    //div[@class='footer']//span[text()='Supprimer']
    sleep   3
    Element Should Not Be Visible    //span[text()="${propriete}"]
    
creerModele
    [Arguments]  ${espaceNom}  ${prefix}  ${nom}  ${createur}  ${desc}
    Click Element    //a[contains(text(), 'Outils admin')]
    Click Element    //a[contains(text(), 'Gestionnaire de modèles')]
    Click Element    //div[@id='CMM_PANE_CONTAINER']//span[text()='Créer un modèle']    
    Input Text        //div[@id='CMM_CREATE_MODEL_DIALOG']//input[@name='namespace']         ${espaceNom}    
    Input Text        //div[@id='CMM_CREATE_MODEL_DIALOG']//input[@name='prefix']            ${prefix}
    Input Text        //div[@id='CMM_CREATE_MODEL_DIALOG']//input[@name='name']              ${nom}
    Input Text        //div[@id='CMM_CREATE_MODEL_DIALOG']//input[@name='author']            ${createur}
    Input Text        //div[@id='CMM_CREATE_MODEL_DIALOG']//textarea[@name='description']    ${desc}
    Click Element    //div[@id='CMM_CREATE_MODEL_DIALOG']//span[@id='CMM_CREATE_MODEL_DIALOG_OK_label']   
  
supprimerModele
    [Arguments]        ${modele}  
    Wait Until Element Is Visible    //div[@id='MODELS_LIST']//span[contains(text(), '${modele}')]/ancestor::td/following-sibling::td[3]/div/div/div/span[2]  30
    Click Element    //div[@id='MODELS_LIST']//span[contains(text(), '${modele}')]/ancestor::td/following-sibling::td[3]/div/div/div/span[2]    
    ${IWidget}  Get Element Attribute    //div[@id='MODELS_LIST']//span[contains(text(), '${modele}')]/ancestor::td/following-sibling::td[3]/div[1]/div[1]    id
    Wait Until Element Is Visible    //div[contains(@dijitpopupparent, '${IWidget}')]/div/div/div[2]/table/tbody/tr[3]/td[2][text() = 'Supprimer']   
    Click Element    //div[contains(@dijitpopupparent, '${IWidget}')]/div/div/div[2]/table/tbody/tr[3]/td[2][text() = 'Supprimer']      
    Click Element    //div[@id='CMM_DELETE_MODEL_DIALOG']/div[2]/div[2]/span/span/span/span[text() = 'Supprimer']    
    
creerGroupe
    [Arguments]  ${identifiant}  ${Nom_affiche}
    Click Element    //a[contains(text(), 'Outils admin')]
    Click Element    //a[@title='Gestion des groupes']
    sleep    ${timeout}
    Click Element        //button[@id='page_x002e_ctool_x002e_admin-console_x0023_default-browse-button-button'] 
    Wait Until Element Is Visible    //span[@class='groups-newgroup-button']  16   
    Click Element        //span[@class='groups-newgroup-button']
    Input Text           //input[@id='page_x002e_ctool_x002e_admin-console_x0023_default-create-shortname']    ${identifiant}    
    Input Text           //input[@id='page_x002e_ctool_x002e_admin-console_x0023_default-create-displayname']    ${Nom_affiche}  
    Click Element        //button[@id='page_x002e_ctool_x002e_admin-console_x0023_default-creategroup-ok-button-button']    
   
supprimerGroupe     
    [Arguments]  ${vGroupe}    
    Click Element    //a[text()='Outils admin']    
    Click Element    //a[@title='Gestion des groupes']    
    Input Text       //div[@class='groups']//div[@class='search-text']/input[1]    ${vGroupe}    
    Click Element    //div[@class='search-button']/span[1]/span[1]/button[1]
    Wait Until Page Contains Element    //a[@class='delete']  30        
    Click Element    //a[@class='delete']  
    Wait Until Element Is Visible   //div[@class='bdft']/span[1]/span[1]/button[text()='Supprimer']    15
    Click Element    //div[@class='bdft']/span[1]/span[1]/button[text()='Supprimer']    
    
creerUtilisateur
    [Arguments]     ${vPrenom}   ${vNom}   ${vEmail}   ${vNomUtilisateur}   ${vMot2Pass}    ${vMot2PassAverifier}     ${vNomGroup}    ${vQota}    ${value}   
    #Cliquer sur le boutton outils admin
    Click Element    id=HEADER_ADMIN_CONSOLE_text
    #Attendre jusqu a ce l element nouveau utilisateur soit visible
    Wait Until Element Is Visible    xpath://a[@href="users"]      
    #verification de titre de la page  
    Title Should Be    Alfresco » Outils admin
    #cliquer sur utilisatuer situe dans le menu a gauche    
    Click Element    xpath://a[@href="users"]    
    #Attendre jusqu a ce que le boutton nouvel utilisateur soit present dans la page
    Wait Until Page Contains Element    xpath://span[@id="page_x002e_ctool_x002e_admin-console_x0023_default-newuser-button"]//button
    #Verifier que la page contient le text Recherche d'utilisateur
    Page Should Contain    Recherche d'utilisateur    
    #Cliquer sur le bouton nouvel utilisateur
    Click Button    xpath://span[@id="page_x002e_ctool_x002e_admin-console_x0023_default-newuser-button"]//button       
    #Attendre jusqu a ce que la page qui se charge contient le champ prenom
    Wait Until Page Contains Element    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-firstname"]
    #Saisir le prenom
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-firstname"]    ${vPrenom}
    #Saisir le nom
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-lastname"]    ${vNom} 
    #Saisir email
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-email"]    ${vEmail}
    #Saisir nom d utilisateur 
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-username"]    ${vNomUtilisateur}
    #Saisir le mot de passe
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-password"]    ${vMot2Pass}
    #Saisir a nouveau le meme mot de passe
    Input Text    //input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-verifypassword"]    ${vMot2PassAverifier}                   
    #Saisir le nom de groupe de nouveau utilisateur a cree
    Input Text    xpath://input[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-groupfinder-search-text"]    ${vNomGroup} 
    #Cliquer sur le boutton chercher le groupe
    Click Element    id=page_x002e_ctool_x002e_admin-console_x0023_default-create-groupfinder-group-search-button-button 
    #Sleep 4 seconde  
    Sleep    4 seconds       
    #Attendre jusqu a ce que le page contient le nom de groupe rechrehce et le boutton d ajouter  
    Wait Until Element Is Visible    xpath://div[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-groupfinder-results"]//h3[text()="${vNomGroup}"]//parent::div//parent::td//following-sibling::td//button   
    #cliquer sur le boutton ajouter 
    Click Button    xpath://div[@id="page_x002e_ctool_x002e_admin-console_x0023_default-create-groupfinder-results"]//h3[text()="${vNomGroup}"]//parent::div//parent::td//following-sibling::td//button    
    #Le nom de groupe auquel l utilisateur est ajouter doit s affiche 
    Element Should Be Visible    xpath://span[text()="${vNomGroup}"]    
    #Saisir le nombre de quota 
    Input Text    id = page_x002e_ctool_x002e_admin-console_x0023_default-create-quota    ${vQota}          
    #Selectionner la valeur soit mb,gb,kb,
    Select From List By Value    id = page_x002e_ctool_x002e_admin-console_x0023_default-create-quotatype    ${value}    
    #La page doit contenir le bouton creer un utilisateur 
    Element Should Be Visible    id = page_x002e_ctool_x002e_admin-console_x0023_default-createuser-ok-button-button     
    #Cliquer sur le boutton creer l utilisateur    
    Click Button    id = page_x002e_ctool_x002e_admin-console_x0023_default-createuser-ok-button-button    
    #Attendre jusqu a ce que la page se raffraicher 
    Wait Until Page Contains    Recherche d'utilisateur
    #Verifier le titre de la page 
    Title Should Be    Alfresco » Outils admin          
    #Vous pouvez vous deconnecter   
supprimerUtilisateur
    [Arguments]    ${utilisateurAsupprimer}
    #Cliquer sur le boutton outils admin
    Click Element    id=HEADER_ADMIN_CONSOLE_text
    #Attendre jusqu a ce l element nouveau utilisateur soit visible
    Wait Until Element Is Visible    xpath://a[@href="users"]      
    #verification de titre de la page  
    Title Should Be    Alfresco » Outils admin
    #cliquer sur utilisatuer situe dans le menu a gauche    
    Click Element    xpath://a[@href="users"]   
    #Attendre jusqu a ce que le bouton rechercher soit visible 
    Wait Until Element Is Visible    id=page_x002e_ctool_x002e_admin-console_x0023_default-search-button-button     
    #Verifier que la page contient le text Recherche d'utilisateur
    Page Should Contain    Recherche d'utilisateur    
    #Saisir dans le champ rechercher le nom utilisatuer complet de l utilisatuer a supprimer (saisir le user name pas le nom ou le prenom)
    Input Text    id = page_x002e_ctool_x002e_admin-console_x0023_default-search-text     ${utilisateurAsupprimer}   
    #Cliquer sur le boutton rechercher
    Click Button    id = page_x002e_ctool_x002e_admin-console_x0023_default-search-button-button
    #Sleep vous pouvez changer la valeur de time 
    Sleep    3 seconds    
    #cliquer sur l'utilisateur a supprimer 
    Click Element    xpath://tbody[@class="yui-dt-data"]//tr//td/descendant::div[text()="${utilisateurAsupprimer}"]//parent::td//preceding-sibling::td//a    
    #attendre que la page se charge
    Wait Until Element Is Visible    id=page_x002e_ctool_x002e_admin-console_x0023_default-deleteuser-button-button
    #verifier que la page contient le nom utilisateur de l'utilisateur a supprimer 
    Page Should Contain     ${utilisateurAsupprimer}
    #Cliquer sur le boutton supprimer 
    Click Button    id=page_x002e_ctool_x002e_admin-console_x0023_default-deleteuser-button-button 
    #Sleep vous pouvez changer la valeur de time 
    Sleep    2 seconds    
    #Cliquer sur supprimer dans la fenetre qui s'affiche
    Click Button    xpath://button[starts-with(@id,"yui-gen") and contains (text(),"Supprimer")] 
    #Verifier que la page s est actualisee
    Page Should Contain    Recherche d'utilisateur    
    #Vous pouvez vous deconnecter...    