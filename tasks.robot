*** Settings ***
Documentation     Store LinkedIn contacts into a CSV file.
Library           Browser
Library           Collections
Library           RPA.Robocloud.Secrets
Library           RPA.Tables
Library           String

*** Variables ***
${CONTACTS_CSV}=    ${CURDIR}${/}output${/}contacts.csv

*** Keywords ***
Log in
    New Page    https://www.linkedin.com/
    ${secret}=    Get Secret    linkedin
    Type Secret    css=#session_key    ${secret}[username]
    Type Secret    css=#session_password    ${secret}[password]
    Click    css=.sign-in-form__submit-button
    Wait For Elements State    text=My Network    visible

*** Keywords ***
Get contacts
    [Arguments]    ${contact_elements}
    @{contacts}=    Create List
    FOR    ${contact_element}    IN    @{contact_elements}
        ${info}=    Get contact info    ${contact_element}
        Append To List    ${contacts}    ${info}
    END
    [Return]    ${contacts}

*** Keywords ***
Get contact info
    [Arguments]    ${contact_element}
    Click    ${contact_element}
    @{info_elements}=    Get Elements    css=.abi-saved-contacts-modal-content__info
    @{contact_info}=    Create List
    FOR    ${info_element}    IN    @{info_elements}
        ${text}=    Get Text    ${info_element}
        Append To List    ${contact_info}    ${text}
    END
    Click    css=button[aria-label="Dismiss"]
    [Return]    ${contact_info}

*** Tasks ***
Store LinkedIn contacts into a CSV file
    Log in
    Go To    https://www.linkedin.com/mynetwork/import-contacts/saved-contacts/
    @{contact_elements}=    Get Elements    css=.contact-summary__name
    @{contacts}=    Get contacts    ${contact elements}
    ${table}=    Create Table    ${contacts}
    Write Table To Csv    ${table}    ${CONTACTS_CSV}
