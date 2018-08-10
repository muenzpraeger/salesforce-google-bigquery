public class Futures {

    public Futures() {
    }

    @future(callout=true)
    public static void sendOrderToGoogleBigQuery(Id orderId) {
        String projectId = 'bigquery-sf-muenzpraeger';
        String datasetId = 'OrderHistory';
        String tableId = 'Salesforce';

        // Get Order record
        List<Order> orders = [SELECT OrderNumber, Status, TotalAmount FROM Order Where Id =: orderId];

        if (orders.size()>0) {
            // Setup connector
            GoogleBigQuery google = new GoogleBigQuery(projectId, datasetId, tableId);
            GoogleBigQuery.InsertAll insertAll = new GoogleBigQuery.InsertAll();
            insertAll.addObject(orders.get(0));
            if (!google.add(insertAll)) {
               System.debug('Error: ' + google.getResponse());
            }
        }
    }

}
