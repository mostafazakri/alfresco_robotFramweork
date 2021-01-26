*** Settings ***
Library    SeleniumLibrary    


*** Keywords ***

 OpenBrowserInLanguage
  [Arguments]  ${URL}  ${language}  ${browser} 
  [Documentation]  Starts the Google Chrome browser.
  ${options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
  Call Method  ${options}  add_argument  --lang\=${language}
  Create WebDriver   Chrome   chrome_options=${options}
  Go To  ${URL}