codeunit 70061000 VerifyEmailAddress
{

    procedure Verify(email: text)
    begin
        DoVerify(email);
    end;

    local procedure DoVerify(Email: text)
    var
        Arguments : Record RESTWebServiceArguments temporary;
    begin
        if email = '' then
            exit;

        InitArguments(Arguments,Email);
        if not CallWebService(Arguments) then
            exit;
        ViewResult(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record RESTWebServiceArguments temporary; Email: text)
    begin
        Arguments.URL := STRSUBSTNO('http://api.email-validator.net/api/verify?EmailAddress=%1&APIKey=%2',Email,'ev-50a7169cfd00917c49368f9a086eb1d5');
        Arguments.RestMethod := Arguments.RestMethod::get;
    end;

    local procedure CallWebService(var Arguments: Record RESTWebServiceArguments temporary) Success : Boolean
    var
        RESTWebService: codeunit RESTWebServiceCode;
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure ViewResult(var Arguments: Record RESTWebServiceArguments temporary)
    var
        JSONMethods: codeunit JSONMethods;
        JSONResult: JsonObject;
        MessageText: text;
        info: text;
    begin
        JSONResult.ReadFrom(Arguments.GetResponseContentAsText);

        MessageText := StrSubstNo('Verifying E-mail Address...\' + 
                                  'Info: %1\' +
                                  'Details: %2',
                                   JSONMethods.GetJsonValueAsText(JSONResult,'info'),
                                   JSONMethods.GetJsonValueAsText(JSONResult,'details'));
        Message(MessageText);
    end;
}