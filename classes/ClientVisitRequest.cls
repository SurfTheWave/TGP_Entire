/*****************
@author : Reena Thakre
@description : this class handles following functionalities of  Client vistit sobject for 
Client visit Calendar

1) Creating Client Visit Request event 
2) Update Client Visit Request Event
3) Delete Client visit Request Event 
*******************/
public  without sharing class ClientVisitRequest {

/*** 
@author : Reena Thakre
@description: This methode will create  the Events created based on client visit  request **/
                public void createClientVisitEvents(List<client_visit_request__c> visitL){ 
                
                    
                    List<Event> listEvent=new List<Event>();
                     
                     
                    for(Client_visit_request__C visitList:[select id,Client_name__c,Visit_Date_From__c,Visit_Date_To__c,client__r.name ,
                    Opportunity__r.name,Opportunity__c,Centre_to_be_visited__c,
                    Opportunity_Solution_Architect__c from client_visit_request__c where id in :visitL limit 1000]) { 
                         Event eve=new Event(); 
                         eve.Coordinator__c=UserInfo.getName();
                         eve.StartDateTime= visitList.Visit_Date_From__c;  
                         eve.EndDateTime=visitList.Visit_Date_To__c;                         
                         eve.Subject =visitList.Client_name__c;
                         eve.ownerid = label.ClientVisitCalender_id;
                         eve.Opportunity_name_Dev__c=visitList.Opportunity__r.name;  
                         eve.Opportunity_id_Dev__c=visitList.Opportunity__c;                                 
                         eve.client__c=visitList.Client_name__c;  
                         eve.location=visitList.Centre_to_be_visited__c;  
                         eve.Opportunity_Solution_Lead__c=visitList.Opportunity_Solution_Architect__c;  
                         eve.Whatid=visitList.id; 
                         eve.recordtypeid=label.EventRecordtypeID;
                           listEvent.add(eve);                     
                 
                                    }
                  try{
                 if(ListEvent.size() > 0) {
                 Database.saveResult[] sresult = Database.insert(listEvent,false);    
                    
                 }
                    }catch(DMLException e){                    
                    string exception_caught = string.valueof(e);
                    }
                                   
             } 
 /***
 @author : Reena Thakre
@description: This methode will update  the Events created based on client visit  request **/
             public void updateClientVisitEvents(List<client_visit_request__c> visitL){ 
                    List<Event> listEvent=new List<Event>();
                    Map<id,client_visit_request__c> visitMap=new Map<id,client_visit_request__c>(
                   [select id,Visit_Date_From__c,Visit_Date_To__c,Client__r.name,Name,Client_name__c,
                    Opportunity__r.name,Opportunity__c, Centre_to_be_visited__c, 
                    Opportunity_Solution_Architect__c from client_visit_request__c where id in :visitL limit 1000]);
                                     
                    for(Event eve:[select id, whatid from event where whatid in :visitL limit 1000]) { 
                         eve.Coordinator__c=UserInfo.getName();
                         eve.StartDateTime= visitMap.get(eve.whatid).Visit_Date_From__c;  
                         eve.EndDateTime=visitMap.get(eve.whatid).Visit_Date_To__c;                         
                         eve.Subject =visitMap.get(eve.whatid).Client_name__c;
                       
                         eve.Opportunity_name_Dev__c=visitMap.get(eve.whatid).Opportunity__r.name;  
                         eve.Opportunity_id_Dev__c=visitMap.get(eve.whatid).Opportunity__c;                                 
                         eve.client__c=visitMap.get(eve.whatid).Client_name__c;  
                         eve.location=visitMap.get(eve.whatid).Centre_to_be_visited__c;  
                         eve.Opportunity_Solution_Lead__c=visitMap.get(eve.whatid).Opportunity_Solution_Architect__c;  
                          
                           listEvent.add(eve);                     
                                     }
                                     
                  try{
                 if(ListEvent.size() > 0) {
                database.update(listEvent);            
                 }
                 }catch(DMLException e){                   
                    string exception_caught = string.valueof(e);
                    }

                                      
             }          
 /*** 
 @author : Reena Thakre
@description:This methode will delete update  the Events created based on client visit  request **/    
            public void deleteClientVisitEvents(List<client_visit_request__c> visitL){                                                
                        List<Event> listEvent= [select id from event where whatid in :visitL limit 1000 ];                  
                       try{
                       if(ListEvent.size() > 0) {
                         database.delete(ListEvent);
                       }
                       }catch(DMLException e){                   
                       string exception_caught = string.valueof(e);
            
                    }
                        
                    }
       /* this method will send the email on creation of a request based on the group name */  
       public static void sendEmailonCreate (List<client_visit_request__c> visitL)    {  
                try{
                Id targetID;
                List<String> lstOfUserEmailId = new List<String>();
                List<String> lstOfCCUsersEmailId = new List<String>();                
                String orgWideEmailAddressID=UtilEmail.emailid();
                List<ID>usersID=new List <ID>();
                List<String> CCemail=new List<String>();                
                Messaging.SingleEmailMessage mail;
                List<String>grpNames=new List<String>();
                List<id>groupIDs=new List<id>();
                Map<String, id> grpidMap=new Map<String,Id>();
                Map<id, List<id>> grpMemMap=new Map<id, List<id>> ();
                Map<id,string> emailMap=new Map<id, String>();
                
                Email_Template__c template=Email_Template__c.getValues(UtilConstantsforSWB.CLIENT_VISIT_TEMPLATE);
                id newClient = template.ID__c;
                Email_Template__c template1=Email_Template__c.getValues(UtilConstantsforSWB.CLIENT_VISIT_FEEDBACK_TEMPLATE);
                id newClient1 = template1.ID__c;

                String currentuserid =Userinfo.getuserid();
                String emailid=[select email from user where id =:currentuserid limit 1].email;
                                                            
                Id CCgroupid=[Select Id from Group where name=:UtilConstantsforSWB.CONTACT_CENTER_GROUP limit 1].id;
                              
                for(GroupMember member:[Select UserOrGroupId From GroupMember where GroupId =:CCgroupid limit 100]){
                          String id=member.UserOrGroupId;
                          CCemail.add(id);   
                          system.debug('>>>>>>>>>>>>>CCusers'+CCemail);
                } 
                  
                       
                for(User usr:[select email, firstname,lastname from user where id in:CCemail limit 100]){
                         lstOfCCUsersEmailId.add(usr.email);
                         system.debug('>>>>>>>>>>>>>lstOfCCUsersEmailId'+lstOfCCUsersEmailId);
                }      
                
                                    
                for(client_visit_request__c visits:visitL){
                grpNames.add(visits.Support_Group__c);                  
                }
                    
                    
                for(Group grpID:[Select Id,name from Group where name in:grpNames limit 1000]){
                groupIDs.add(grpID.id);
                grpidMap.put(grpID.name,grpID.id);
                    }
                    
                
                    
                for(GroupMember grpMem :[Select UserOrGroupId, GroupId From GroupMember where GroupId in :groupIDs limit 1000]){                   
                usersID.add(grpMem.UserOrGroupId);                  
                if(grpMemMap.containskey(grpMem.GroupId)){
                List<id> ids=grpMemMap.get(grpMem.GroupId);
                ids.add(grpMem.UserOrGroupId);
                grpMemMap.put(grpMem.GroupId,ids);
                }
                else {
                grpMemMap.put(grpMem.GroupId,new List<id>{grpMem.UserOrGroupId});
                }
                }
                    
                    
                for(User usr:[select email from user where id in:usersID limit 100]){         
                emailMap.put(usr.id,usr.email);
                }

                         
                
                for(client_visit_request__c request : visitL)
                 {       
                          
                          Id GroupId;
                          if(grpidMap.containskey(request.Support_Group__c)&& grpidMap.get(request.Support_Group__c)!=null ){
                          GroupId=grpidMap.get(request.Support_Group__c);
                          }
                          
                          List<id> GroupMemIdList =new List<id>();
                          if(grpMemMap.containskey(GroupId) && grpMemMap.get(GroupId)!=null ){
                          GroupMemIdList=grpMemMap.get(GroupId);
                          }
                          
                          if(GroupMemIdList.size()>0){
                          targetID=GroupMemIdList.get(0);
                           GroupMemIdList.remove(0);
                         }
                         
                         
                          for(id ids:GroupMemIdList){                                                 
                          if(emailMap.containskey(ids) && emailMap.get(ids)!=null ){
                          lstOfUserEmailId.add(emailMap.get(ids));
                          
                          }
                          
                          }
                                              
                          mail = new Messaging.SingleEmailMessage();
                          mail.setTargetObjectId(targetID);                          
                          mail.setWhatId(request.id);
                          system.debug('>>>>>>request.id'+request.id);
                          if(request.Request_status__C=='Completed' ){
                          mail.setCCAddresses(lstOfCCUsersEmailId);
                          mail.setTemplateId(newClient1);
                          system.debug('>>>>>newClient1'+newClient1);
                          }
                          else {
                          lstOfCCUsersEmailId.add(emailid);
                          mail.setCCAddresses(lstOfCCUsersEmailId);
                          mail.setTemplateId(newClient);
                          }
                          mail.saveAsActivity=false;
                          mail.setToAddresses(lstOfUserEmailId);
                          mail.setOrgWideEmailAddressId(orgWideEmailAddressID);
                          if(targetID!=null)
                          Messaging.sendEmail(new Messaging.SingleEmailMessage [] { mail}); 
                          //delete tempContact;
                                                     
                     }                                                              
                    }
                 
                
                Catch(DMLException e)
                {
                 //////System.debug('E==='+e);
                 string s=e.getMessage();
                 } 
             }

           }