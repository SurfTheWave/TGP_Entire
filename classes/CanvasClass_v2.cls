/**
   @Author : Jyotsna Yadav
   @name   : CanvasClass
   @CreateDate : 09 June 2015 
   @Description : Send the parameters to BPOSE through canvas.
   @Version : 1.0 
   */
public with sharing class  CanvasClass_v2 {
    /**
   *  @name : getHostUrl
   *  @Description : getHostUrl
   *  @param : NA
   *  @return parameter - string
   *  @throws exception- NA
   */
    public String getHostUrl(){
        return System.URL.getSalesforceBaseURL().toExternalForm(); 
    }
    public  Costing_Request__c costingRequest{get;set;}
    private Opportunity opportunity;
    public String paramList{get;set;}
    private String emailId;
    public Boolean access{get;set;}
    public boolean ischeckout{set;get;}
    public Id costingId;
    public Id userid{set;get;}
    public boolean showeditblock{set;get;}
    public boolean hideeditblock{set;get;}
    public boolean ischeckin{set;get;}  
    public Boolean isSynced{get;set;}
    public Boolean hasUpdated{get;set;}
    public static String showUpdate{get;set;}
    public Boolean isError{get;set;}
    private User_Master__c userMaster;
    public boolean failureerror{Set;get;}
    public boolean showresetblock{set;get;}
    public Boolean bpoRendered{get; set;}
    public Boolean ioRendered{get; set;}
    public String selectedRadio{get; set;}
    public List<selectOption> getOptions(){
        List<selectOption>  options = new List<SelectOption>();
        options.add(new SelectOption('BPO', 'BPO'));
        options.add(new SelectOption('IO', 'IO'));
        return options;
    }
    /*
    public Boolean bpoRendered {get; 
        set{
            bpoRendered  = false;
        }
    }
    public Boolean ioRendered{
        get;
        set{
            ioRendered = false;
        }
    }
    */
   // public Boolean isSync{get;set;}
    /*Outer class constructor*/
     public CanvasClass_v2 (ApexPages.StandardController stdController) {
         bpoRendered = false;
         ioRendered = false;
         costingId = stdController.getId();
         access = false;
         isSynced = false;
         hasUpdated = failureerror = false;
         showUpdate ='';
         
         checkCheckOut();
         
    }
   
     /**
   *  @name : renderBPOIO
   *  @Description : renderBPOIO : as part of release 3.5 BPO IO Sync
   *  @param : NA 
   *  @return parameter - string
   *  @throws exception- NA
   */
    
    public void selectRenderBPOIO(){
           if(selectedRadio == 'BPO'){
                 bpoRendered = true;
                 ioRendered = false;
           }
           else if(selectedRadio == 'IO'){
               bpoRendered = false;
               ioRendered = true;
           }
    }
    
    
    public void selectRenderBPOIOButton(){
           if(!bpoRendered ){
                 bpoRendered = true;
                 ioRendered = false;
           }
           else{
               bpoRendered = false;
               ioRendered = true;
           }
    }
     /**
   *  @name : renderBPOIO
   *  @Description : renderBPOIO : as part of release 3.5 BPO IO Sync
   *  @param : NA 
   *  @return parameter - string
   *  @throws exception- NA
   */
    
    public void renderBPOIO(){
        //String profile = UserInfo.getProfileId();
        Profile p = [SELECT Id , Name FROM Profile WHERE Id = : UserInfo.getProfileId() LIMIT 1];
        
        if(costingRequest.opportunity__r.Service_Grp__c == 'IO'){
            ioRendered = true;
            bpoRendered = false;
        }
        else if(costingRequest.opportunity__r.Service_Grp__c == 'BPO'){
            ioRendered = false;
            bpoRendered = true;
        }
        else if(p.Name == 'Solution Editor' || p.Name == 'Solution Operations' || p.Name == 'Solution Read Only' || p.Name == 'Solution Manager' ){
                ioRendered = false;
                bpoRendered = true;
        }
        else{
            
            System.debug('p.Name ' + p.Name);
            if(p.Name == 'IO Solution Editor' || p.Name == 'IO Solution Operations' || p.Name == 'IO Solution Read Only' ){
                ioRendered = true;
                bpoRendered = false;
            }
            
            
            /*
            else if(p.Name == 'System Administrator'){
                ioRendered = true;
                bpoRendered = true;
            }
            */
        }
        
        
    }
    
    /* Method to restrict two updates at the same time */
    public void checkCheckOut(){
        try{
            
        hasUpdated = false;
        isError = false;
         costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,version__c,In_Progress__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           Synced_Scenario_Name_IO__c, Version_IO__c,Last_Synced_Date_IO__c,Last_Synced_Up_By_IO__c,MRDB_Last_Refresh_Date_IO__c ,
                           MRDB_Version_IO__c,Last_IDL_Generated_Scenario__c,Last_IDL_Generated_Version__c,IDL_Generated_UTC_Date__c,Last_IDL_Generated_User__c,Checked_Out_By_IO__c,
                           opportunity__r.Service_Grp__c, 
                           MRDB_Version__c from Costing_Request__c where ID =:costingId limit 1];
           // isSync = costingRequest.In_Sync__c;
         system.debug('*********'+costingRequest );
         renderBPOIO();
         decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }
         opportunity = [Select Id,Is_Synced__c,Name,sap_om_id__c,Account.name,geo_region__r.name,Contract_Start_Date__c,Contract_End_Date__c,
                        Initial_Go_live_Date__c,OperatingGroup__r.name,Geo_Area__c,Fast_Track_Component__c,
                        ( Select Id,Name,Solution_Component__c,Offering_Master__r.name from Solution_Components__r 
                         where Offering_Master__r.name != :UtilConstants.All  LIMIT 200),( Select Id,Name,Opportunity_Team_Member__c from Opportunity_Team__r  LIMIT 200) 
                        from Opportunity where Id=:costingRequest.Opportunity__c limit 1];
          system.debug('*********'+opportunity.solution_components__r);
            userid =userinfo.getUserid();
            isSynced = opportunity.Is_Synced__c; 
          userMaster = [Select email__c,profile__c,id,name from User_Master__c where user__c=:userid limit 1];
          emailID = userMaster.email__c;
         Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()  LIMIT 1];
         if(costingRequest.In_Progress__c=='0'){
            failureerror = true;
         }
         if( p.name.equalsignorecase(UtilConstants.SYSTEM_ADMIN)||p.name.equalsignorecase(UtilConstants.WORKBENCH_OPERATOR)){
             access = true;
          }
          if( p.name.contains('Operations')|| p.name.contains('Admin')){
             access = true;
          }
         if(!access){
             Set<Id> userMasterSet = new Set<Id>();
             for( Opportunity_Teams__c oppTeam : opportunity.Opportunity_Team__r ){
                 userMasterSet.add( oppTeam.Opportunity_Team_Member__c );
             }
            for( User_Master__c userMaster : [Select Id,Name,User__c from User_Master__c LIMIT 5000] ){
                 if(userMasterSet.contains( userMaster.Id )){
                     if( userid.equals( userMaster.User__c ) ){
                         access = true;
                         break;
                     }
                 }
             }
         }
         Map<String, Read_Access_Profiles__c> allProfiles= Read_Access_Profiles__c.getAll(); 
         if(allProfiles.containsKey(p.name)){
             access = false;
         }
            if(costingRequest.Is_checked_out__c){
                    ischeckout = true;
                            
             }
                else{
                    ischeckout = false;
                              
                }
                
                if(costingRequest.Is_checked_out__c && costingRequest.Last_Checked_Out_By_Dev__c == userid ){
                    showeditblock = false;
                    hideeditblock = true;
                    ischeckin = true;        
                } 
                 else{
                     showeditblock = true;
                    hideeditblock = false;
                     ischeckin = false;
                 }
        }catch(Exception E){
             ApexPages.addMessages(e);
        }
             
    }
   /* Method for check-in functionality */ 
     public pagereference checkin(){
    system.debug('=========='+costingRequest.Is_checked_out__c);
    costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,version__c,In_Progress__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           MRDB_Version__c from Costing_Request__c where ID =:costingId limit 1];
            decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }
        if(costingRequest.Is_checked_out__c){
            costingRequest.Is_checked_out__c = false;
            costingRequest.Last_Checked_Out_By_Dev__c = UtilConstants.EMPTY_STRING;
            costingRequest.Checked_Out_By__c = null;
            try{
                update costingRequest;
             }catch(Exception E){
                ApexPages.addMessages(e);
             }
             Pagereference pr = page.CostingRequestDetail_Page;
             pr.getParameters().put(UtilConstants.id_par,costingRequest.id);
             pr.setRedirect(true);
             checkCheckOut();    
             return pr;
        }
         else{
             if(costingRequest.LastModifiedById == userid){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'The same record is already checked in by you from different browser.'));
             }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'The same record is force checked in.')); 
             }
             
             return null;
         }
         
      
     return null;
    }
    
    /* method for check-out functionlaity */
      public pagereference CheckOut(){
    costingRequest = [Select In_Sync__c ,Sync_Initiated_Time__c,client__c,Id,Checked_Out_By__c,LastModifiedById ,Sync_Failed_At__c,Data_Cleaning_dev__c,Is_BDL_Updated_Dev__c,SSM_Version__c,version__c,In_Progress__c,
                           Has_Updated__c ,calculation__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,
                           Last_BDL_Generated_User__c,Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,
                           name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,Initial_Go_Live__c,Allow_Deal_Customization__c,
                           Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,MRDB_Last_Refresh_Date__c,
                           MRDB_Version__c from Costing_Request__c where ID =:costingId limit 1];
     decimal d;
         if(costingRequest.Sync_Initiated_Time__c != null){
            d = (system.now().gettime()/1000/60) - (costingRequest.Sync_Initiated_Time__c.gettime()/1000/60);
         }
         system.debug('time gap --->'+d);
        if(d >10){
            showresetblock = true; 
         }
         else{
            showresetblock = false; 
         }                     
     costingRequest.Is_checked_out__c = true;
     costingRequest.Last_Checked_Out_By_Dev__c =userid  ;
     costingRequest.Checked_Out_By__c = userMaster.Id;
     costingRequest.has_updated__c=false;
     if(costingRequest.in_progress__c !='2'){
         costingRequest.calculation__c = false;
         costingRequest.In_sync__c = false;
     }
     //costingRequest.In_Progress__c = '7';
     //costingRequest.IsCheckedOutPage__c = true;
     try{
        update costingRequest;
        system.debug('after update is called value is==='+costingRequest.Is_checked_out__c);
     }catch(Exception E){
        ApexPages.addMessages(e);
     }
      Pagereference pr = page.EditCanvas;
      pr.getParameters().put(UtilConstants.id_par,costingRequest.id);
       pr.setRedirect(true); 
        checkCheckOut();   
     return pr;
    }
    
    /*Inner class to set the parameters. */        
    public without sharing class WrapperLabelClass{
        private string pagename; 
        private string enterpriseid;
        private string opportunityid;
        private Boolean IsDealEditableForUser;
        private Boolean IsDealCustomizable,IsOpportunityCheckedOut;
        private Boolean whatif;
        private Integer IsSyncInProgress;
        private Integer SAPOMID;
        private string OpportunityName;
        private string clientname;
        private Date contractstartdate;
        private Date contractenddate;
        private Date golivedate;
        private string OG;
        private string Salesgeography;
        private List<String> Offerings;
        private List<String> CountriesInScope;
        private String AuthToken;
        private String InstanceURL;
        /* Constructor of inner class */
        public  WrapperLabelClass(opportunity opportunity,String emailID,Boolean access,Costing_Request__c costingRequest, Boolean bpoRendered, Boolean ioRendered){
            //InstanceURL = ApexPages.currentPage().getHeaders().get('Host');  
            if(bpoRendered=True){
            pagename='Deal';
            } else if (ioRendered=True){
            pagename='IODeal';}
            enterpriseId = emailId.split(UtilConstants.AT_THE_RATE_OF)[0];
            if(enterpriseId.contains('=')){
                enterpriseId = enterpriseid.split('=')[0];
            }
            
            opportunityId = opportunity.Id;
            isDealEditableForUser = access;
            isDealCustomizable = costingRequest.Allow_Deal_Customization__c;
            whatIf = false;
            if(opportunity.sap_om_id__c!=null){
              SAPOMID = Integer.valueof(opportunity.sap_om_id__c);
            }else{
                SAPOMID = 0;
            }
            IsSyncInProgress = Integer.valueof(costingRequest.In_Progress__c);
            opportunityName = opportunity.name;
            if(opportunityName.contains('"')){
                opportunityName = opportunityName.replace('"','&quot;');
            }
            system.debug('final opportunity name '+opportunityName);
            clientName = opportunity.Account.name;
            if(clientName!= null && clientName.contains('"')){
                clientName = clientName.replace('"','&quot;');
            }
            contractStartDate = costingRequest.Contract_Start__c;
            contractEndDate = costingRequest.Contract_End__c;
            goLiveDate = costingRequest.Initial_Go_Live__c;
            OG = opportunity.OperatingGroup__r.name;
            //SalesGeography = opportunity.Geo_Area__c;
            SalesGeography = opportunity.Geo_Region__r.name;
            countriesInScope = new List<String>{costingRequest.Country__c.replace(UtilConstants.SEMICOLON_STRING,UtilConstants.COMMA_STRING)};
            Offerings = new List<String>{UtilConstants.BSS,UtilConstants.CROSS,UtilConstants.PMO,UtilConstants.TECHNOLOGY};
            Set<String> offeringSet = new Set<String>();
            for( Solution_Scope__c sc : opportunity.Solution_Components__r ){
                offeringSet.add( sc.Offering_Master__r.name);
               /* if(sc.Solution_Component__c.equalsIgnoreCase(UtilConstants.APPLICATION_MWB)){
                offeringSet.add( sc.Solution_Component__c);
                }else{
                   offeringSet.add(UtilConstants.CROSS); 
                }*/
            }
            offerings.addAll( offeringSet );
            if(costingRequest.Last_Checked_Out_By_Dev__c != null && costingRequest.Last_Checked_Out_By_Dev__c.EqualsIgnoreCase(userInfo.getUserId()) && costingRequest.Is_Checked_Out__c){
                                IsOpportunityCheckedOut =true;
                               // system.debug('if****************************************'+userList.id);
                       }
                      else if(costingRequest.Last_Checked_Out_By_Dev__c != null && costingRequest.Last_Checked_Out_By_Dev__c!=userInfo.getUserId() && costingRequest.Is_Checked_Out__c){
                        //system.debug('else if****************************************'+userList.id);
                                IsOpportunityCheckedOut =false;
                       }
                      else{
                      //  system.debug('else****************************************'+userList.id);
                           IsOpportunityCheckedOut =false;
                       }
            //IsOpportunityCheckedOut = costingRequest.Is_Checked_Out__c;
            AuthToken = userinfo.getSessionID();
            Rest_URL__c rs = Rest_URL__c.getOrgDefaults();
            InstanceURL = rs.Base_URL__c; 
            system.debug('instance URL----------> '+InstanceURL );
        }
     }
     /* Inner class to serialize the parameters */
    without sharing  Class Canvas_Container{  
        WrapperLabelClass Canvas_request;
        /* Constructor for inner wrapper class */
        public Canvas_Container(opportunity opportunity,String emailID,Boolean access,Costing_Request__c costingRequest){
            Canvas_request = new WrapperLabelClass(opportunity,emailId,access,costingRequest,false,false);
        } 
     }
     /* Method to generate the JSON that needs to be sent to BPOSE */
     public String getgenerateJSONContent() {
       try{ 
           Canvas_Container cc = new Canvas_Container(opportunity,emailId,access,costingRequest);        
           paramList = JSON.serialize(cc);
            
            system.debug('____________'+paramList );
            return JSON.serialize(cc);
        }catch( Exception e ){
            ApexPages.addMessages(e);
            return null;
        }
    }
    /* Method to save the record and redirect the page back to detail page of the record */
    public PageReference saveRecord(){
        try{
            update costingRequest;
            PageReference page = new PageReference(UtilConstants.SLASH+costingRequest.Id);
            return page;
        }catch(Exception e){
            String eMsg; 
            isError = true;
            if(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,')){
            String msg = e.getMessage().split('FIELD_CUSTOM_VALIDATION_EXCEPTION,')[1];
            eMsg = msg.split(':')[0];
            }else if(e.getMessage().contains('INSUFFICIENT_ACCESS_OR_READONLY')){
              // String msg = e.getMessage().split('INSUFFICIENT_ACCESS_OR_READONLY')[1];
                eMsg = 'INSUFFICIENT_ACCESS_OR_READONLY - You do not have the permission to edit the record.';
            }else{
                eMsg = e.getMessage();
            }
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,eMsg);
            ApexPages.addMessage(myMsg);
            
           return null;
        }
        
    }
    
     /**
   *  @name : showUpdates
   *  @Description : showUpdates
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public void showUpdates(){
        costingRequest = [Select Id,client__c,In_Sync__c,Sync_Failed_At__c,Data_Cleaning_dev__c,Checked_Out_By__c,LastModifiedById,Is_BDL_Updated_Dev__c,SSM_Version__c,
        version__c,In_Progress__c,calculation__c,has_updated__c,Last_BDL_Generated_Scenario__c,BDL_Generated_UTC_Date__c,Last_BDL_Generated_User__c,
        Last_BDL_Generated_Version__c,Is_checked_out__c,Last_Checked_Out_By_Dev__c,name,opportunity__c,country__c,Contract_Start__c,Contract_End__c,
        Initial_Go_Live__c,Allow_Deal_Customization__c,Synced_Scenario_Name__c,Last_Synced_Date__c,Last_Synced_Up_By__c,Cost_Summary_and_Metrics__c,
        MRDB_Last_Refresh_Date__c,
        Synced_Scenario_Name_IO__c, Version_IO__c,Last_Synced_Date_IO__c,Last_Synced_Up_By_IO__c,MRDB_Last_Refresh_Date_IO__c ,
        MRDB_Version_IO__c,Last_IDL_Generated_Scenario__c,Last_IDL_Generated_Version__c,IDL_Generated_UTC_Date__c,Last_IDL_Generated_User__c,Checked_Out_By_IO__c,
        opportunity__r.Service_Grp__c, 
        MRDB_Version__c 
        from Costing_Request__c where ID =:costingId limit 1];
       // system.debug('@@@@@@@@@@'+costingRequest);
        showUpdate = '<script> refresh(); </script>';
        
     }
      //Method to set the field Is_Checked_Out__c to 'False'
    /**
   *  @name : forceCheckIn
   *  @Description : forceCheckIn
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
    public Pagereference forceCheckIn(){
    if(costingRequest.Is_checked_out__c){
        costingRequest.Is_Checked_Out__c=false;
        costingRequest.Checked_Out_By__c=null;
        costingRequest.Last_Checked_Out_By_Dev__c = null;        
        try{
            update costingRequest;
         }catch(Exception e){
            ApexPages.addMessages(e);
         }
         Pagereference p = page.CostingRequestDetail_Page;
         p.getParameters().put(UtilConstants.id_par,costingRequest.id);
         p.setRedirect(true); 
         checkCheckOut();
         return p;
         }else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'The same record is already checked in'));
             return null;
         }

    } 
    
    //Method to delete the records from Other_Cost_Details__c and FTE_Details__c objects
    /**
   *  @name : clearPrevData
   *  @Description : clearPrevData
   *  @param : NA
   *  @return parameter - NA
   *  @throws exception- NA
   */
      public Pagereference clearPrevData(){
    
        //Retrieves Other_Cost_Details__c records  
         set<id> recordstodelete = new set<id>();
         map<string,string> blankMap = new map<string,string>();        
         try{         
            List<Other_Cost_Details__c> costRecords=new list<other_cost_details__c>();
            costRecords = [SELECT Id FROM Other_Cost_Details__c where Is_Transient__c = true and Costing_Request__c =:costingId LIMIT 5000]; 
            List<FTE_Details__c> fteRecords=new list<fte_details__c>();
            fteRecords = [SELECT Id FROM FTE_Details__c where Is_Transient__c=true and Costing_Request__c =:costingId LIMIT 5000]; 
            integer recsize = fteRecords.size()+costRecords.size();
            for(payroll__c proll : [SELECT Id FROM Payroll__c where Is_Transient__c=true and Costing_Request__c =:costingId LIMIT 5000]){
                recordstodelete.add(proll.id);
            }
            if(recsize != null && recsize  < 7000){
                database.delete(costRecords,true);
                database.delete(fteRecords,true);
                database.executebatch(new DeleteBatchSync(recordstodelete,costingRequest.opportunity__c,'delete',blankMap));       
            }else{
            for(FTE_Details__c fte :fteRecords ){
                recordstodelete.add(fte.id);
            }
            for(other_cost_Details__c ocd : costRecords){
                recordstodelete.add(ocd.id);
            }
              database.executebatch(new DeleteBatchSync(recordstodelete,costingRequest.opportunity__c,'delete',blankMap)); 
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Data is huge. Cleaning of Data is Initiated'));
            }
                Costing_Request__c costingRecord= new costing_request__C();
                costingRecord.id = costingRequest.id;
                costingRecord.In_Sync__c = false;
                costingRecord.Sync_Failed_At__c = '';
                costingRecord.Calculation__c = false;
                costingRecord.Data_Cleaning_dev__c=false;
                //costingRecord.Email_Dev__c='';
                costingRecord.in_progress__c='0';
                
                update costingRecord;
                sync_status__C sync = new sync_status__C();
                sync = [select id,Force_fully_Failed__c,error__C from sync_Status__c where opportunity__c=:costingRequest.opportunity__c limit 1 ];
                sync.Force_fully_Failed__c = true;
                sync.error__C = 'Sync Was Struck for long time, Force Cancelled by Admin';
                update sync;
                //checkCheckOut();
            }catch(Exception e){
                ApexPages.addMessages(e);
                system.debug('exception ---->'+e.getStackTraceString()+'message '+e.getmessage());
            }
            pagereference pr = new pagereference('/'+costingRequest.id);     
            return pr;
    
       }  
    }