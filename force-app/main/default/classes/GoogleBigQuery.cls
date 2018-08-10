public class GoogleBigQuery {

    private String projectId; // Project ID from Google BigQuery
    private String datasetId; // Dataset ID from Google BigQuery
    private String tableId; // Table ID from Google BigQuery
    private Boolean isSuccess = false;
    private String response;

    public GoogleBigQuery(String projectId) {
        this.projectId = projectId;
    }

    public GoogleBigQuery(String projectId, String datasetId) {
        this.datasetId = datasetId;
        this.projectId = projectId;
    }

    public GoogleBigQuery(String projectId, String datasetId, String tableId) {
        this.datasetId = datasetId;
        this.projectId = projectId;
        this.tableId = tableId;
    }

    public Boolean add(Object data) {
        GoogleAuthProvider auth = new GoogleAuthProvider(); // Custom Google OAuth Provider
        if (auth.authorize()) {
            Request req = new Request (auth, 'add', projectId, datasetId, tableId);
            req.send(data);
            this.isSuccess = req.isSuccess();
            this.response = req.getResponse();
        } else {
            this.response = auth.getErrorMessage();
        }
        return this.isSuccess;
    }

    public Boolean query(Object data) {
        GoogleAuthProvider auth = new GoogleAuthProvider(); // Custom Google OAuth Provider
        if (auth.authorize()) {
            Request req = new Request (auth, 'query', projectId);
            req.send(data);
            this.isSuccess = req.isSuccess();
            this.response = req.getResponse();
        } else {
            this.response = 'Authentication error';
        }
        return this.isSuccess;
    }

    public Boolean isSuccess() {
        return this.isSuccess;
    }

    public String getResponse() {
        return this.response;
    }

    // Internal class for handling communication with Google BigQuery
    class Request {

        private String accessToken;
        private String requestType;
        private String baseUrl = 'https://www.googleapis.com/bigquery/v2/projects/projectId/';
        private String projectId;
        private String datasetId;
        private String tableId;
        private Boolean isSuccess = false;
        private String response;

        Request(GoogleAuthProvider auth, String type, String projectId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
        }

        Request(GoogleAuthProvider auth, String type, String projectId, String datasetId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
            this.datasetId = datasetId;
        }

        Request(GoogleAuthProvider auth, String type, String projectId, String datasetId, String tableId) {
            this.accessToken = auth.getAccessToken();
            this.requestType = type;
            this.projectId = projectId;
            this.datasetId = datasetId;
            this.tableId = tableId;
        }

        public void send(Object data) {
            String url = '';
            String jsonData = '';

            switch on this.requestType {
                when 'query' {
                    this.baseUrl = this.baseUrl + 'queries';
                }
                when 'add' {
                    this.baseUrl = this.baseUrl + 'datasets/datasetId/tables/tableId/insertAll';
                }
            }

            this.baseUrl = this.baseUrl.replace('projectId', projectId);
            if (datasetId != null) {
                this.baseUrl = this.baseUrl.replace('datasetId', datasetId);
            }
            if (tableId != null) {
                this.baseUrl = this.baseUrl.replace('tableId', tableId);
            }

            jsonData = System.JSON.serialize(data);

            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(this.baseUrl);
            req.setHeader('Content-type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + this.accessToken);
            req.setBody(jsonData);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            this.response = res.getBody();
            if (res.getStatusCode()==200) {
                this.isSuccess = true;
            } else {
                Map<String, Object> errorResponse = (Map<String, Object>)JSON.deserializeUntyped(this.response);
                Map<String, Object> error = (Map<String, Object>)errorResponse.get('error');
                this.response = (String)error.get('message');
            }
        }

        public Boolean isSuccess() {
            return this.isSuccess;
        }

        public String getResponse() {
            return this.response;
        }

    }

    // Class for constructing a simple query
    public class JobsQuery {
        public String query;
    }

    // Class for constructing an insert call
    public class InsertAll {
        String kind = 'bigquery#tableDataInsertAllRequest';
        Boolean skipInvalidRows = false;
        Boolean ignoreUnknownValues = true;
        List<Object> rows = new List<Object>();

        public void addObject(Object data) {
            Map<String, Object> details = new Map<String, Object>();
            details.put('json', data);
            rows.add(details);
        }
    }

}
