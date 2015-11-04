/*
    *@author       TCS Developer
    *@date         17/02/2014 
    *@description  This class is used to approve the Account (PR)
    *@Used for     AccountApprovalController
*/
// My first class on Git -Rashmi
public without sharing class AccountApprovalController {
	// New Comment -- AA
    
    public List<Account_Approval__c> lstAccountApprovals {get;set;}
    public Account_Approval__c currentApprovalRequest {get;set;}
    
    //Added by Matthew Miller 2014-6-17 so that contacts can be displayed in this page
    public Implementation_Period__c implementationPeriod {get;set;}
    public Contact grantAgreement {get;set;}
    public Contact disbursementRequest1 {get;set;}
    public Contact disbursementRequest2 {get;set;}
    //Added by Zak Kaufman 2014-8-12 so that primary contacts who are not one of the authorized can be displayed
    public list<Contact> primarycontact {get;set;}
    Public list<Contact> lstPrimaryContact {get;set;}
    public Contact contactCCMChair {get;set;}
    public Contact contactCCMCivilSociety {get;set;}
	//test
    public Boolean FO {get;set;}
    public Id accountId;
    public Account acc {get;set;}
    public String approvalComments {get;set;}
    public Boolean vendorExists{get;set;}
    Set<String> adminIds = new Set<String>();
    
    public AccountApprovalController () {
       checkApprovals();
    }
    
    public PageReference checkApprovals() {
        implementationPeriod = new Implementation_Period__c();
        grantAgreement = new Contact();
        disbursementRequest1 = new Contact();
        disbursementRequest2 = new Contact();
        primarycontact = new List<Contact>();
        contactCCMChair = new Contact();
        contactCCMCivilSociety = new Contact();        
        
        accountId = ApexPages.currentPage().getParameters().get('accId');
        lstAccountApprovals = [Select Id, Status__c, Assigned_To__c, Comments__c from Account_Approval__c 
                              where Account__c = :accountId AND Status__c = 'Pending'];
        if(lstAccountApprovals.size() > 0) {
            currentApprovalRequest = lstAccountApprovals[0]; }
        
        acc = [Select Id, CT_Finance_Officer__c, Vendor_ID__c,
              //Fields for FO review
              Name,
              Full_Legal__c,
              Legal_Abbreviation__c,
              Address_Line_1__c,
              Address_Line_2__c,
              Address_Line_3__c,
              City__c,
              State_Province__c,
              Zip_Postal_Code__c,
              PR_Validity_Period_Start_Date__c,
              PR_Validity_Period_End_Date__c,
              Type__c,
              Sub_Type__c,
              PR_Fiscal_Cycle__c,
              Ethics_COI_Code_of_Conduct__c,
              Submitted_GIP_Id__c,
              Locked__c,Grantee_Name__c,
              Address_line_1_Primary__c,
              Address_line_2_Primary__c,
              Address_line_3_Primary__c,
              City_Primary__c,
              State_Province_Primary__c,           
              Zip_Postal_Code_Primary__c,
              Country_Mailing_Address_Primary__c              
                
              from Account where Id = :accountId];
        
        if(acc.Submitted_GIP_Id__c != null) getGIP(acc.Submitted_GIP_Id__c);      
        
        if(acc.Vendor_ID__c != null){
            vendorExists = true; }
            else { vendorExists = false; }
          
        for(Profile p : [Select Id from Profile where Name = 'System Administrator']){
            adminIds.add(p.Id);}
        
        if(UserInfo.getUserId() == acc.CT_Finance_Officer__c || 
           adminIds.contains(UserInfo.getProfileId()) || 
           UserInfo.getUserId() == currentApprovalRequest.Assigned_To__c ) {
          FO = true;  }
        else { 
          FO = false; }        
        return null;
    }
    
    public PageReference approve() {
        updateApprovals('Approved');
        return null;
    }
    
    public PageReference reject() {
        updateApprovals('Rejected');
        return null;
    }
    
    Public void getGIP(String gipId){
        Boolean GAisprimary = false;
        Boolean DR1isprimary = false;
        Boolean DR2isprimary = false;
        
        system.debug('enter into method'+gipId);
        List<Implementation_Period__c> lstGIP = [Select Auth_Sig_for_Grant_Agreement__c, Auth_Sig_for_Disbursement_Request_1__c, 
                                                Auth_Sig_for_Disbursement_Request_2__c, CCM_Chair__c, CCM_Civil_Society_Representative__c
                                                from Implementation_Period__c where Id = :gipId];
        if(lstGIP.size() > 0) implementationPeriod = lstGIP[0];
        
        if(implementationPeriod.Auth_Sig_for_Grant_Agreement__c != null)
           grantAgreement = getContactById(implementationPeriod.Auth_Sig_for_Grant_Agreement__c);
           if(grantAgreement.Primary_Contact__c == TRUE) GAisprimary = TRUE;
        if(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c != null)
           disbursementRequest1 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_1__c);
           if(disbursementRequest1.Primary_Contact__c == TRUE) DR1isprimary = TRUE;
        if(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c != null)
           disbursementRequest2 = getContactById(implementationPeriod.Auth_Sig_for_Disbursement_Request_2__c);
           if(disbursementRequest2.Primary_Contact__c == TRUE) DR2isprimary = TRUE;
       // if(GAisprimary == false && DR1isprimary == false && DR2isprimary == false){
            List<Contact> lstPrimaryContact = [Select Id,Primary_Contact__c  from Contact where AccountId =: accountId AND Role__c IN ('Other','Focal point')];
            system.debug(lstPrimaryContact+' ----------');
            if(lstPrimaryContact.size() >0){
                for(Contact objContact: lstPrimaryContact){
                    if(objContact.Primary_Contact__c == true){
                        primarycontact.add(getContactById(objContact.Id));
                    }else{
                        primarycontact.add(getContactById(objContact.Id));
                    }if(primarycontact.size() == 4)
                        break;
                }
                
                
            }
            system.debug('-----------'+primarycontact.size());
      //  }
        if(implementationPeriod.CCM_Chair__c != null)
           contactCCMChair = getContactById(implementationPeriod.CCM_Chair__c);
        if(implementationPeriod.CCM_Civil_Society_Representative__c != null)
           contactCCMCivilSociety = getContactById(implementationPeriod.CCM_Civil_Society_Representative__c);
    }
        
    public Contact getContactById(String contactId){
        Contact con = new Contact();
        List<Contact> lstContacts = [Select Id, FirstName, LastName, Salutation, Title, Primary_Contact__c,
                                     Role__c, Email, Phone from Contact where Id = :contactId];
        if(lstContacts.size() > 0) con = lstContacts[0];
        return con;
    }
    
    public void updateApprovals(String status) {
        
        currentApprovalRequest.Status__c = status;
        currentApprovalRequest.Comments__c = approvalComments;
        currentApprovalRequest.Actual_Approver__c = UserInfo.getUserId();
        update currentApprovalRequest;
        Account account = new Account(Id = accountId, Approval_Status_Explanation__c = currentApprovalRequest.Comments__c,
                          Approval_Status__c = (status == 'Approved')?'Send to finance system for approval':'Reject');
        if(status == 'Approved') account.Locked__c = true;
        update account;
        //checkApprovals();
    }
}