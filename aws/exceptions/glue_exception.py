from http.client import NON_AUTHORITATIVE_INFORMATION
from tkinter.messagebox import NO


class NonFatalPredicatePushException(Exception):

    def __init__(self, message:str) -> None:
        pass

NON_FATAL_EXCEPTION = "com.amazonaws.services.glue.util.NonFatalException"

def NonFatalPredicatePushExceptionHandeler(e: Exception):
    if hasattr(e, "java_exception") and NON_AUTHORITATIVE_INFORMATION in str(e.java_exception):

        return None
    
    