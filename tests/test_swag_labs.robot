*** Settings ***
Library           SeleniumLibrary
Suite Setup       Register Keyword To Run On Failure    NONE
Suite Teardown    Close Browser

*** Variables ***
${URL}            file:///C:/Users/gabri/OneDrive%20-%20Kaakkois-Suomen%20ammattikorkeakoulu%20Oy/toimeksianto/sess3i/sftwr_tstng/swag/robot_package/robot_package/swag_labs.html
${BROWSER}        chrome
${HEADLESS}       False
${VALID_USER}     standard_user
${VALID_PASS}     secret_sauce
${STEP_DELAY}     700ms

*** Keywords ***
Open Application
    IF    '${BROWSER}' == 'chrome'
        ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    selenium.webdriver
        Evaluate    $options.add_argument('--window-size=1920,1080')
        IF    '${HEADLESS}' == 'True'
            Evaluate    $options.add_argument('--headless=new')
            Evaluate    $options.add_argument('--no-sandbox')
            Evaluate    $options.add_argument('--disable-dev-shm-usage')
        END
        Open Browser    ${URL}    ${BROWSER}    options=${options}
    ELSE
        Open Browser    ${URL}    ${BROWSER}
    END

*** Test Cases ***
Complete Purchase Flow
    Open Application
    Sleep    ${STEP_DELAY}
    Input Text    id=username    ${VALID_USER}
    Input Password    id=password    ${VALID_PASS}
    Sleep    ${STEP_DELAY}
    Click Button    id=login-button
    Wait Until Element Is Visible    id=product-page    5s
    Sleep    ${STEP_DELAY}
    Wait Until Element Is Visible    xpath=//button[contains(@onclick,'addToCart(1)')]    5s
    Click Button    xpath=//button[contains(@onclick,'addToCart(1)')]
    Sleep    ${STEP_DELAY}
    Click Button    xpath=//button[contains(@onclick,'addToCart(2)')]
    Sleep    ${STEP_DELAY}
    Click Button    xpath=//button[contains(@onclick,'addToCart(3)')]
    Sleep    ${STEP_DELAY}
    Click Button    xpath=//button[contains(@onclick,'addToCart(4)')]
    Element Text Should Be    id=cart-count    4
    Sleep    ${STEP_DELAY}
    Click Element    css:.cart-icon
    Wait Until Element Is Visible    id=checkout-page    5s
    Sleep    ${STEP_DELAY}
    Click Button    xpath=(//button[normalize-space()='Remove'])[1]
    Wait Until Keyword Succeeds    3s    200ms    Element Should Be Visible    xpath=(//button[normalize-space()='Remove'])[1]
    ${remaining_items}=    Get Element Count    xpath=//button[normalize-space()='Remove']
    Should Be Equal As Integers    ${remaining_items}    3
    Sleep    ${STEP_DELAY}
    Input Text    id=first-name    Test
    Input Text    id=last-name    User
    Input Text    id=postal-code    45100
    Sleep    ${STEP_DELAY}
    Click Button    xpath=//button[normalize-space()='Complete Purchase']
    Wait Until Element Is Visible    id=confirmation-page    5s
    Sleep    ${STEP_DELAY}
    Page Should Contain    Thank You For Your Order!