*** Keywords ***
Common - Open ${url} with ${browser} browser
    ${browser}    Convert to lowercase    ${browser}
    ${true}       Convert to boolean      true
    ${desired_capabilities}     create dictionary
    ...         acceptSslCerts=${true}
    ...         acceptInsecureCerts=${true}
    ...         ignore-certificate-errors=${true}

    Run Keyword If    '${browser}' == 'chrome'     Run Keywords     Open Browser    ${url}    ${browser}    desired_capabilities=${desired_capabilities}
    ...     AND     Common - Maximize browser window
    ...     ELSE IF   '${browser}' == 'headlesschrome'
    ...     Run keyword      Start Chrome in headless mode    ${url}
    ...     ELSE        should be true    ${FALSE}

Common - Maximize browser window
    Set window position    0    0
    Set window size        1440    900

Start Chrome in headless mode
    [Arguments]    ${url}
    ${chrome_options} =    Evaluate    selenium.webdriver.ChromeOptions()
    ${list_val}=    create list       enable-automation
    ${ws}=    Set Variable    window-size=1920,1080
    ${atcontroller}=    Set Variable    disable-blink-features=AutomationControlled
    ${vizdisplay}=      set variable  disable-features=VizDisplayCompositor
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-browser-side-navigation
    Call Method    ${chrome_options}    add_argument    --allow-running-insecure-content
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    Call Method    ${chrome_options}    add_argument    --disable-web-security
    Call Method    ${chrome options}    add_argument        ${ws}
    call method     ${chrome options}    add_argument    --disable-web-security
    call method     ${chrome options}    add_argument    --allow-running-insecure-content
    call method     ${chrome options}    add_argument    --disable-blink-features
    call method     ${chrome options}    add_argument       ${atcontroller}
    call method     ${chrome options}    add_argument       ${vizdisplay}
    Call Method    ${chrome_options}    add_experimental_option    name=useAutomationExtension    value=${False}
    call method    ${chrome_options}    add_experimental_option     name=excludeSwitches    value=${list_val}
    Create WebDriver    Chrome    chrome_options=${chrome_options}
    Go to       ${url}

Common - Click on element
	[Arguments]  ${locator}
	Wait Until Page Contains Element        ${locator}      5s
    ${state}=   run keyword and return status   scroll_element_into_view        ${locator}
    run keyword if      ${state}==${False}       Wait Until Element Is Enabled       ${locator}      5
    run keyword if      ${state}==${False}      scroll_element_into_view        ${locator}
    ${success}=     run keyword and return status   click element       ${locator}
    run keyword if   ${success}==${False}      click element       ${locator}

Common - Input Text
    [Arguments]    ${locator}     ${text}
    ${state}=   run keyword and return status   scroll_element_into_view        ${locator}
    run keyword if   ${state}==${False}      scroll_element_into_view        ${locator}
    ${success}=     run keyword and return status   Input Text    ${locator}     ${text}
    run keyword if   '${success}'=='False'  Input Text    ${locator}     ${text}

Common - Upload file
    [Arguments]     ${locator}     ${file_path}
    ${xlsx_file_path}       Normalize Path              ${file_path}
    Choose File     ${locator}       ${xlsx_file_path}
    sleep   1s