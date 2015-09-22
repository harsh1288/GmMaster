/*****************************************
A trigger to set the Account owner to equal the FPM of the country,
before every insert or update, for PR Record Type.

Step 1: Add the Country ids from all the Accounts in the trigger to a set and query for those country records.
Vendor Add-on: Add Account Ids depending on whether the account is a parent or child
Step 2: Create a map between Country ids and FPM ids so that each Country Id is linked to an FPM Id
Step 3: For each Account in the trigger, retrieve the relevant FPM user id using the map and set the owner Id

///ALSO///
This same trigger will synce Vendor fields of an org if it has a parent organization or if it has child orgs

*****************************************/

trigger AccountBeforeInsertUpdate on Account (before insert,before update) {
/*Set<Id> countryIds = new Set<Id>();
set<Id>coWithFPM = new Set<Id>();
Map<Id,Id> mapCountryFPMIds = new Map<Id,Id>();
Id prID = [Select ID from RecordType where SObjectType = 'Account' and Name = 'PR'].Id;
List<Country__c> lstCountries = new List<Country__c>();

//For the Vendor bit
Set<Id> setParentAccIds = new Set<Id>();
Set<Id> setChildAccIds = new Set<Id>();
List<Account> lstParentAccts = new List<Account>();
List<Account> lstChildAcctsToUpdate = new List<Account>();
Map<Id,Id> mapAcctVendorIds = new Map<Id,Id>();


   //Step 1 -- only if PR Record Type
   for (Account acct : Trigger.new) {
     if(acct.RecordTypeId == prID){
      countryIds.add(acct.Country__c); 
      
      //Vendor Add-on: adding Acct Ids based on whether parent or child
      if(acct.ParentId != null && acct.Vendor_ID__c == null){
          setChildAccIds.add(acct.Id);
          setParentAccIds.add(acct.ParentId); }         
      if(!acct.ChildAccounts.isEmpty() && acct.Vendor_ID__c != null){
          setParentAccIds.add(acct.Id); }
      }
    } 

    lstCountries = [Select Id, FPM__c from Country__c where Id in: countryIds AND FPM__c != null];
           
     //Step 2
     for(Country__c co : lstCountries){
       mapCountryFPMIds.put(co.Id,co.FPM__c); 
       coWithFPM.add(co.Id); }
   
   //Step 3   
   for (Account acct : Trigger.new) {
      if(acct.RecordTypeId == prID && acct.Country__c != null && coWithFPM.contains(acct.Country__c)){
      acct.OwnerId = mapCountryFPMIds.get(acct.Country__c); }
      }
      */
   /*   
      
   //Vendor Add-on
   lstParentAccts = [Select Name, Id, Vendor_ID__c, (Select Name, Id, ParentId, Vendor_ID__c from ChildAccounts) from Account where Id in: setParentAccIds];
   for(Account parentAcct : lstParentAccts){
       mapAcctVendorIds.put(parentAcct.Id, parentAcct.Vendor_ID__c);
      
       for(Account childAcct : parentAcct.ChildAccounts){
           System.debug('###' + parentAcct.Name);
           if(mapAcctVendorIds.get(childAcct.ParentId) != null){
               childAcct.Vendor_ID__c = mapAcctVendorIds.get(childAcct.ParentId);
               System.debug('###' + childAcct.Name + ': Vendor set');
               if(!setChildAccIds.contains(childAcct.Id)){
                   lstChildAcctsToUpdate.add(childAcct); }
           }
        }       
     }
     update lstChildAcctsToUpdate; */

}