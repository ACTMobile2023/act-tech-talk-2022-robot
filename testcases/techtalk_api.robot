*** Settings ***
Resource     ./imports.robot

Suite Setup    Connect to techtalk database

*** Test Cases ***
TC001 - The number of the attenders should match with the number of records in database
    [Documentation]    This testcase is going to query all the attenders and then return a list of attenders.
    ...    Then we're going to compare the response list size to the list size in the actual database.

    ${api_attenders}     API - 200 - Get all the attenders
    ${actual_api_length}     Get Length     ${api_attenders}
    Convert to integer    ${actual_api_length}

    ${db_attenders}     Database - Query all attenders
    ${actual_db_length}     Get Length    ${db_attenders}
    Convert to integer    ${actual_db_length}

    Should Be Equal As Integers     ${actual_api_length}     ${actual_db_length}

TC002 - User can registration and update and delete registration successfully
    [Documentation]    This is a happy testcase when user register
    ${attender}     Create dictionary     full_name=Duong
    ...     date_of_birth=1993-02-12T07:34:53.135Z
    ...     email=duong@gmail.com
    ...     organization=FPT    role=QA   months_of_experience=12
    ...     is_join_experience_section=true

    ${id}     API - 200 - Add new attender    ${attender}

    #Verify database to have correct information after add
    Database - attender - Verify all information is correct     ${id}     ${attender}

    ${updated_attender}     Create dictionary     full_name=Duong_edited
    ...     date_of_birth=1993-02-12T07:34:53.135Z
    ...     email=duong@gmail.com
    ...     organization=FPT    role=QA   months_of_experience=12
    ...     is_join_experience_section=true

    API - 200 - Update attender    ${id}     ${updated_attender}

    #Verify database to have correct information after update
    Database - attender - Verify all information is correct     ${id}     ${updated_attender}

    #Verify database
    ${db_attender}    Database - Query attender by id    ${id}

    API - 200 - Delete attender    ${id}

    #Verify this attender was deleted from DB
    Database - attender - Verify not existed attender    ${id}

    #Verify http status code and response body with success message
    Common - Http status code is "200"
    Common - status code is "success"
    Common - status message is "Success"

TC003 - User cannot delete non-exists attender
    API - 200 - Delete attender    random_id
    #Verify http status code and response body with success message
    Common - Http status code is "500"
    Common - status code is "general_error"
    Common - status message is "General Error"

TC004 - User cannot add a new attender with wrong DOB format
    ${attender}     Create dictionary     full_name=Duong
    ...     date_of_birth=1993/02/12T07:34:53.135Z
    ...     email=duong@gmail.com
    ...     organization=FPT    role=QA   months_of_experience=12
    ...     is_join_experience_section=true

    API - Error - Add new attender    ${attender}
    #Verify http status code and response body with success message
    Common - Http status code is "500"
    Common - status code is "general_error"
    Common - status message is "General Error"

TC005 - User cannot add a new attender with full_name is empty
    ${attender}     Create dictionary     full_name=${EMPTY}
    ...     date_of_birth=1993-02-12T07:34:53.135Z
    ...     email=duong@gmail.com
    ...     organization=FPT    role=QA   months_of_experience=12
    ...     is_join_experience_section=true

    API - Error - Add new attender    ${attender}
    #Verify http status code and response body with success message
    Common - Http status code is "400"
    Common - status code is "bad_request"
    #Common - status message is "General Error"

TC006 - User cannot add a new attender with date_of_birth is empty
    [Documentation]    Backend should validate the date_of_birth to be not blank
    ${attender}     Create dictionary     full_name=Duong
    ...     date_of_birth=${EMPTY}
    ...     email=duong@gmail.com
    ...     organization=FPT    role=QA   months_of_experience=12
    ...     is_join_experience_section=true

    API - Error - Add new attender    ${attender}
    #Verify http status code and response body with success message
    Common - Http status code is "400"
    Common - status code is "bad_request"
    #Common - status message is "General Error"


*** Keywords ***
API - 200 - Get all the attenders
    ${headers}      create dictionary
        ...         Accept=application/json
    GET     ${host}:${port}/tech-talk/attenders    headers=${headers}
    ${response}    Rest Extract
    Common - Http status code is "200"
    Common - status code is "success"
    Common - status message is "Success"
    #Return list of attenders
    [Return]    ${response["response"]["body"]["data"]["attenders"]}


API - 200 - Add new attender
    [Arguments]    ${attender}
    ${headers}      create dictionary
        ...         Accept=application/json
    POST    ${host}:${port}/tech-talk/attenders    headers=${headers}    body=${attender}
    ${response}    Rest Extract
    ${id}     Set Variable     ${response["response"]["body"]["data"]["id"]}

    #Verify http status code and response body with success message
    Common - Http status code is "200"
    Common - status code is "success"
    Common - status message is "Success"
    [Return]    ${id}

API - Error - Add new attender
    [Arguments]    ${attender}
    ${headers}      create dictionary
        ...         Accept=application/json
    POST    ${host}:${port}/tech-talk/attenders    headers=${headers}    body=${attender}
    ${response}    Rest Extract

API - 200 - Update attender
    [Arguments]    ${id}     ${attender}
    ${headers}      create dictionary
        ...         Accept=application/json
    PUT    ${host}:${port}/tech-talk/attenders/${id}    headers=${headers}    body=${attender}
    ${response}    Rest Extract

    #Verify http status code and response body with success message
    Common - Http status code is "200"
    Common - status code is "success"
    Common - status message is "Success"

API - 200 - Delete attender
     [Arguments]    ${id}
    ${headers}      create dictionary
        ...         Accept=application/json
    DELETE    ${host}:${port}/tech-talk/attenders/${id}    headers=${headers}
    ${response}    Rest Extract



