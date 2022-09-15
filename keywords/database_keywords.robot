*** Keywords ***
Connect to techtalk database
    Connect to database     pymysql     ${db_name}    ${db_username}     ${db_password}    ${db_host}    ${db_port}

Common - Execute SQL string and compare row count
    [Arguments]         ${SQL_string}   ${input_row_count}
    ${output} =    run keyword          Row Count         ${SQL_string}
    log     ${output}
    log     ${input_row_count}
    Should Be Equal As Strings    ${output}    ${input_row_count}

Database - Query all attenders
    ${attenders}     Query     SELECT * FROM attender
    [Return]    ${attenders}

Database - Query attender by id
    [Arguments]    ${id}
    ${attender}    Query     SELECT * FROM attender WHERE id = '${id}'
    [Return]    ${attender[0]}

Database - attender - Verify all information is correct
    [Arguments]   ${id}   ${expected_attender}

    ${actual_attender}    Database - Query attender by id    ${id}

    Should be equal as strings     ${actual_attender[1]}     ${expected_attender["full_name"]}
    Should be equal as strings     ${actual_attender[2]}     ${expected_attender["email"]}

    ${actual_dob_str}     Convert To String    ${actual_attender[3]}
    ${actual_dob}    Get Substring    ${actual_dob_str}    0    10

    ${expected_dob_str}    Convert To String    ${expected_attender["date_of_birth"]}
    ${expected_dob}    Get Substring    ${expected_dob_str}    0    10

    Should be equal as strings     ${actual_dob}     ${expected_dob}
    Should be equal as strings     ${actual_attender[5]}     ${expected_attender["organization"]}
    Should be equal as strings     ${actual_attender[6]}     ${expected_attender["role"]}
    Should be equal as strings     ${actual_attender[7]}     ${expected_attender["months_of_experience"]}

Database - attender - Verify not existed attender
    [Arguments]    ${id}
    ${sql}     Set Variable    SELECT * FROM attender WHERE id = '${id}'
    Common - Execute SQL string and compare row count    ${sql}    0