tableextension 70063001 UserSetupExtension extends "User Setup"
{
    fields
    {
        field(70063000;PhoneNo;Text[30])
        {
            CaptionML = ENU='Phone No.';
        }
        field(70063001;UseTwoFactorAuthentication;Boolean)
        {
            captionML = ENU='Use Two Factor Authentication';
        }
    }
}