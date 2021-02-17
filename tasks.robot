*** Settings ***
Documentation     Store LinkedIn connections and contacts into CSV files.
Library           Browser    jsextension=${CURDIR}/keywords.js
Library           Collections
Library           RPA.Robocloud.Secrets
Library           RPA.Tables
Library           String

*** Variables ***
${CONNECTIONS_CSV}=    ${CURDIR}${/}output${/}connections.csv
${CONTACTS_CSV}=    ${CURDIR}${/}output${/}contacts.csv
${CONNECTION_LINK_ELEMENT}=    css=a.mn-connection-card__link

*** Keywords ***
Open LinkedIn
    New Page    https://www.linkedin.com/
    Set Viewport Size    ${1920}    ${1080}

*** Keywords ***
Log in
    ${secret}=    Get Secret    linkedin
    Type Secret    css=#session_key    ${secret}[username]
    Type Secret    css=#session_password    ${secret}[password]
    Click    css=.sign-in-form__submit-button
    Wait For Elements State    text=My Network    visible

*** Keywords ***
Store connections into a CSV file
    Go to the connections page
    ${profile_urls}=    getHrefAttributeValues    ${CONNECTION_LINK_ELEMENT}
    @{connections}=    Get connections    ${profile_urls}
    ${table}=    Create Table    ${connections}
    Write Table To Csv    ${table}    ${CONNECTIONS_CSV}

*** Keywords ***
Store contacts into a CSV file
    Go To    https://www.linkedin.com/mynetwork/import-contacts/saved-contacts/
    @{contact_elements}=    Get Elements    css=.contact-summary__name
    @{contacts}=    Get contacts    ${contact elements}
    ${table}=    Create Table    ${contacts}
    Write Table To Csv    ${table}    ${CONTACTS_CSV}

*** Keywords ***
Go to the connections page
    Go To    https://www.linkedin.com/mynetwork/invite-connect/connections/
    Wait For Elements State    ${CONNECTION_LINK_ELEMENT}    visible

*** Keywords ***
Get the number of connections
    ${connections_heading}=    Get Text    css=.mn-connections__header
    ${number_string}=    Fetch From Left    ${connections_heading}    ${SPACE}
    ${number}=    Convert To Integer    ${number_string}
    [Return]    ${number}

*** Keywords ***
Scroll until all connections are loaded
    ${connections_count}=    Get the number of connections
    Log To Console    ${connections_count} total connections.
    ${loaded}=    Set Variable    ${0}
    FOR    ${i}    IN RANGE    1000
        Exit For Loop If    ${loaded} == ${connections_count}
        Scroll page
        ${loaded}=    Get Element Count    ${CONNECTION_LINK_ELEMENT}
        Log To Console    ${loaded} connections loaded.
    END

*** Keywords ***
Scroll page
    Scroll By    vertical=100%
    Sleep    1 seconds
    # Scroll up a bit to reactivate the infinite scroll.
    Scroll By    vertical=-1%
    Sleep    1 seconds

*** Keywords ***
Get connections
    [Arguments]    ${profile_urls}
    @{connections}=    Create List
    ${processed}=    Set Variable    ${1}
    ${total}=    Get Length    ${profile_urls}
    FOR    ${profile_url}    IN    @{profile_urls}
        ${info}=    Get connection info    ${profile_url}
        Append To List    ${connections}    ${info}
        Log To Console    ${processed}/${total} processed.
        ${processed}=    Evaluate    ${processed} + 1
    END
    [Return]    ${connections}

*** Keywords ***
Get connection info
    [Arguments]    ${profile_url}
    Log To Console    Getting info for ${profile_url}
    Go To    ${profile_url}
    Scroll page
    ${full_name}=    Get Text    css=.pv-top-card--list li
    ${first_name}=    Fetch From Left    ${full_name}    ${SPACE}
    ${last_name}=    Fetch From Right    ${full_name}    ${SPACE}
    ${latest_role}=    getTextIfExists    css=#experience-section h3
    ${organization}=    getTextIfExists    css=.pv-top-card--experience-list a
    Click    text=Contact info
    ${connected}=    Get Text    css=.ci-connected .pv-contact-info__contact-item
    ${email}=    getTextIfExists    css=.ci-email a
    @{connection_info}=
    ...    Create List
    ...    ${first_name}
    ...    ${last_name}
    ...    ${latest_role}
    ...    ${organization}
    ...    ${email}
    ...    ${profile_url}
    ...    ${connected}
    [Return]    ${connection_info}

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
Store LinkedIn connections and contacts into CSV files
    Open LinkedIn
    Log in
    Store connections into a CSV file
    Store contacts into a CSV file
