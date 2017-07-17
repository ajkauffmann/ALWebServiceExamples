page 70063002 EnterSMSCode
{
    CaptionML = ENU='Enter SMS Code';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(SMSCode;SMSCode)            
            {
                CaptionML = ENU='Enter the code you received by SMS';
            }
        }
    }

    var
        SMSCode : Text;

    procedure GetSMSCode() : Text
    begin
        exit(SMSCode);
    end;
}