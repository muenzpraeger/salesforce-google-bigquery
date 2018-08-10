({
    updateDatatable: function(component, response) {
        const jsonResponse = JSON.parse(response);
        let columns = [];
        jsonResponse.schema.fields.forEach(field => {
            var column = {
                label: field.name,
                fieldName: field.name,
                type: 'text',
            };
            columns.push(column);
        });
        component.set('v.columns', columns);
        let rows = [];
        jsonResponse.rows.forEach(row => {
            let data = {};
            columns.forEach((column, index) => {
                data[column.fieldName] = row.f[index].v;
            });
            rows.push(data);
        });
        component.set('v.rows', rows);
    },
});
