from robot.libraries.BuiltIn import BuiltIn
from copy import deepcopy
import sys

IS_PYTHON_2 = sys.version_info < (3,)

if IS_PYTHON_2:
    STRING_TYPES = (unicode, str)
else:
    STRING_TYPES = (str)

def rest_extract(what="", sort_keys=False, print_log=False):
    rest_instance = BuiltIn().get_library_instance('REST')
    if isinstance(what, STRING_TYPES):
        if what == "":
            try:
                json = deepcopy(rest_instance._last_instance_or_error())
                json.pop('schema')
                json.pop('spec')
            except IndexError:
                raise RuntimeError("Error")
        elif what.startswith(("request", "response", "$")):
            rest_instance._last_instance_or_error()
            matches = rest_instance._find_by_field(what, return_schema=False, print_found=print_log)
            if len(matches) > 1:
                json = [found['reality'] for found in matches]
            else:
                json = matches[0]['reality']
        else:
            try:
                json = rest_instance._input_json_as_string(what)
            except ValueError:
                json = rest_instance._input_string(what)
    else:
        json = rest_instance._input_json_from_non_string(what)
    sort_keys = rest_instance._input_boolean(sort_keys)
    rest_instance.log_json(json, also_console=print_log, sort_keys=sort_keys)
    return json