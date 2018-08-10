public class GoogleUiController {

    @AuraEnabled
    public static String runBigQuerySql(String sql){
        String projectId = 'bigquery-sf-muenzpraeger';

        GoogleBigQuery google = new GoogleBigQuery(projectId);
        GoogleBigQuery.JobsQuery query = new GoogleBigQuery.JobsQuery();
        query.query = sql;
        if (!google.query(query)) {
            throw new AuraHandledException('Error when Querying: ' + google.getResponse());
        }
        return google.getResponse();
    }

}
