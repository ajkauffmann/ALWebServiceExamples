codeunit 70063001 BulkSMSSendMessage
{
    procedure SendMessage(var BulkSMSSetup: Record BulkSMSSetup;PhoneNo: Text;Value: Text)
    begin
        DoSendMessage(BulkSMSSetup,PhoneNo,Value);
    end;

    local procedure DoSendMessage(var BulkSMSSetup: Record BulkSMSSetup;PhoneNo: Text;Value: Text)
    var
        Arguments: Record RESTWebServiceArguments temporary;
    begin
        ErrorIfNoUserName(BulkSMSSetup);
        ErrorINoPassword(BulkSMSSetup);
        InitArguments(Arguments,BulkSMSSetup,PhoneNo,Value);
        if not CallWebService(Arguments) then
            exit;
        TestResult(Arguments);
    end;

    local procedure ErrorIfNoUserName(BulkSMSSetup: Record BulkSMSSetup)
    begin
        BulkSMSSetup.TestField(UserName);
    end;
    local procedure ErrorINoPassword(BulkSMSSetup: Record BulkSMSSetup)
    begin
        BulkSMSSetup.TestField(PasswordKey);
    end;

    local procedure InitArguments(var Arguments: Record RESTWebServiceArguments temporary; BulkSMSSetup: Record BulkSMSSetup;PhoneNo: Text;Value: Text)
    var
        data: Text;
        password: Text;
        TypeHelper: Codeunit "Type Helper";
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
    begin
        Arguments.URL := 'https://bulksms.vsms.net/eapi/submission/send_sms/2/2.0';
        Arguments.RestMethod := Arguments.RestMethod::post;

        password := BulkSMSSetup.GetPassword();
        data := StrSubstNo('username=%1&password=%2&message=%3&msisdn=%4&want_report=0',
                           TypeHelper.UrlEncode(BulkSMSSetup.UserName),
                           TypeHelper.UrlEncode(password),
                           TypeHelper.UrlEncode(Value),
                           PhoneNo);

        RequestContent.WriteFrom(data);
        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type','application/x-www-form-urlencoded');

        Arguments.SetRequestContent(RequestContent);
    end;

    local procedure CallWebService(var Arguments: Record RESTWebServiceArguments temporary) Success : Boolean
    var
        RESTWebService: codeunit RESTWebServiceCode;
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure TestResult(var Arguments: Record RESTWebServiceArguments)
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

        if not (StatusCode in ['0','1']) then
            Error('Sending SMS message failed!\Statuscode: %1\Description: %2',StatusCode,StatusText);
    end;

}