public class BookDetails {

    public Book__c merch { get; set; }
    
    public BookDetails() {
        this.merch = getBook();
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Book__c.FieldSets.BookFieldSet.getFields();
    }

    private Book__c getBook() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Book__c LIMIT 1';
        return Database.query(query);
    }
}