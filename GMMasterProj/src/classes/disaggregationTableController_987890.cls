public with sharing class disaggregationTableController_987890 {

    public string selectedBaseLineValue             {get;set;}
    public string selectedGDId                      {get;set;}
    public String recordId                                            {get; set;}
    public String mode                                           {get; set;}
    public Boolean isEditable                                         {get; set;}
    public Boolean isSaved                                            {get; set;}
    public List<DisagreegationTableWrapper> disAggreegationWraprList  {get; set;}
    public Boolean blnHistory{get;set;}
    List<DisagreegationTableWrapper> aggreegationWrapperList;
    Grant_Disaggregated__c CNTarget1;
    public String strSelectedGID {get; set;}
    public Boolean blnPRComments {get;set;}
    public Boolean blneditmode{get;set;}
    public boolean blndisaggregated  {get;set;}
    public List<Grant_Disaggregated__c> gdList {get; set;}
    public Grant_Disaggregated__c grantdis{get;set;}
    public Boolean blnGFComments {get; set;}
    public String pfStatus {get; set;}
    public String dataType {get; set;}
    public Boolean blnReadGFComments {get; set;}
    public String decimalPlace {get;set;}
    public Boolean showEdit {get; set;}
    private Map<Id,DisagreegationTableWrapper> mapValues{get;set;} 
    //get the page's table values
    public List<DisagreegationTableWrapper> getaggreegationWrapperList() {
        system.debug('>>>>>Record Id : '+recordId);
        gdList = new List<Grant_Disaggregated__c>();
        if(recordId != null && recordId != '') {      
            if( mapValues.isEmpty() ){        
                aggreegationWrapperList = new List<DisagreegationTableWrapper>();
                disAggreegationWraprList = new List<DisagreegationTableWrapper>();      
                Map<String, Grant_Disaggregated__c> strGrntDisaggregatedMap = new Map<String, Grant_Disaggregated__c>();
                DisagreegationTableWrapper aggreegationWrapper;
                Grant_Disaggregated__c grntDisaggregated;
                
                gdList = [SELECT Name, Id, Catalog_Disaggregated__c, Component__c, Disaggregated_Baseline_Sources__c, Disaggregated_Baseline_Year__c,
                          Disaggregated_Baseline_Value__c, Catalog_Disaggregated__r.Disaggregation_Category__c, Catalog_Disaggregated__r.Disaggregation_Value__c,
                          Disaggregation_Category__c, Disaggregation_Value__c, Baseline_Numerator__c, Baseline_Denominator__c,Please_Specify__c
                          FROM Grant_Disaggregated__c
                          WHERE Grant_Indicator__c =: recordId
                          ORDER BY Disaggregation_Category__c];
                          System.debug('~~~~~~~~~~'+gdList);             
                string flag = '';
                Integer count;
                Integer categoryIndex;
                Integer i = 0;
                for(Grant_Disaggregated__c cdd : gdList) {
                    system.debug('hsdfgdjsfgdjfinside for lop'+cdd.Disaggregation_Category__c);
                        system.debug('hsdfgdjsfgdjfinside for lop123'+flag);
                    grntDisaggregated = new Grant_Disaggregated__c();
                    grntDisaggregated = cdd;        
                    if(flag == cdd.Disaggregation_Category__c) {
                    /*    if(dataType != Label.NaP_DT)
                            count++;
                        else
                            count = count + 2;*/
                            count++;
                            system.debug('count'+count);
                        if(i == (gdList.size() - 1))
                            disAggreegationWraprList[categoryIndex].cs = count;     
                        System.debug('equalsssssss'+flag+count);
                    }
                    else {
                        flag = cdd.Disaggregation_Category__c;
                        if(i != 0)
                            disAggreegationWraprList[categoryIndex].cs = count;
                        system.debug('category count'+categoryIndex);
                       /* if(dataType != Label.NaP_DT)
                            count = 1;
                        else 
                            count = 2;*/
                             count = 1;
                           system.debug('count'+count); 
                        categoryIndex = i;
                    }                    
                    aggreegationWrapper = new DisagreegationTableWrapper(grntDisaggregated, 0);
                    aggreegationWrapper.selectedBaseLineValue = aggreegationWrapper.gd.Disaggregated_Baseline_Sources__c; 
                    disAggreegationWraprList.add(aggreegationWrapper);
                    mapValues.put(aggreegationWrapper.gd.id, aggreegationWrapper);
                    i++;
                }
                
                aggreegationWrapperList = disAggreegationWraprList;
            }
            
        }
        checkProfile();
        return disAggreegationWraprList;
    }
    
    public void setaggreegationWrapperList(List<DisagreegationTableWrapper> s) {
        aggreegationWrapperList = s;
    }
    
    //controller
    public disaggregationTableController_987890 () {
        //getHistoryTrack();
        mapValues = new Map<Id, DisagreegationTableWrapper>();
        grantdis = new Grant_Disaggregated__c();
        isEditable = true;
        isSaved = false;
        blnHistory = false;
        CNTarget1 = new Grant_Disaggregated__c();         
        checkProfile();  
    }   
    
    //method for edit button
    public void EditDisaggregated() {
        isEditable = false;
        isSaved = true;
        blneditmode = true; 
        blnHistory = false;       
    }
    
    //method to load on basis of mode
    public void checkForMode()
    {
        System.debug('@@@@@@ '+mode);
        if(mode.equals('edit'))
        {
            isEditable = false;
            isSaved = true;
            blneditmode = true; 
            blnHistory = false; 
        }
    }
    
    //mehtod for cancel button
    public PageReference CancelIndicator(){
        
        if(mode=='edit'){
            String ret=ApexPages.currentPage().getParameters().get('par5');
            string indtype = ApexPages.currentPage().getParameters().get('par6');
            if(indtype == 'Coverage/Output' ){
                   PageReference pageRef = new PageReference('/apex/IndicatorInlineCovOutput?id='+ret);
                   pageRef.setRedirect(true);
                   return pageRef;
                }
            else{
            PageReference pageRef = new PageReference('/apex/IndicatorsInlineEditPage?id='+ret);
            pageRef.setRedirect(true);
            return pageRef;
            }       
        }else{
            isEditable = true;
            isSaved = false;
            blneditmode = false;
            return null;
        }
        
    }
    
     public PageReference ReturnToInd()
    {   
        String ret=ApexPages.currentPage().getParameters().get('par5');
        string indtype = ApexPages.currentPage().getParameters().get('par6');
        if(indtype == 'Coverage/Output' ){
               PageReference pageRef = new PageReference('/apex/IndicatorInlineCovOutput?id='+ret);
               pageRef.setRedirect(true);
               return pageRef;
            }
        else{
        PageReference pageRef = new PageReference('/apex/IndicatorsInlineEditPage?id='+ret);
        pageRef.setRedirect(true);
        return pageRef;
        }
    }
   
    //method to save indicators
    public PageReference SaveAction() {
        List<Grant_Disaggregated__c> upsertGDList = new List<Grant_Disaggregated__c>();
        Grant_Disaggregated__c gdRec;
        for(DisagreegationTableWrapper dtWrapper : aggreegationWrapperList) {
            System.debug('Update Grant Disaggregated Record'+dtWrapper);
            gdRec = new Grant_Disaggregated__c();
            gdRec = dtWrapper.gd;
            upsertGDList.add(gdRec);                          
        }
        if(upsertGDList != null && !upsertGDList.isempty()) {
            update upsertGDList;
        }
        isEditable = true;
        isSaved = false;
        blneditmode = false;
        if(mode.equals('edit'))
        {
            String ret=ApexPages.currentPage().getParameters().get('par5');
            string indtype = ApexPages.currentPage().getParameters().get('par6');
            if(indtype == 'Coverage/Output' ){
               PageReference pageRef = new PageReference('/apex/IndicatorInlineCovOutput?id='+ret);
               pageRef.setRedirect(true);
               return pageRef;
            }
            else{
            PageReference pageRef = new PageReference('/apex/IndicatorsInlineEditPage?id='+ret);
            pageRef.setRedirect(true);
            return pageRef;
            }
        }
        else
        {
            return null;
        }
    }
    
  
    
    //Show history popup
    Public void ShowHistoryPopup(){
        blnHistory = true;
        system.debug('Bln:'+ blnHistory);            
    }
    
    
    //History Popup Close         
    Public void HidePopupHistory(){                
        blnHistory = false;
        system.debug('Bln:'+ blnHistory);            
    } 
    
    
    
    //profile access for various user profiles
    public void checkProfile() {        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;    
        List<Profile_Access_Setting__c> checkpage = [Select Salesforce_Item__c, Page_Name__c, Profile_Name__c, Status__c 
                                                     from Profile_Access_Setting__c 
                                                     where Page_Name__c ='grantDisaggregatedController' 
                                                     and Profile_Name__c =: profilename];
        system.debug(checkpage);
        for (Profile_Access_Setting__c check : checkpage){
            if(check.Salesforce_Item__c == 'Edit Pr Comment'&& (check.Status__c == pfStatus || check.Status__c == null || check.Status__c == '')) 
                blnPRComments = true;
            if(check.Salesforce_Item__c == 'Edit Disaggregation' && (check.Status__c == pfStatus || check.Status__c == null || check.Status__c == '')) 
                blndisaggregated = true;
            if(check.Salesforce_Item__c == 'Edit Global Fund Comment' && (check.Status__c == pfStatus || check.Status__c == null || check.Status__c == '')) 
                blnGFComments = true;
            if(check.Salesforce_Item__c == 'Read Global Fund Comment'&& (check.Status__c == pfStatus || check.Status__c == null || check.Status__c == '')) 
                blnReadGFComments = true;
            if(check.Salesforce_Item__c == 'Edit record'&& (check.Status__c == pfStatus || check.Status__c == null || check.Status__c == '')) 
                showEdit = true;
            
        }
    }
    public void showInputSection(){
        for( DisagreegationTableWrapper disAgg : aggreegationWrapperList ){
            if( disAgg.gd.Id == selectedGDId ){
                disAgg.selectedBaseLineValue  =  disAgg.gd.Disaggregated_Baseline_Sources__c;   
                if( disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Other_specify 
                    && disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Other_survey_specify 
                    && disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Other_survey_specify2 
                    && disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Reports_Surveys_Questionnaires_etc_specify 
                    && disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Reports_specify 
                    && disAgg.gd.Disaggregated_Baseline_Sources__c != Label.Specific_surveys_and_research_specify){
                    
                    disAgg.gd.Please_Specify__c = '';    
                }    
            }
            
        }
    }
    
    //Save comments
    public void saveGDComments() {      
        update grantdis;
        grantdis = new Grant_Disaggregated__c();
    }
    
      //wrapper of disaggregation
    public class DisagreegationTableWrapper {
        public Grant_Disaggregated__c gd                {get; set;}
        public Integer cs                               {get; set;}
        public string selectedBaseLineValue             {get;set;}
        public DisagreegationTableWrapper (Grant_Disaggregated__c gd, Integer cs) {
            this.gd = gd;
            this.cs = cs;
            selectedBaseLineValue = '';
        }
    } 
}