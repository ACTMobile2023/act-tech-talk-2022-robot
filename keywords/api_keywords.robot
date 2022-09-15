*** Keywords ***
Common - Http status code is "${code}"
    REST.integer    response status     ${code}

Common - status code is "${code}"
    REST.string    $.status.code     ${code}

Common - status message is "${message}"
    REST.string    $.status.message     ${message}