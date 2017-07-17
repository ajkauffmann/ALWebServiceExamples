table 70063000 BulkSMSSetup
{
    CaptionML = ENU='BulkSMS Setup';

    fields
    {
        field(1;PrimaryKey;Code[10])
        {
            CaptionML = ENU='Primary Key';
        }
        field(2;UserName;text[250])
        {
            CaptionML = ENU='User Name';
        }
        field(3;PasswordKey;Guid)
        {
            CaptionML = ENU='Password Key';
            Editable = false;
        }
        field(4;Credits;Decimal)
        {
            CaptionML = ENU='Credits';
            Editable = false;
        }
        field(5;CreditsCheckedAt;DateTime)
        {
            CaptionML = ENU='Credits Checked At';
            Editable = false;
        }
    }

    keys
    {
        key(PK;PrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure SetPassword(Value: Text)
    var
        ServicePassword: Record "Service Password";
    begin
        if IsNullGuid(PasswordKey) or not ServicePassword.get(PasswordKey) then begin
            ServicePassword.SavePassword(Value);
            ServicePassword.Insert(true);
            PasswordKey := ServicePassword."Key";
        end else begin
            ServicePassword.SavePassword(Value);
            ServicePassword.Modify;
        end;
    end;

    procedure GetPassword(): Text
    var
        ServicePassword: Record "Service Password";
    begin
        if not IsNullGuid(PasswordKey) then
            if ServicePassword.get(PasswordKey) then
                exit(ServicePassword.GetPassword());
    end;

    procedure GetCreditsBalance()
    var
        BulkSMSGetCreditsBalance: Codeunit BulkSMSGetCreditsBalance;
    begin
        BulkSMSGetCreditsBalance.GetCreditsBalance(Rec);
    end;

    procedure SendSMS(PhoneNumber: Text;Value: Text)
    var
        BulkSMSSendMessage: Codeunit BulkSMSSendMessage;
    begin
        BulkSMSSendMessage.SendMessage(Rec,PhoneNumber,Value);
    end;

}