pageextension 70062003 BusinessManagerRoleCenterExt extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Setup)
        {
            group(WebServiceExamples)
            {
                CaptionML = ENU='Web Service Exampes';
                group(Examples)
                {
                    CaptionML = ENU='Web Service Examples';
                    Image = LaunchWeb;
                    action(Barcode)
                    {
                        CaptionML = ENU='Barcode';
                        Image = BarCode;
                        RunObject = page BarcodeList;
                    }
                    action(BulkSMS)
                    {
                        CaptionML = ENU='Bulk SMS';
                        Image = SendConfirmation;
                        RunObject = page BulkSMSSendMesage;
                    }
                }
            }
        }
    }
}