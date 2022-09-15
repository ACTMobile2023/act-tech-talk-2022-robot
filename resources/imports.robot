*** Settings ***
Variables           config_${env}.yaml

Library             SeleniumLibrary   implicit_wait=5     run_on_failure=Capture Page Screenshot
Library             String
Library             OperatingSystem
Library             DatabaseLibrary
Library             REST

#Customer library
Library             ./pythonlibs/rest_util.py