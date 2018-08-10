({
    onRunQuery : function(component, event, helper) {
        component.set("v.rows", "");
        var action = component.get("c.runBigQuerySql");
        var query = component.get("v.bigQuerySql");
        action.setParams({
            sql: query
        });
        action.setCallback(this, function(response) {
            if (response.getState()==='SUCCESS') {
                helper.updateDatatable(component, response.getReturnValue());
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error",
                    "message": response.getError()[0].message
                });
                toastEvent.fire();
                component.set("v.rows","nada");
            }
        });
        $A.enqueueAction(action);
    }
})
