trigger OrderTrigger on Order (after update) {

    for (Order order : Trigger.New) {
        Futures.sendOrderToGoogleBigQuery(order.Id);
    }

}
