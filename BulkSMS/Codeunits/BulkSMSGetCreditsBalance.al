codeunit 70063000 BulkSMSGetCreditsBalance
{
    procedure GetCreditsBalance(var BulkSMSSetup: Record BulkSMSSetup)
    begin
        DoGetCreditsBalance(BulkSMSSetup);
    end;

    local procedure DoGetCreditsBalance(var BulkSMSSetup: Record BulkSMSSetup)
    var
        Arguments: Record RESTWebServiceArguments temporary;
    begin
        ErrorIfNoUserName(BulkSMSSetup);
        ErrorINoPassword(BulkSMSSetup);
        InitArguments(Arguments,BulkSMSSetup);
        if not CallWebService(Arguments) then
            exit;
        TestAndSaveResult(Arguments,BulkSMSSetup);
    end;

    local procedure ErrorIfNoUserName(BulkSMSSetup: Record BulkSMSSetup)
    begin
        BulkSMSSetup.TestField(UserName);
    end;
    local procedure ErrorINoPassword(BulkSMSSetup: Record BulkSMSSetup)
    begin
        BulkSMSSetup.TestField(PasswordKey);
    end;

    local procedure InitArguments(var Arguments: Record RESTWebServiceArguments temporary; BulkSMSSetup: Record BulkSMSSetup)
    begin
        Arguments.URL := StrSubstNo('https://bulksms.vsms.net/eapi/user/get_credits/1/1.1?username=%1&password=%2',
                                    BulkSMSSetup.UserName,
                                    BulkSMSSetup.GetPassword);

        Arguments.RestMethod := Arguments.RestMethod::get;                                    
    end;

    local procedure CallWebService(var Arguments: Record RESTWebServiceArguments temporary) Success : Boolean
    var
        RESTWebService: codeunit RESTWebServiceCode;
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure TestAndSaveResult(var Arguments: Record RESTWebServiceArguments;var BulkSMSSetup: Record BulkSMSSetup)
    var
        Response: Text;
        StatusCode: Text;
        StatusText: Text;
        SeparatorPos: Integer;
    begin
        Response := Arguments.GetResponseContentAsText();

        SeparatorPos := StrPos(Response,'|');
        if SeparatorPos = 0 then
            Error('Invalid response value:\%1',Response);

        StatusCode := CopyStr(Response,1,SeparatorPos-1);
        StatusText := CopyStr(Response,SeparatorPos+1);

        if StatusCode <> '0' then
            Error('Get Credits failed!\Statuscode: %1\Description: %2',StatusCode,StatusText);

        Evaluate(BulkSMSSetup.Credits, StatusText, 9);
        BulkSMSSetup.CreditsCheckedAt := CurrentDateTime;
        BulkSMSSetup.Modify;
    end;

}