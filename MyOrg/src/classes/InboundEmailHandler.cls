global class InboundEmailHandler implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env){
        
        /*
        //Processing Attachments
        List<Attachment> attachments = new List<Attachment>();
        //Binary Attachment
        for(Messaging.InboundEmail.binaryAttachment binaryAtt: email.BinaryAttachments){
            Attachment attachment = new Attachment();
            attachment.parentId = '';
            attachment.body = binaryAtt.body;            
            attachment.name = binaryAtt.filename;
            attachments.add(attachment);
        }
        //Text Attachment
        for(Messaging.InboundEmail.TextAttachment textAtt: email.TextAttachments){
            Attachment attachment = new Attachment();
            attachment.parentId = '';
            attachment.body = blob.valueof(textAtt.body);
            attachment.name = textAtt.fileName;
            attachments.add(attachment);
        }
        insert attachments;
        */
        
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        return result;
    }
}