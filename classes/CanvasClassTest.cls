/******************************
   @Author       : Jyotsna
   @Class name   : CanvasClassTest
   @CreateDate   : 1-July-2015
   @Description : Test class for CanvasClass 
   @Version : 1.0 
*******************************/
@isTest

private class CanvasClassTest{
     /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON() {
         Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         System.debug('+++++ONUSERInsertion'+u.User_Type__c);
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        costingReq.Is_Checked_Out__c = true;
        DateTime timeins = DateTime.newInstance(2013,03,03,08,08,08);
        costingReq.Sync_Initiated_Time__c=timeins;
        update costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           cc.getHostUrl();
           cc.checkin();
           cc.checkout();
           cc.saveRecord();
           cc.forceCheckIn();
           cc.clearPrevData();
           cc.showUpdates();
           //cc.renderBPOIO();
        test.stopTest();
        }
    }
    
    /******************************
     * Method Name: testJSON1
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON1() {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
         Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
         offProc.Service_Group__c = 'BPO';
         insert offProc;
        
         Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
         insert customSetting;  
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         insert TestOpportunity;
         List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Solution_Scope__c solComp;
            
            solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = TestOpportunity.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
            insert solComp;
            opportunity oppr = [Select Id,Name,sap_om_id__c,Account.name,Contract_Start_Date__c,Contract_End_Date__c,Initial_Go_live_Date__c,OperatingGroup__r.name,Geo_Area__c,Fast_Track_Component__c,( Select Id,Name,Solution_Component__c,Offering_Master__r.name from Solution_Components__r ),( Select Id,Name,Opportunity_Team_Member__c from Opportunity_Team__r ) from Opportunity where Id=:TestOpportunity.Id limit 1 ];
            system.debug('***********'+oppr.Solution_Components__r );
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        costingReq.country__c = 'India';
        update costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           
        test.stopTest();
        
    }
    /******************************
     * Method Name: testJSON2
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testJSON2() {
         Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UTIL_DataCreationForTestClass.getProfile('Solution Admin');
         User u = UTIL_DataCreationForTestClass.getUserWithProfile(p,'yetre@asad.com');
         insert u;
         User_Master__c userMaster = new User_Master__c(User__c=u.id,Active__c=true,email__c='test.123=test@test.com');
         insert userMaster;
         system.runAs(u){
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
         Offering_Master__c offProc=UTIL_DataCreationForTestClass.getOfferingwithSourceProcurement();
         offProc.Service_Group__c = 'BPO';
         insert offProc;
        
         Offering_Name__c customSetting=UTIL_DataCreationForTestClass.getofferingCustom(offProc.name,offProc.id);
         insert customSetting;  
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         insert TestOpportunity;
        
         Opportunity_Roles_Master__c opprolemas = new Opportunity_Roles_Master__c(Name='Test',Role_Level__c='Opportunity');
         insert opprolemas;
         
         List < Solution_Scope__c > solCompList = new List < Solution_Scope__c > ();
            Solution_Scope__c solComp;
            
            solComp = new Solution_Scope__c(Active__c = True, Opportunity__c = TestOpportunity.id, 
                                        Solution_Component__c = 'Delivery', Offering_Master__c = customSetting.Name__c, 
                                        Service_Group__c = 'BPO',  SAP_Offering_Revenue__c = 20);
            insert solComp;
            //Commented by Rahul
          /*  Opportunity_Teams__c oppTeam = new Opportunity_Teams__c(Opportunity__c=TestOpportunity.id,Opportunity_Team_Member__c=userMaster.Id,role__c=opprolemas.id);
            insert oppTeam;
            */
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        costingReq.country__c = 'India;USA';
        costingReq.Is_Checked_Out__c = true;
        update costingReq;
        
      //  System.runAs(u) {
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.getgenerateJSONContent();
           
        test.stopTest();
            
        }
    }
    
    /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testCheckIn() {
         Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         system.debug ('>>>>>Line185'+u);
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='uerfg@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
       // cc.checkout();
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.forceCheckIn();
           cc.checkin();
        test.stopTest();
        }
    }
    /******************************
     * Method Name: testCheckInWithSyncInitiatedTime
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testCheckInWithSyncInitiatedTime() {
         Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         system.debug ('>>>>>Line185'+u);
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='uerfg@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        DateTime timeins = DateTime.newInstance(2013,03,03,08,08,08);
        costingReq.Sync_Initiated_Time__c=timeins;
        update costingReq;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        
       // cc.checkout();
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.forceCheckIn();
           cc.checkin();
        test.stopTest();
        }
    }
    
    /******************************
     * Method Name: testJSON
     * Description: test method to test generateJSONContent()
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testException() {
         Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         Database.insert(TestOpportunity);
        Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        Costing_Request__c csToUpdate = [Select id,name,contract_start__c,contract_end__c from costing_request__c where id=:costingReq.Id];
        csToUpdate.contract_start__c = system.today();
        csToUpdate.contract_end__c = system.today();
        pg.getParameters().put('id', csToUpdate.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(csToUpdate);
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.checkout();
        test.stopTest();
        }
    }
    /******************************
     * Method Name: testDataBPO
     * Description: test method to test with BPO Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataBPO(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         //TestOpportunity.BPO_Net_Rev_Thousands__c=128.00;
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Date d1 = Date.newInstance(1996,01,01);
         costingReq.Contract_Start__c=d1;
         d1 = Date.newInstance(1997,01,01);
         costingReq.Initial_Go_Live__c=d1;
         d1 = Date.newInstance(1998,01,01);
         costingReq.Contract_End__c=d1;
         costingReq.Is_checked_out__c=true;
         update costingReq;
         Opportunity opp = [Select Id,SG_Dev__c from opportunity where id=:TestOpportunity.id];
         opp.SG_Dev__c='BPO';
         update Opp;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        pg.getParameters().put(SWBBPOSEIntegrationConstants.ServiceGroup, 'BPO');
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.editCostingRequest();
           cc.getOptions();
           cc.renderBPOIO();
           cc.selectRenderBPOIOButton();
           cc.checkout();
           cc.cancelRecord();
           test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataIO
     * Description: test method to test with IO Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataIO(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         //TestOpportunity.IO_Net_Revenue_Thousands__c=128.00;
         TestOpportunity.CloseDate = date.today();
         
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Date d1 = Date.newInstance(1996,01,01);
         costingReq.Contract_Start__c=d1;
         d1 = Date.newInstance(1997,01,01);
         costingReq.Initial_Go_Live__c=d1;
         d1 = Date.newInstance(1998,01,01);
         costingReq.Contract_End__c=d1;
         update costingReq;
         Opportunity opp = [Select Id,SG_Dev__c from opportunity where id=:TestOpportunity.id];
         opp.SG_Dev__c='IO';
         update Opp;
         
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        pg.getParameters().put(SWBBPOSEIntegrationConstants.ServiceGroup, 'IO');
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.editCostingRequest();
           cc.getOptions();
           cc.renderBPOIO();
           cc.selectRenderBPOIOButton();
           cc.saveRecord();
           cc.cancelRecord();
           test.stopTest();
     }
     }
     
     /******************************
     * Method Name: testDataIOSaveRecordException
     * Description: test method to test with IO Service Group to save record with Exception
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataIOSaveRecordException(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Admin');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         //TestOpportunity.IO_Net_Revenue_Thousands__c=128.00;
         TestOpportunity.CloseDate = date.today();
         
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,SG_Dev__c from opportunity where id=:TestOpportunity.id];
         opp.SG_Dev__c='IO';
         update Opp;
         
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        pg.getParameters().put(SWBBPOSEIntegrationConstants.ServiceGroup, 'IO');
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.saveRecord();
           test.stopTest();
     }
     }
     
     /******************************
     * Method Name: testDataIOAndIC
     * Description: test method to test with IO + IC Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataIOAndIC(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Date d1 = Date.newInstance(1996,01,01);
         costingReq.Contract_Start__c=d1;
         d1 = Date.newInstance(1997,01,01);
         costingReq.Initial_Go_Live__c=d1;
         d1 = Date.newInstance(1998,01,01);
         costingReq.Contract_End__c=d1;
         update costingReq;
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IC_Net_Rev_Thousands__c=10;
         opp.IO_Net_Revenue_Thousands__c=10;
         update Opp;
         
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.editCostingRequest();
           cc.getOptions();
           cc.renderBPOIO();
           cc.selectRenderBPOIOButton();
          
           cc.cancelRecord();
           test.stopTest();
     }
     }
    /******************************
     * Method Name: testDataBPOAndISServiceGroup
     * Description: test method to test with BPO + IS Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testDataBPOAndISServiceGroup(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.SG_Dev__c='BPO';
         opp.IO_Net_Revenue_Thousands__c=10;
         update Opp;
        PageReference pg = Page.EditCanvas;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           cc.editCostingRequest();
           cc.getOptions();
           cc.renderBPOIO();
           cc.selectRenderBPOIOButton();
          
           cc.cancelRecord();
           test.stopTest();
     }
     }
    /******************************
     * Method Name: testDataIOCostDetailPage
     * Description: This method set CostDetailPage for IO Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
    static testMethod void testDataIOCostDetailPage(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IO_Net_Revenue_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
       
        
        test.startTest();
           CanvasClass cc = new CanvasClass(sc);
           test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataBPOCostDetailPage
     * Description: This method set CostDetailPage for BPO Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataBPOCostDetailPage(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.BPO_Net_Rev_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        test.startTest();
        CanvasClass cc = new CanvasClass(sc);
        test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataIOAndICCostDetailPage
     * Description: This method set CostDetailPage for IO + IC Service Group
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataIOAndICCostDetailPage(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IO_Net_Revenue_Thousands__c=10;
         opp.IC_Net_Rev_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        test.startTest();
        CanvasClass cc = new CanvasClass(sc);
        test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataBPOAndISCostDetailPageSystemAdmin
     * Description: This method set CostDetailPage for BPO + IS Service Group for System Admin
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataBPOAndISCostDetailPageSystemAdmin(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('System Administrator');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IO_Net_Revenue_Thousands__c=10;
         opp.BPO_Net_Rev_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        test.startTest();
        CanvasClass cc = new CanvasClass(sc);
        test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataBPOAndISCostDetailPageIOSolutionEditor
     * Description: This method set CostDetailPage for BPO + IS Service Group for IO SOlution Editor
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataBPOAndISCostDetailPageIOSolutionEditor(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('IO Solution Editor');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         DateTime timeins = DateTime.newInstance(2013,03,03,08,08,08);
         costingReq.Sync_Initiated_Time_IO__c=timeins ;
         update costingReq;
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IO_Net_Revenue_Thousands__c=10;
         opp.BPO_Net_Rev_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        test.startTest();
        CanvasClass cc = new CanvasClass(sc);
        test.stopTest();
     }
     }
     /******************************
     * Method Name: testDataBPOAndISCostDetailPageSolutionOperations
     * Description: This method set CostDetailPage for BPO + IS Service Group for SOlution Operations
     * Paramenters: NA
     * Return Value: NA
     *******************************/ 
     static testMethod void testDataBPOAndISCostDetailPageSolutionOperations(){
      Licence__c lmlst = new Licence__c(Name='Mobilization',No_of_Allocated_Licenses__c=10);
         insert lmlst;
         Profile p = UnitTestDatafactory.getProfile('Solution Operations');
         User u = UnitTestDatafactory.getUserWithProfile(p,'uerfg@test.com');
         insert u;  
         User_Master__c uMaster = new User_Master__c(user__c=u.Id,Active__c=true,email__c='test.123=test@test.com');
         insert uMaster;
         system.runAs(u) {
         
         BPOSE_Matrix__c bpose = new BPOSE_Matrix__c();
         bpose.Name='System Administrator';
         bpose.BPO_Deal__c='E';
         bpose.Bundled_BPO_Deal__c='E';
         bpose.Bundled_IO_Deal__c='E';
         bpose.IO_IC_Deal__c='E';
         bpose.IO_Deal__c='E';
         insert bpose;
         
         Operating_Groups_Master__c TestOperatingGroup = new Operating_Groups_Master__c();
         TestOperatingGroup = UnitTestDatafactory.createOperatingGroup('India'); 
            
         Account TestAccount = new Account (Name = 'TestAccount');
         Database.insert(TestAccount);
         Geo_Region_Master__c geore=new Geo_Region_Master__c(Name='Test',Active__c=true);
         insert geore;
         Opportunity TestOpportunity = new Opportunity();
         TestOpportunity.name = 'TestOpportunity';
         TestOpportunity.AccountId = TestAccount.id;
         TestOpportunity.OperatingGroup__c = TestOperatingGroup.id; 
         TestOpportunity.Actual_Contract_Sign_Date__c =  date.today();
         TestOpportunity.Reporting_Status__c = 'Won';
         TestOpportunity.StageName = '1';
         TestOpportunity.Risk_Level__c = 'High';
         TestOpportunity.CloseDate = date.today();
         TestOpportunity.Geo_Region__c=geore.id;
         TestOpportunity.Country__c='India';
         Database.insert(TestOpportunity);
         Costing_Request__c costingReq = [Select Id from Costing_Request__c  where Opportunity__c=: TestOpportunity.Id];
         DateTime timeins = DateTime.newInstance(2013,03,03,08,08,08);
         costingReq.Sync_Initiated_Time__c=timeins;
         costingReq.In_Progress__c=SWBBPOSEIntegrationConstants.failurestatus;
         update costingReq;
         Opportunity opp = [Select Id,IC_Net_Rev_Thousands__c,IO_Net_Revenue_Thousands__c from opportunity where id=:TestOpportunity.id];
         opp.IO_Net_Revenue_Thousands__c=10;
         opp.BPO_Net_Rev_Thousands__c=10;
         update Opp;
        PageReference pg = Page.costingrequestdetail_page;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id', costingReq.Id);
        Apexpages.StandardController sc = new Apexpages.standardController(costingReq);
        test.startTest();
        CanvasClass cc = new CanvasClass(sc);
        test.stopTest();
     }
     }
     
     
}