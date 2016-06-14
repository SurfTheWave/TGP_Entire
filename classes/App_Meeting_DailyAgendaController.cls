/*************
@author : Ezdhan Hussain S.K
@ description : Daily Agenda class,Executes Mon-Fri
get events scheduled for that day and passes to apex component to send daily agenda mail
***************/
public without sharing class App_Meeting_DailyAgendaController {
public list<Approval_meeting__c> all_scheduledmeeetings{set;get;}
public list<Meeting_Lync_Details__c> list_meetingdetails{set;get;}
public list<Opportunity_Teams__c> oppteamroles{set;get;}
public string month_Day{set;get;}
public string supScriptVal{set;get;}
public string month{set;get;}
public boolean hasevents{set;get;}
public boolean noevents{set;get;}
public string finaldateval{Set;get;}
/****************
@method :App_Meeting_DailyAgendaController
@ parameters : 
none
@return type :
@Description :This method is a contracter of App_Meeting_DailyAgendaController
*******************/
    public App_Meeting_DailyAgendaController(){
       loadMailTemplate();
    }
    /**************
    Method invoked from page action
    @logic : method queries events and supplies records needed for table in component
    @input : none
    @output : none 
    *******************/
    public void loadMailTemplate(){
    
    Datetime d =System.now();
    //List<event> events_queried = new list<event>();
    Datetime dt = (DateTime)d; 
    string day= dt.format(UtilConstants.DATE_FORM);
    DateTime dt1=System.now();
    
    String str=dt1.format(UtilConstants.EEEE);
    supScriptVal= UtilConstants.TH;
    if(Str.equalsignorecase(UtilConstants.FRIDAY)){
    dt = dt.addDays(3);
        month = dt.format(UtilConstants.MNTH_DATE1);
        month_Day = dt.format(UtilConstants.MNTH_DATE);
    }
    else{
        dt = dt.addDays(1);
        month = dt.format(UtilConstants.MNTH_DATE1);
        month_Day = dt.format(UtilConstants.MNTH_DATE);
    }
    set<id> Approvalids = new set<id>();

    list<string> listofmeetingtimes = new list<string>();
//set<id> oppids = new set<id>(); 
    try{
      
       if(Str.equalsignorecase(UtilConstants.FRIDAY)){
           //events_queried = [select id,whatid from event where StartDateTime=NEXT_N_DAYS:3 limit 5000];
           for(event ev : [select id,whatid from event where StartDateTime=NEXT_N_DAYS:3 limit 5000]){
               Approvalids.add(ev.whatid);
           }
       }
       else{
           //events_queried = [select id,whatid from event where StartDateTime=TOMORROW limit 5000];
           for(event ev : [select id,whatid from event where StartDateTime=TOMORROW limit 5000]){
               Approvalids.add(ev.whatid);
           }
       }
       //system.debug('records ::::::::::::'+events_queried);
       
     
     all_scheduledmeeetings = [select id,Scheduled_Meeting_Time__c,Approval_Stage__r.opportunity__c,Approval_Stage__r.approval_stage_type__c,
                               Meeting_Approver__r.name,Approval_Stage__r.Opportunity__r.off__c,Service_Group__c,
                               Approval_Stage__r.Opportunity__r.prime_sdo_lead_dev__c,Geo_Region__c,requestor__r.user__r.timezonesidkey,SG__c,
                               Geo_Unit__c,Client_Name__c,Opportunity__c,BPO_Net_Revenue_Tds__c,Solution_A_New__c,Scheduled_Start__c,Schedule_Time_Dev__c,Scheduled_start_time_dev__c,
                               Approval_stage__r.Opportunity__r.Link_to_SharePoint_Documents__c,Document_link__c,Opportunity_Solution_Lead__c,NRTNew__c
                               From Approval_meeting__c where ID IN:Approvalids AND Meeting_status__c=:UtilConstants.SCHEDULED order by Scheduled_start__c asc limit 5000 ];
     
     
     if(all_scheduledmeeetings.size()>0){
     hasevents = true;
     noevents = false;
        for(Approval_meeting__c a: all_scheduledmeeetings){
            listofmeetingtimes.add(a.Scheduled_Meeting_Time__c);  
            //oppids.add(a.Approval_Stage__r.opportunity__c);                        
        }
       //oppteamroles = new List<Opportunity_Teams__c>();
       //oppteamroles = [select id,name from Opportunity_Teams__c where Opportunity__c IN: oppids AND Name =:'Prime SDO Lead' Limit 1000];
        list_meetingdetails = [select id,name,Conference_ID__c,lync__c,active__c,slot_name_dev__c 
                               from Meeting_Lync_Details__c where Active__c=:true AND 
                               Name Like:listofmeetingtimes order by name asc LIMIT 10 ];
         // system.debug('Lync Details:::::: '+list_meetingdetails );
      }
        else{
         hasevents = false;
         noevents = true;
        }
        }
      catch(exception e){
      all_scheduledmeeetings = new list<Approval_meeting__c>();
      //system.debug('catch block in template page');
      }
            
      //system.debug('Queried Result------------> '+all_scheduledmeeetings);
    }
    }