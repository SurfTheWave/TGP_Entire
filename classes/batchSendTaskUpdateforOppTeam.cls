global class batchSendTaskUpdateforOppTeam implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        date d = system.today().addDays(-3);
        //String query = 'SELECT Route_To__c,Route_To__r.User_Master__r.User__c, Id, Assignment_comments__c, Opportunity__r.sap_om_id__c, Client__c FROM Opportunity_Teams__c where Route_To__c!=NULL AND Opportunity_Team_Member__c = NULL AND LastModifiedDate<=:d';
        String query = 'SELECT Id, WhatId, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate FROM Task where IsClosed=false AND CreatedDate <=:d';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Task> scope) {
         List<Task> inscopeTasks = New List<Task>();
         List<ID> oppTeamIds = new List<ID>();
         List<Opportunity_Teams__c> listToAdd;
         for(Task t : scope)
         {
             if(String.ValueOf(t.WhatId).substring(0,3)=='a54'){
                 inscopeTasks.add(t);
                 oppTeamIds.add(t.WhatId);
             }
         }
         List<Opportunity_Teams__c> teamList = [SELECT Id, Name, Requestor__c,Requestor__r.User__r.name, Needed_By_Date__c,Client__c,Route_To__r.User_Master__r.User__r.Email, Opportunity__c, Route_To__c, Opportunity__r.sap_om_id__c,Opportunity__r.name,Requested_Date__c, Requestor_Comments__c, Approximate_of_FTEs__c,Assignment_comments__c FROM Opportunity_Teams__c where id IN:oppTeamIds];
         Map<id,List<Opportunity_Teams__c>> PendingrequestMap = New Map<id,List<Opportunity_Teams__c>>();
         for(Opportunity_Teams__c t:teamList){
             if(PendingrequestMap.containsKey(t.Route_To__c)){
                 PendingrequestMap.get(t.Route_To__c).add(t);
             }
             else{
                 listToAdd = new List<Opportunity_Teams__c>();
                 listToAdd.add(t);
                 PendingrequestMap.put(t.Route_To__c,listToAdd);
             }
         }
         //update scope;
         sendEmailReminderOnTaskOverDue.SendEmailReminderOnTaskOverDue(PendingrequestMap);
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}