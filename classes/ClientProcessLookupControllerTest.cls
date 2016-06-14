/*
    @author     : Madhusudhan 
    @name       : ClientProcessLookupControllerTest 
    @createDate :   
    @description: 
    @version    : V1
*/
@isTest
private class ClientProcessLookupControllerTest {
        private static User testUser;
        
        private static Profile p;
        private static Offering_Master__c offObj;
        /*    
            @name :         setupData
            @description :  set up test data for Custom lookup controller functionality testing
        */    
        public static void setupData(){    
            p = UTIL_DataCreationForTestClass.getProfile(UtilConstants.WORKBENCH_USER);
            testUser = UTIL_DataCreationForTestClass.getUserWithProfile(p,UTIL_DataCreationForTestClass.USER_NAME);
            
            
            offObj = new Offering_Master__c(Name='Offerng test',Service_Group__c='BPO',offering_description__c = 'Test', 
                                                        flywheel_non_flywheel__c = 'Random');
            Database.insert(offObj);
            
            Services_Master__c serviceMaster=new Services_Master__c(Name='test',offering__c=offObj.id);
            Database.insert(serviceMaster);
            
            Services_Component_Master__c ServCompMaster=new Services_Component_Master__c(Name='Ser Comp test',service__c=serviceMaster.id,
                                                                                        service_component_description__c='test Service comp');
            Database.insert(ServCompMaster);
        }
        /*    
            @name :         customLookUPTestMethod
            @description :  Test for customLookUPTest in CustomLookupController 
        */    
        static testMethod void customLookUPTestMethod(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Offering_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
            }
         test.stopTest();
        }
         static testMethod void customLookUPTestMethod1(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod2(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Services_Component_Master__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
            }
         test.stopTest();
        }
        static testMethod void customLookUPTestMethod3(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Client_Specific_Process__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
            }
         test.stopTest();
        }
       static testMethod void customLookUPTestMethod4(){
            
            Test.Starttest();
            setupData();
            system.runAs(testUser){
                   
                PageReference tpageRef = Page.ClientProcessLookupPopup;
                Test.setCurrentPage(tpageRef);
                ApexPages.currentPage().getParameters().put('id', offObj.id);
                ApexPages.currentPage().getParameters().put( 'objName','Delivery_Location_Masters__c');  
                ApexPages.currentPage().getParameters().put(UtilConstants.SEARCHTEXT, UtilConstants.ABCD); 
               
                ClientProcessLookupController clientProcess = new ClientProcessLookupController(); 
                clientProcess.baseQueryOfferingMaster();
                clientProcess.baseQueryServicesMaster();
                clientProcess.baseQueryServicesComponentMaster();
                clientProcess.baseQueryClientSpecificProcess();
                clientProcess.baseQueryDeliveryLocation();
            }
         test.stopTest();
        }
}