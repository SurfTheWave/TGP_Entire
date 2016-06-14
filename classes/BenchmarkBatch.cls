/********************
@author : Ezdhan
@Class Name : BenchmarkBatch
@description : This class is to convert existing future benchmark process
                into chunks, as existing process is consuming more heap.
*************************/
public class BenchmarkBatch implements Database.batchable<list<sobject>>,Database.Stateful{
	/*******************
	Parameters declarion
	****************************/
	 list<list<sobject>> datalist;
	 string Opportunityid;
     string costingId;
     boolean issuccess =false ;
     map<string,string> costingdata;
     map<string,benchmark__c> existingbenchmarkMap;
	/**********declaration end************/
    /*****************
        Constructor
        Input Params : new fte records, new other cost records, cost data mapm opportunity id
    *******************/
    public benchmarkBatch (list<fte_Details__C> ftes,list<other_Cost_Details__C> ocds,MAP<String,String>costdatamap,string oppid){
        datalist.add((List<sObject>) ftes);
        datalist.add( (List<sObject>) ocds);
        Opportunityid =oppid;
        costingdata = costdatamap;
        /********************
        	query existing benchmark records (if any) and pouplate in respective maps,
        ***********************/   
    }
    public Iterable<list<sObject>> start(Database.BatchableContext bc) {
         //system.debug('datalist--'+datalist.size());
        return  datalist;
    }
    public void execute(Database.BatchableContext bc, List<list<sObject>> scope) {
    	list<fte_details__c> ftelist = new list<fte_details__c>();
        list<Other_cost_details__c> ocdlist = new list<Other_cost_details__c>();
        try{
        	existingbenchmarkMap = new map<string,benchmark__c>();
	        for(benchmark__c bnc : [select id,Service_Group__c from benchmark__C where opportunity__c=:Opportunityid AND Is_Transient__c =true limit 1]){
	        	existingbenchmarkMap.put(bnc.Service_Group__c,bnc);
	        }
	    	if(scope[0].size()>0 ){
	                if(scope[0] instanceof list<fte_details__c>){
	                    ftelist  = ((list<fte_details__c>)scope[0]);
	                }
	                if(scope[0] instanceof list<Other_cost_details__c>){
	                    ocdlist = ((list<Other_cost_details__c>)scope[0]);
	                }
	          }
	          if(scope.size()>1){
	                if(scope[1].size()>0 ){
	                    if(scope[1] instanceof list<fte_details__c>){
	                        ftelist  = ((list<fte_details__c>)scope[1]);
	                    }
	                    if(scope[1] instanceof list<Other_cost_details__c>){
	                        ocdlist = ((list<Other_cost_details__c>)scope[1]);
	                    }                    
	                }
	          }
	       if(ftelist.size() >0){
	       		for(fte_Details__c fte: [SELECT Activity_Description__c,Delivery_Location_Dev__c,Career_Level__r.Name,Service__r.Services__r.name,
	       									Sub_Service_Group__r.Offering_Master__r.name,Bill_Code__c,Baseline_FTEs__c, Career_Level__c,
	       									Career_Track__c,Country__c,Country__r.Name,Costing_Type__c,Economic_Profile__c,
	                                        Load_Type__c,Location_typeCode__c,Location_typeName__c,Language__c,Opportunity__c,Phase__c,Pyramid_Richness__c,Rate_Type__c,
	                                        Resource_Group__c,Role_Master__c,Service_Component_Name__c,Service_Component__c,Service_Group__c,
	                                        Service_Name__c,Service__c,Service__r.Serv_Nm__c,Sub_Service_Group_Name__c,Sub_Service_Group__c,
	                                        Sub_Service_Group__r.Name,Y1_Dev__c,Y2_Dev__c,Y3_Dev__c,Y4_Dev__c,Y5_Dev__c,
	                                        Y6_Dev__c,Y7_Dev__c,Y8_Dev__c,Y9_Dev__c,Y10_Dev__c,Mob_Cost__c,Run_Yr1__c,Run_Yr2__c,Run_Yr3__c,Run_Yr4__c,Run_Yr5__c,Run_Yr6__c,Run_Yr7__c, 
	                                        Run_Yr8__c,Run_Yr9__c,Run_Yr10__c,Mob_Totals__c,FTEYr1__c,FTEYr2__c,FTEYr3__c,FTEYr4__c,FTEYr5__c,FTEYr6__c,FTEYr7__c,
	                                        FTEYr8__c,FTEYr9__c,FTEYr10__c,FTEMobTotals__c,Mobilization_Start_Date__c,Go_Live_Date__c,Delivery_Location__r.Name,
	                                        Column4__c,FTE_TYPE__c,Opportunity_Delivery_Location__r.Delivery_Location__r.name,Costing_Request__r.Opportunity__c,Final_Month_FTE__c, 
	                                        Service__r.Delivery_Locations__c, Transformation_Totals__c
	                                        FROM FTE_Details__c where id in :ftelist LIMIT 5000]){
	       		
	       		}
	       }
        }
        catch(exception e){
        
        }
     }
    public void finish(Database.BatchableContext bc) {
      
    }
}