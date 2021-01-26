*** Settings ***
Library    SeleniumLibrary    
*** Keywords ***

Logout
    sleep    3s
    Click Element    id=HEADER_USER_MENU_POPUP
    Wait Until Element Is Visible    id=HEADER_USER_MENU_LOGOUT_text
    Click Element    id=HEADER_USER_MENU_LOGOUT_text
    [Teardown]    Close Browser