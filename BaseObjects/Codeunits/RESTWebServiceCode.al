codeunit 70060000 RESTWebServiceCode
{
  procedure CallRESTWebService(var Parameters : Record RESTWebServiceArguments) : Boolean
  var
      HttpClient : HttpClient;
      AuthHeaderValue : HttpHeaders;
      HttpHeaders : HttpHeaders;
      HttpRequestMessage : HttpRequestMessage ;
      HttpResponseMessage : HttpResponseMessage;
      HttpContent : HttpContent;
      AuthText : text;
      TempBlob : Record TempBlob temporary;
  begin
      HttpRequestMessage.Method := Format(Parameters.RestMethod);
      HttpRequestMessage.SetRequestUri(Parameters.URL);

      HttpRequestMessage.GetHeaders(HttpHeaders);

      if Parameters.Accept <> '' then
          HttpHeaders.Add('Accept',Parameters.Accept);

      if Parameters.UserName <> '' then begin
          AuthText := StrSubstNo('%1:%2',Parameters.UserName,Parameters.Password);
          TempBlob.WriteAsText(AuthText,TextEncoding::Windows);
          HttpHeaders.Add('Authorization', StrSubstNo('Basic %1',TempBlob.ToBase64String()));
      end;      

      if Parameters.ETag <> '' then
          HttpHeaders.Add('If-Match', Parameters.ETag);
      
      if Parameters.HasRequestContent then begin
          Parameters.GetRequestContent(HttpContent);
          HttpRequestMessage.Content := HttpContent;
      end;      

      HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

      HttpHeaders := HttpResponseMessage.Headers;
      Parameters.SetResponseHeaders(HttpHeaders);

      HttpContent := HttpResponseMessage.Content;
      Parameters.SetResponseContent(HttpContent);

      EXIT(HttpResponseMessage.IsSuccessStatusCode);
  end;
}

