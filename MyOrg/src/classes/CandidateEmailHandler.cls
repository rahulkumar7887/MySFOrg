//Email Handler, copy this code from email service. attacch this class with candidate service(Email Service)
global class CandidateEmailHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          //Addd below code for business logic
          String emailBody = EncodingUtil.urlDecode(email.plaintextbody,'UTF-8');
          List<String> cdata = emailBody.split(',');
          Candidate__c newC = new Candidate__c();
          newc.first_name__c = cdata.get(0);
          newc.last_name__c = cdata.get(1);
          newc.city__c = cdata.get(2);
          try{
              insert newC;
              /*List<Attachment> atList = new List<attachment>();
              List<Messaging.InboundEmail.Textattachment> emailAtts = email.textAttachments;
              for(Messaging.InboundEmail.Textattachment eAttch: emailAtts){
                  Attachment at = new Attachment();
                  at.name = eAttch.fileName;
                  at.body = Blob.Valueof(eAttch.Body);
                  at.parentId = newC.id;
                  atList.add(at);
              } 
              insert atList;*///for email outbound commenting this lines
              result.success=true;
          }catch(System.Exception e){
              system.debug(e.getMessage());
              result.success=false;
          }
          return result;
      }
  }