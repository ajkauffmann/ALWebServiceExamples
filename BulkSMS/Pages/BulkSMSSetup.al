page 70063000 BulkSMSSetup
{
    PageType = Card;
    SourceTable = BulkSMSSetup;
    CaptionML = ENU='BulkSMS Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General';
                field(UserName;UserName) {}
                field(PasswordTemp;PasswordTemp)
                {
                    CaptionML = ENU='Password';
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        SetPassword(PasswordTemp);
                        Commit;
                        CurrPage.Update;
                    end;
                }
                field(Credits;Credits) {}
                field(CreditsCheckedAt;CreditsCheckedAt) {}
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetCreditsBalance)
            {
                CaptionML = ENU='Get Credits Balance';
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    GetCreditsBalance();
                    CurrPage.Update;
                end;
            }
        }
    }
    
    var
        PasswordTemp : Text;

    trigger OnOpenPage()
    begin
        Reset;
        if not get then begin
            Init;
            Insert;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        if (UserName <> '') and (not IsNullGuid(PasswordKey)) then
            PasswordTemp := '***************';
    end;

}