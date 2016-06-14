public without sharing class BenchmarkSync_IO_Queue implements Queueable{

        public  List<Payroll__c> inputPayroll;
        public  List<FTE_Details__c> inputFTEDetail;
        public  List<Other_Cost_Details__c> inputOtherCost;
        public  Costing_Request__c inputCostingRequest;
        public  Savepoint svPt;
        //public  List<benchmarkOffering> listOfOfferingService;
        //public  List<BenchMark_Offering_Service__c> listOfBenchOfferingService;
        //public  BenchMark__c benchmarkrecs = new BenchMark__c();
        //public  String serviceGroup = UtilConstants.BLANK;
        //Set<Id> nFTEIds= new Set<Id>();
        public Set<Id> nFTEIds= new Set<Id>();
        public Set<Id> nOCDids= new Set<Id>();
        public Set<Id> nPayrll= new Set<Id>();
        public Set<Id> nCdr= new Set<Id>();
        public Set<Id> nVol= new Set<Id>();
        public Set<Id> oFTEids= new Set<Id>();
        public Set<Id> oOCDids= new Set<Id>();
        public Set<Id> oPayrll= new Set<Id>();
        public Set<Id> oCdr= new Set<Id>();
        public Set<Id> oVol= new Set<Id>();
        public Map<String, String> costdataMap = new Map<String, String>();
        
        /******************************
        Method Name: populateBenchMarkObjs
        Description: Invoke this public method from outside to populate benchmark Objects
        Paramenters: NA
        Return Value: void. 
        *******************************/        
        public BenchmarkSync_IO_Queue(Set<Id> newFTEids,Set<Id> newOCDids, Set<Id> newCdr, Set<Id> newVol, Set<Id> oldFTEids,Set<Id> oldOCDids,Set<Id> oldCdr,Set<Id> oldVol, MAP<String,String>costdata){  
            //populateBenchMarkObjs_IO(nFTEids,nOCDids, nPayrll, nCdr, oFTEids,oOCDids,oPayrll, oCdr, costdataMap);
            nFTEIds = newFteids;
            nOCDids = newOCDids;
           // nPayrll = newPayrll;
            nCdr = newCdr;
            nVol = newVol;
            oFTEids = oldFTEids;
            oOCDids = oldOCDids;
           // oPayrll = oldPayrll;
            oCdr = oldCdr;
            oVol = oldVol;
            costdataMap  = costdata;
            
              
        }
        
        
         /******************************
        Method Name: OppAnalyticCalcQueue
        Description: Execute method of queueable interface. Updates Opportunity
        Paramenters: NA
        Return Value: void. 
        *******************************/
        public void execute(QueueableContext context) {
            BenchmarkSync_IOBPOSync_V2.populateBenchMarkObjs_IO(nFTEids,nOCDids,  nCdr, nVol,oFTEids,oOCDids, oCdr, oVol, costdataMap);
        }
}