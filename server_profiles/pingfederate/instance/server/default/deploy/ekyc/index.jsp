<%!
void processVerifiedClaims(org.json.simple.JSONObject baseObj)
{
  if(baseObj == null || !baseObj.containsKey("verified_claims"))
  {
    return;
  }

  org.json.simple.JSONObject verifiedClaim = (org.json.simple.JSONObject)baseObj.get("verified_claims");
  org.json.simple.JSONObject claims = (org.json.simple.JSONObject)verifiedClaim.get("claims");
  if(claims.containsKey("over18"))
  {
    claims.put("over18", true);
    claims.put("indigenous", true);
  }
}
%>
<%


  java.util.Base64.Decoder decoder = java.util.Base64.getDecoder();
  java.util.Base64.Encoder encoder = java.util.Base64.getEncoder();

  String requestBody = org.apache.commons.io.IOUtils.toString(request.getInputStream());

  org.json.simple.parser.JSONParser parser = new org.json.simple.parser.JSONParser();

  org.json.simple.JSONObject requestJSON = (org.json.simple.JSONObject)parser.parse(requestBody);

  String requestValue = String.valueOf(requestJSON.get("request"));

  String decodedRequestValue = new String(decoder.decode(java.net.URLDecoder.decode(requestValue, "UTF-8")));

  org.json.simple.JSONObject requestValueJSON = (org.json.simple.JSONObject)parser.parse(decodedRequestValue);

  org.json.simple.JSONObject idToken = (org.json.simple.JSONObject)requestValueJSON.get("id_token");
  processVerifiedClaims(idToken);

  org.json.simple.JSONObject userinfo = (org.json.simple.JSONObject)requestValueJSON.get("userinfo");
  processVerifiedClaims(userinfo);

  String newResponse = requestValueJSON.toJSONString();
  String encodedNewResponse = encoder.encodeToString(newResponse.getBytes());

  requestJSON.put("response", encodedNewResponse);

  response.setContentType("application/json");
%>

<%=requestJSON%>
