*** Settings ***
Resource     ./imports.robot

Suite Teardown    Close all browsers

Test Teardown     Close browser


*** Variables ***
${resource_path}     ${CURDIR}/../resources

#Homepage
${btn_registration}     //button[contains(@class, 'ant-btn-link')]/span[text()='Đăng ký tham gia']
${input_fullname}       //input[@id='full_name']
${input_email}          //input[@id='email']
${input_dob}            //input[@id='date_of_birth']
${label_dob}            //label[@for='date_of_birth']
${input_avatar}         //input[@id='avatar']
${list_position}        //input[@id='role']/..
${position_option}      //div[@title='{position}']

${input_orginazation}   //input[@id='organization']
${input_exp}            //input[@id='months_of_experience']
${chk_confirm}          //input[@id='is_join_experience_section']
${btn_confirm}          //button[@type='submit']

${dialog_success}       //span[text()='Successfully!']

#Attender list page
${btn_list_attender}    //button[contains(@class, 'ant-btn-link')]/span[text()='Danh sách người tham gia']
${btn_delete_first_attender}    //tbody/tr[1]//button/span[text()='Delete']

${btnYes}               //div[@class='ant-popover-buttons']/button/span[text()='Yes']
${btnNo}                //div[@class='ant-popover-buttons']/button/span[text()='No']

${dialog_delete_success}       //span[text()='Successfully deleted']


*** Test Cases ***
TC001_FN - Registration an attendee successfully
    Given I would like to register to the Ascend Tech Talk 2022
    When I am on the Registration page
    And I input the “Full name”    full_name=Duong Nguyen Quy
    And I input the “Email”    email=duongnguyenquy212@gmail.com
    And I input the “Date of birth”    dob=15/09/2022
    And I input the “Avatar”     file_path=${resource_path}/flower.jpg
    And I input the “Company or university”    company=FPT
    And I input the “Experienced position”    position=Automation QA
    And I input the “Experience (in month)”    exp=12
    And I tick the “Confirm to join experience section”    is_experience=${True}
    And I click "Ok"
    Then I can register successfully

TC002_FN - User can delete one user
    Given I am on the attenders list page
    When I click to delete the first attender
    And I click to confirm delete
    Then I am expecting delete success message popup


*** Keywords ***
I would like to register to the Ascend Tech Talk 2022
    Common - Open ${host} with ${browser_to_run} browser

I am on the Registration page
    Common - Click on element    ${btn_registration}
    Sleep    1s

I input the “Full name”
    [Arguments]    ${full_name}
    Common - Input Text    ${input_fullname}    ${full_name}
    Sleep    1s

I input the “Email”
    [Arguments]    ${email}
    Common - Input Text    ${input_email}    ${email}
    Sleep    1s

I input the “Date of birth”
    [Arguments]    ${dob}
    Common - Click on element    ${input_dob}
    Common - Input Text    ${input_dob}    ${dob}
    Press Keys     ${input_dob}     RETURN
    Sleep    1s

I input the “Avatar”
    [Arguments]    ${file_path}
    Common - Upload file    ${input_avatar}     ${file_path}
    Sleep    1s

I input the “Company or university”
    [Arguments]    ${company}
    Common - Input Text     ${input_orginazation}    ${company}


I input the “Experienced position”
    [Documentation]    Available options : Dev, Automation QA, Student, Other
    [Arguments]    ${position}
    Common - Click on element     ${list_position}
    ${option}      Replace String      ${position_option}     {position}     ${position}
    Common - Click on element       ${option}


I input the “Experience (in month)”
    [Arguments]     ${exp}
    Common - Input Text     ${input_exp}     ${exp}


I tick the “Confirm to join experience section”
    [Arguments]    ${is_experience}
    Run keyword if     ${is_experience} is ${True}    Common - Click on element    ${chk_confirm}

I click "Ok"
    Common - Click on element    ${btn_confirm}
    Sleep    2s

I can register successfully
    Wait until page contains element    ${dialog_success}


#Attender list page
I am on the attenders list page
    Common - Open ${host} with ${browser_to_run} browser
    Common - Click on element    ${btn_list_attender}

I click to delete the first attender
    Wait Until Page Contains Element     ${btn_delete_first_attender}
    Common - Click on element    ${btn_delete_first_attender}

I click to confirm delete
    Common - Click on element    ${btnYes}
    Sleep    2s

I am expecting delete success message popup
    Wait Until Page Contains Element    ${dialog_delete_success}