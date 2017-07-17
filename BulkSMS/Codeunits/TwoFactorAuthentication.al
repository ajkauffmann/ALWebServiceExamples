codeunit 70063002 TwoFactorAuthentication
{
    [EventSubscriber(ObjectType::Codeunit,1,'OnBeforeCompanyOpen','',true,true)]
    local procedure TwoFactorAuthentication_OnBeforeCompanyOpen()
    var
        UserSetup : Record "User Setup";
        BulkSMSSetup : Record BulkSMSSetup;
        SMSCode : Text;
        MessageText : Text;
        TryAgain : Boolean;
        EnterSMSCode : Page EnterSMSCode;
        UserResponse : Text;
        CodeIsValid : Boolean;
        Counter : Integer;
    begin
        if not GuiAllowed then
            exit;

        if not UserSetup.Get(UserId) then
            exit;

        if not UserSetup.UseTwoFactorAuthentication then
            exit;

        if not BulkSMSSetup.Get() then
            exit;

        SMSCode := Format(Random(100000000));
        MessageText := StrSubstNo('Enter %1 to login in %2',SMSCode,CompanyName);
        
        BulkSMSSetup.SendSMS(UserSetup.PhoneNo,MessageText);
        TryAgain := true;

        while TryAgain do begin
            clear(EnterSMSCode);
            if EnterSMSCode.RunModal <> "Action"::OK then
                error('You canceled the login procedure');
            
            UserResponse := EnterSMSCode.GetSMSCode;

            CodeIsValid := UserResponse = SMSCode;
            Counter += 1;
            TryAgain := (not CodeIsValid) and (Counter < 3);
        end;

        if not CodeIsValid then
            error('You entered an invalid code for %1 times', Counter);

    end;
}