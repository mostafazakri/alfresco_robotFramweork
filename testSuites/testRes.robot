*** Settings ***
Library    Collections
Library    String
Library    SeleniumLibrary 
Library    OperatingSystem
Library    csvHandling        
Resource    ../ressources/Connect.robot
Resource    ../ressources/Logout.robot
Resource    ../ressources/Keywords.robot

*** Variables ***
#Variables de connexion
#8091 N 8066

${affecterUtilisateurAuGroupeDATAPOOL}         ./ressources/affecterUtilisateurAuGroupe.csv
${modifierDATAPOOL}                            ./ressources/modifierModele.csv

${server}             8066
${VURL}               http://localhost:${server}/share/page/
${vBrowser}           Chrome
${vUsername}          6156493
${vPassword}          12345678
${title}              Alfresco » Connexion
${language}           fr
${TIMEOUT}            3
${maxImplicitWait}    40

#Modele
${espaceNomModele}    modele_XX
${prefixModele}       222
${nomModele}          modele_XX
${createurModele}     mostafa 
${descModele}         petiteDesc

#TypePerso
${nomTypePerso}       nom_Type_Perso
${typeParent}         cm:content (Contenu)
${libelleAffichage}   libelle Affichage
${descTypePerso}      description

#ajouterPaneau
${typePanneau}        dojoUnique1
${titrePanneau}       Description
${typeProp}           dojoUnique6
${typeWrapper}        singleColumnWrapper

#modifPanneau
${ColonnesPanneau}    panneau triple colonne
${NNomPanneau}        changed pannel name
${NApparencePanneau}  Titre


*** Test Cases ***

   

affecterUtilisateurAuGroupe
    Connect.Connect        ${VURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${title}    ${TIMEOUT}   ${language}
    ${timestamp} =     Init Date
    @{Utilisateurs}    Create List
    @{groupes}         Create List
    @{Lignes} =        return list from csv    ${affecterUtilisateurAuGroupeDATAPOOL}
    FOR  ${Ligne}    IN    @{Lignes}
         @{param} =    Split String    ${Ligne}    ;
         creerGroupe            ${param}[6]-${timestamp}  ${param}[6]
         creerUtilisateur       ${param}[0]    ${param}[1]    ${param}[2]    ${param}[3]-${timestamp}   ${param}[4]    ${param}[5]    ${param}[6]   ${param}[7]   ${param}[8]
         creerGroupe            ${param}[9]-${timestamp}  ${param}[10]
         Append To List         ${Utilisateurs}    ${param}[3]-${timestamp}
         Append To List         ${groupes}    ${param}[6]-${timestamp}  ${param}[9]-${timestamp}
         Click Element          //a[@title='Gestion des groupes']
         sleep                  ${timeout}
         Input Text             //div[@class='groups']//div[@class='search-text']/input[1]    ${param}[9]-${timestamp}
         Click Element          //button[@id='page_x002e_ctool_x002e_admin-console_x0023_default-browse-button-button']
         Wait Until Page Contains Element    //div[@id='page_x002e_ctool_x002e_admin-console_x0023_default-columnbrowser']//descendant::span[text() = '${param}[9] (${param}[9]-${timestamp})']
         Click Element          //div[@id='page_x002e_ctool_x002e_admin-console_x0023_default-columnbrowser']//descendant::span[text() = '${param}[9] (${param}[9]-${timestamp})']
         Wait Until Element Is Visible    //div[@id='page_x002e_ctool_x002e_admin-console_x0023_default-columnbrowser']/div[2]/ul/li[2]/div[1]//span[@title = 'Ajouter un utilisateur']
         Click Element          //div[@id='page_x002e_ctool_x002e_admin-console_x0023_default-columnbrowser']/div[2]/ul/li[2]/div[1]//span[@title = 'Ajouter un utilisateur']
         Input Text             //div[@class='search-text']/input[@id='page_x002e_ctool_x002e_admin-console_x0023_default-search-peoplefinder-search-text']    ${param}[3]-${timestamp}
         Click Element          //button[@id='page_x002e_ctool_x002e_admin-console_x0023_default-search-peoplefinder-search-button-button']
         Wait Until Element Is Visible    //span[contains(text(), '${param}[3]-${timestamp}')]//ancestor::div[1]//parent::td//following-sibling::td//button
         Click Element          //span[contains(text(), '${param}[3]-${timestamp}')]//ancestor::div[1]//parent::td//following-sibling::td//button
         Wait Until Page Contains Element    //div[@id='page_x002e_ctool_x002e_admin-console_x0023_default-columnbrowser']//descendant::span[contains(text(),'${param}[3]-${timestamp}')]
         supprimerGroupe        ${groupes}[0]
         supprimerGroupe        ${groupes}[1]
         supprimerUtilisateur   ${Utilisateurs}[0]
    END
    Logout.Logout

     
modifierModele
    Connect.Connect    ${VURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${title}    ${TIMEOUT}   ${language}
    ${timestamp} =     Init Date
    @{Utilisateurs}    Create List
    @{groupes}         Create List
    @{Lignes} =        return list from csv    ${modifierDATAPOOL}
    FOR  ${Ligne}    IN    @{Lignes}
        @{param} =    Split String    ${Ligne}    ;
        #PRECONDITIONS
        creerModele        ${param}[0]  ${param}[1]  ${param}[2]-${timestamp}  ${param}[3]  ${param}[4]
        #AllerSurLaPageDuModele
        Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${param}[2]-${timestamp}')]  15
        Click Element      //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${param}[2]-${timestamp}')]//ancestor::td[1]//following-sibling::td[3]
        #CLiquerSurModifier
        Click Element      //div[contains(@class, 'Popup')]/div/div/div[2]/table/tbody/tr[2]/td[2][contains(text(), 'Modifier')]
        #DATAPOOL
        Input Text         //div[@id='CMM_EDIT_MODEL_DIALOG']//input[@name='namespace']         ${param}[5]
        Input Text         //div[@id='CMM_EDIT_MODEL_DIALOG']//input[@name='prefix']            ${param}[6]
        Input Text         //div[@id='CMM_EDIT_MODEL_DIALOG']//input[@name='author']            ${param}[7]
        Input Text         //div[@id='CMM_EDIT_MODEL_DIALOG']//textarea[@name='description']    ${param}[8]
        #DATAPOOL
        Click Element      id=CMM_EDIT_MODEL_DIALOG_OK
        Reload Page
        #Assertion 
        Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${param}[5]')]  15
        Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${param}[5]')]//ancestor::td//preceding-sibling::td/span/span/span[2][contains(text(),'${param}[2]-${timestamp}')]        
        #POSTCONDITIONS
        supprimerModele    ${param}[2]-${timestamp}
    END
    Logout.Logout  
  

   
ajouterPanneauAuTypePersonalise      
    ###PRE-CONDITIONS
    ${timeStamp} =    Init Date
    Connect.Connect    ${VURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${title}    ${TIMEOUT}   ${language}
    creerModele        ${espaceNomModele}  ${prefixModele}${timeStamp}  ${nomModele}${timeStamp}  ${createurModele}  ${descModele} 
    Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${nomModele}')]  ${maxImplicitWait}
    CreerTypePerso    ${nomModele}${timeStamp}    ${nomTypePerso}${timeStamp}    ${typeParent}    ${libelleAffichage}   ${descTypePerso}
    Reload Page
    ###ETAPES_TEST
    #cliquer sur actions pour afficher le dropdown
    Wait Until Page Contains Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}${timeStamp}')]/ancestor::td/following-sibling::td[4]  ${maxImplicitWait}
    Click Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}${timeStamp}')]/ancestor::td/following-sibling::td[4]/div/div/div/span[2]
    #recuperer l'identifiant dur dropDown dynamique
    ${idDropDown}=   Get Element Attribute  //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}${timeStamp}')]/ancestor::td/following-sibling::td[4]/div[1]/div[1]  id
    #cliquer sur supprimer
    Wait Until Page Contains Element   //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']  ${maxImplicitWait}
    Click Element    //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']
    
    #Effectuer drag and drop du panneau 
    DragAndDropPanneaux    5    dojoUnique2
    
    #cliquer sur enregsitrer
    Click Element                      //span[text()='Enregistrer']
    
    #Assertion
    Wait Until Element Is Visible      //span[text()='Votre disposition a bien été enregistrée']
    
    ###POST-ECONDITIONS
    supprimerTypePerso    ${nomModele}${timeStamp}  ${nomTypePerso}${timeStamp}
    goToModel    ${nomModele}${timeStamp}
    supprimerModele    ${nomModele}${timeStamp}
    Logout.Logout

    
editerProprietesDePanneau
    ###PRE-CONDITIONS
    ${timeStamp} =    Init Date
    Connect.Connect    ${VURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${title}    ${TIMEOUT}   ${language}
    creerModele        ${espaceNomModele}  ${prefixModele}${timeStamp}  ${nomModele}${timeStamp}  ${createurModele}  ${descModele} 
    Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${nomModele}')]  ${maxImplicitWait}
    CreerTypePerso    ${nomModele}${timeStamp}    ${nomTypePerso}${timeStamp}    ${typeParent}    ${libelleAffichage}   ${descTypePerso}
    Reload Page
    
    ###ETAPES_TEST
    #cliquer sur actions pour afficher le dropdown
    Wait Until Page Contains Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]  ${maxImplicitWait}
    Click Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]/div/div/div/span[2]
    
    #recuperer l'identifiant dur dropDown dynamique
    ${idDropDown}=   Get Element Attribute  //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]/div[1]/div[1]  id
    
    #cliquer sur concepteur de dispostion
    Wait Until Page Contains Element   //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']  ${maxImplicitWait}
    Click Element    //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']   
    
    sleep  3
    #Effectuer drag and drop du panneau 
    DragAndDropPanneaux    1    ${typePanneau}
    
    #cliquer sur enregsitrer
    Click Element                           //span[text()='Enregistrer']
    #Attente de l'apparition et disparition du popup de confirmation de l'enregistrement
    Wait Until Element Is Visible           //span[text()='Votre disposition a bien été enregistrée']  ${maxImplicitWait}
    Wait Until Element Is Not Visible       //span[text()='Votre disposition a bien été enregistrée']  5
    
    ###ETAPES_TEST
    #Configurer les variables du type de panneau
    
    Run Keyword If    '${typePanneau}' == 'dojoUnique1'    Set Variable   ${typeWrapper}  =  singleColumnWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique2'    Set Variable   ${typeWrapper}  =  doubleColumnWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique3'    Set Variable   ${typeWrapper}  =  doubleColumnWideLeftWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique4'    Set Variable   ${typeWrapper}  =  tripleColumnWrapper  
    
    #Not triggering any real click anymore after alfresco issue
    Wait Until Page Contains Element    //div[contains(@class,'alfresco-dnd-DroppedItemWrapper ${typeWrapper} dojoDndItem')][1]    5
    Click Element                       //div[contains(@class,'alfresco-dnd-DroppedItemWrapper ${typeWrapper} dojoDndItem')][1]
    
    Wait Until Page Contains Element                 //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']    10
    ${idDropDownColones} =    Get Element Attribute  //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[1]  id
    ${idDropDownApparence} =  Get Element Attribute  //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[3]  id
    
    #Champ Colonnes
    Click Element                       //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[1]/div[2]/div/table/tbody/tr/td[2]
    Wait Until Page Contains Element    //div[contains(@class,'dijitPopup dijitMenuPopup') and contains(@id,'${idDropDownColones}')]//tr/td[contains(text(),'${ColonnesPanneau}')]  ${maxImplicitWait}
    Click Element                       //div[contains(@class,'dijitPopup dijitMenuPopup') and contains(@id,'${idDropDownColones}')]//tr/td[contains(text(),'${ColonnesPanneau}')]
    
    #Champ Nom
    Input Text                          //div[@class='alfresco-forms-controls-BaseFormControl wipe alfresco-forms-controls-TextBox']//div[contains(@class,'dijitInputField')]/input    ${NNomPanneau}  
    
    #Champ Apparence
    Click Element                       //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[3]/div[2]/div/table/tbody/tr/td[2]
    Wait Until Page Contains Element    //div[contains(@class,'dijitPopup dijitMenuPopup') and contains(@id,'${idDropDownApparence}')]//tr/td[contains(text(),'${NApparencePanneau}')]  ${maxImplicitWait}
    Click Element                       //div[contains(@class,'dijitPopup dijitMenuPopup') and contains(@id,'${idDropDownApparence}')]//tr/td[contains(text(),'${NApparencePanneau}')]
    
    #Assertions
    Element Should Contain              //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[1]/div[2]/div/table/tbody/tr/td/div/span    ${ColonnesPanneau}
    Element Should Contain              //div[@id='ALF_DROPPED_ITEM_CONFIGURATION_TITLE_PANE_pane']//form/div[3]/div[2]/div/table/tbody/tr/td/div/span    ${NApparencePanneau}
    Wait Until Page Contains Element    //span[@class='label' and contains(text(),'${NNomPanneau}')] 
    
    ###POST-ECONDITIONS
    supprimerTypePerso    ${nomModele}${timeStamp}  ${nomTypePerso}${timeStamp}
    goToModel    ${nomModele}${timeStamp}
    supprimerModele    ${nomModele}${timeStamp}
    Logout.Logout
    
retirerProprieteDuTypePersonalise
    ###PRE-CONDITIONS
    ${timeStamp} =    Init Date
    Connect.Connect    ${VURL}    ${vBrowser}    ${vUsername}    ${vPassword}    ${title}    ${TIMEOUT}   ${language}
    creerModele        ${espaceNomModele}  ${prefixModele}${timeStamp}  ${nomModele}${timeStamp}  ${createurModele}  ${descModele} 
    Wait Until Page Contains Element    //div[@class='alfresco-lists-AlfList']/div[3]/div/table/tbody/tr/td/span/span/span[2][contains(text(),'${nomModele}')]  ${maxImplicitWait}
    CreerTypePerso    ${nomModele}${timeStamp}    ${nomTypePerso}${timeStamp}    ${typeParent}    ${libelleAffichage}   ${descTypePerso}
    Reload Page
    
    ###ETAPES_TEST
    
    #cliquer sur actions pour afficher le dropdown
    Wait Until Page Contains Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]  ${maxImplicitWait}
    Click Element    //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]/div/div/div/span[2]
    
    #recuperer l'identifiant dur dropDown dynamique
    ${idDropDown}=   Get Element Attribute  //div[@id='TYPES_LIST']//span[contains(text(), '${nomTypePerso}')]/ancestor::td/following-sibling::td[4]/div[1]/div[1]  id
    
    #cliquer sur concepteur de dispostion
    Wait Until Page Contains Element   //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']  ${maxImplicitWait}
    Click Element    //div[contains(@dijitpopupparent, '${idDropDown}')]/div/div/div[2]/table/tbody/tr[1]/td[2][text() = 'Concepteur de disposition']
     
    sleep  3
    #Effectuer drag and drop du panneau
    DragAndDropPanneaux    1    ${typePanneau}
    
    #cliquer sur enregsitrer
    Click Element                           //span[text()='Enregistrer']
    #Attente de l'apparition et disparition du popup de confirmation de l'enregistrement
    Wait Until Element Is Visible           //span[text()='Votre disposition a bien été enregistrée']  ${maxImplicitWait}
    Wait Until Element Is Not Visible       //span[text()='Votre disposition a bien été enregistrée']  5
    
    ${idPropriete}    Get Element Attribute   //div[contains(@class,'dojoDndItem')]/div[contains(@title,'${titrePanneau}')]/parent::div  id
    #Configurer les variables du type de panneau
    Run Keyword If    '${typePanneau}' == 'dojoUnique1'    Set Variable   ${typeWrapper}  =  singleColumnWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique2'    Set Variable   ${typeWrapper}  =  doubleColumnWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique3'    Set Variable   ${typeWrapper}  =  doubleColumnWideLeftWrapper    
    Run Keyword If    '${typePanneau}' == 'dojoUnique4'    Set Variable   ${typeWrapper}  =  tripleColumnWrapper    
    
    #Ajouter la propriete
    DragAndDropProperties   1  ${idPropriete}   ${typeWrapper}
    
    #retirer la propriete
    Mouse Over     //div[contains(@class,'alfresco-dnd-DroppedItemWrapper')]//span[contains(text(),'${titrePanneau}')]/preceding-sibling::div[@class='actions']
    Wait Until Element Is Visible    //div[contains(@class,'alfresco-dnd-DroppedItemWrapper')]//span[contains(text(),'${titrePanneau}')]/preceding-sibling::div[@class='actions']/span[contains(@class,'delete')]
    Click Element    //div[contains(@class,'alfresco-dnd-DroppedItemWrapper')]//span[contains(text(),'${titrePanneau}')]/preceding-sibling::div[@class='actions']/span[contains(@class,'delete')]        
    
    Wait Until Page Does Not Contain Element    //div[contains(@class,'alfresco-dnd-DroppedItemWrapper')]//span[contains(text(),'${titrePanneau}')]           

    ###POST-ECONDITIONS
    supprimerTypePerso    ${nomModele}${timeStamp}  ${nomTypePerso}${timeStamp}
    goToModel    ${nomModele}${timeStamp}
    supprimerModele    ${nomModele}${timeStamp}
    Logout.Logout