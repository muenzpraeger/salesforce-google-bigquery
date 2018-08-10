public class GoogleAuthProvider {

    private String accessToken;
    private String errorMessage;

    public GoogleAuthProvider() {
    }

    public Boolean authorize() {
        try {
            List<Google_Oauth2__mdt> mdts = [SELECT Issuer__c, PKCS8__c FROM Google_Oauth2__mdt LIMIT 1];

            if (mdts.size()==0) {
                this.errorMessage = 'No custom metadata type record found for authorization';
                return false;
            }

            Google_Oauth2__mdt mdt = mdts.get(0);
            String issuer = mdt.Issuer__c;
            String privateKey = mdt.PKCS8__c;
            privateKey = privateKey.replace('\\n', '');

            JWT jwt = new JWT('RS256');
            jwt.pkcs8 = privateKey;
            jwt.iss = issuer;
            jwt.aud = 'https://accounts.google.com/o/oauth2/token';
            jwt.sub = issuer;
            Map<String,String> claims = new  Map<String,String>();
            claims.put('scope','https://www.googleapis.com/auth/bigquery');
            jwt.claims = claims;
            Boolean status = fetchAccessToken('https://accounts.google.com/o/oauth2/token', jwt);
            return status;
        } catch (Exception e) {
            this.errorMessage = e.getMessage();
            return false;
        }
    }

    private Boolean fetchAccessToken(String tokenEndpoint, JWT jwt) {
        String access_token = null;
        String body = 'grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=' + jwt.issue();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenEndpoint);
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        Http http = new Http();
        HTTPResponse res = http.send(req);

        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    access_token = parser.getText();
                    break;
                }
            }
        } else {
            this.errorMessage = res.getStatus();
            return false;
        }
        this.accessToken = access_token;
        return true;
    }

    public String getAccessToken() {
        return this.accessToken;
    }

    public String getErrorMessage() {
        return this.errorMessage;
    }

}
