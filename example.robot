*** Settings ***
Documentation     Example for showcase of changes
Library           DatabaseLibrary
Library           Collections

Suite Setup    Connect To Database    dbapiModuleName=pymssql    dbHost=HOSTNAMEGOESHERE  tds_version=7.0
# Alternate connection: 
# Suite Setup    Connect To Database Using Custom Params    pymssql   host='HOSTNAMEGOESHERE', tds_version='7.0'
Suite Teardown    Disconnect From Database

*** Variables ***
@{Empty}=

*** Test Cases ***
Should output zero if input is test
    @{Params}=    Create List    Test    CURSOR_INT
    @{Expected}=    Create List    Test    ${0}
    Stored procedure should output    path_to_stored_procedure    ${Params}    ${Expected}

Should output one if input is not test
    @{Params}=    Create List    foo    CURSOR_INT
    @{Expected}=    Create List    foo    ${1}
    Stored procedure should output    path_to_stored_procedure    ${Params}    ${Expected}

*** Keywords ***
Stored procedure should output
    [Documentation]    Takes an sql stored procedure name, an array of arguments, and an array of output values, then runs the sp expecting the output values
    [Arguments]    ${procedureName}    ${arguments}=${Empty}    ${expected}=${Empty}
    ${Param values}    ${Result sets}=    Call Stored Procedure    ${procedureName}    ${arguments}
    @{Param values}=    Convert To List    ${Param values}
    Should Be Equal    ${Param values}    ${expected}
