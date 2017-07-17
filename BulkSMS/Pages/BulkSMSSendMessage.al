page 70063001 BulkSMSSendMesage
{
    PageType = Card;
    SourceTable = BulkSMSSetup;

    layout
    {
        area(content)
        {
            field(PhoneNo;PhoneNo)
            {
                CaptionML = ENU='Phone No.';
            }
            field(MessageText;MessageText)
            {
                CaptionML = ENU='Message';
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                CaptionML = ENU='Setup';
                Image = XMLSetup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page BulkSMSSetup;
            }
            action(Send)
            {
                CaptionML = ENU='Send';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    SendSMS(PhoneNo,MessageText);
                end;
            }
        }
    }

    var
        PhoneNo: Text;
        MessageText: Text;
    
    trigger OnOpenPage()
    begin
        Reset;
        if not get then begin
            Init;
            Insert;
        end;
    end;
}