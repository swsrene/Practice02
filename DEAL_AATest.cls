/**************************************************************************************
Apex Class Name     : DEAL_AuditAndAssuranceController
Version             : 1.0
Created Date        : 29/01/2019
Function            : 
Modification Log    :
* Developer                 Date                    Description
* -------------------------------------------------------------------------------------
* Carmen Botello          29/01/2019              Original Version
* Luis Perez              05/04/2019              TKT-001581
****************************************************************************************/
public with sharing class DEAL_AATest {
    /**
     * @Name getQuestions 
     * @purpose Get all the auditQuestion and assurance questions of the related record and return them processed 
     * as required for the component
     * @param  recordId Id of the Opportunity or Engament
     * @return String containing the structure of sections, questions and values for picklists
     * @author Liliana Trejo
     */
     /*
    @AuraEnabled
    public static string getQuestions(String recordId, String tabType){
    try
    {
        String userLanguage = UserInfo.getLanguage();
        User objUser=[Select id,DEAL_CurrentLanguage__c,FirstName from User Where id=:UserInfo.getUserId()];
        List<DEAL_AuditAndAssuranceQuestions__c> lstAuditQuestions = processQuery(recordId, tabType);
        Map<String, SectionStructure> mapAuditAndAssuranceQuestions=new Map<String, SectionStructure>();  

        Map<String, Map<String, SectionStructure>> mapSubsections = new Map<String, Map<String, SectionStructure>>();
        for(DEAL_AuditAndAssuranceQuestions__c auditQuestion :lstAuditQuestions){
            if (auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_Subsection__c == true && auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c != null) {
                //system.debug('Parent---'+auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c+'----Subsection---'+auditQuestion.DEAL_AudiAndAssureanceSection__r.name);
                SectionInfo objSectionInfo = getSectionInfo(userLanguage, auditQuestion, true);
                SectionInfo objSubSectionInfo = getSectionInfo(userLanguage, auditQuestion, false);
                QuestionData objQuestion = new QuestionData(auditQuestion, objUser);
                if( mapAuditAndAssuranceQuestions.containsKey(objSectionInfo.strSectionName) == false ){
                    SectionStructure subSection = new SectionStructure(objSubSectionInfo.strSectionName, objSubSectionInfo.helpText, objQuestion);
                    //System.debug('*********objQuestion***********'+objQuestion.question);
                    //System.debug('**********objSubSectionInfo.strSectionName**********'+objSubSectionInfo.strSectionName);
                    SectionStructure parentSection = new SectionStructure(objSectionInfo.strSectionName, objSectionInfo.helpText, subSection);
                    mapAuditAndAssuranceQuestions.put(objSectionInfo.strSectionName, parentSection);
                    Map<String, SectionStructure> mapQuestions = new Map<String, SectionStructure>();
                    mapQuestions.put(auditQuestion.DEAL_AudiAndAssureanceSection__c, subSection);
                    mapSubsections.put(auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c, mapQuestions);
                }else{
                    if(!mapSubsections.isEmpty()){
                    Map<String, SectionStructure> mapParentSubsections =  mapSubsections.get(auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c);
                        if(mapParentSubsections.containsKey(auditQuestion.DEAL_AudiAndAssureanceSection__c)){
                            SectionStructure subSectionData = mapParentSubsections.get(auditQuestion.DEAL_AudiAndAssureanceSection__c);
                            if(subSectionData.questions!= null){
                            subSectionData.questions.add(objQuestion);
                            mapAuditAndAssuranceQuestions.get(objSectionInfo.strSectionName).subSections = mapParentSubsections.values();
                            }
                        }else{
                            SectionStructure subSection = new SectionStructure(objSubSectionInfo.strSectionName, objSubSectionInfo.helpText, objQuestion);
                            mapAuditAndAssuranceQuestions.get(objSectionInfo.strSectionName).subSections.add(subSection);//
                            
                            if(mapSubsections.containsKey(auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c)){
                                mapSubsections.get(auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c).put(auditQuestion.DEAL_AudiAndAssureanceSection__c, subSection);
                            }else{
                                Map<String, SectionStructure> mapSubsectionList = new Map<String, SectionStructure>();
                                mapSubsectionList.put(auditQuestion.DEAL_AudiAndAssureanceSection__c, subSection);
                                mapSubsections.put(auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c, mapSubsectionList);
                            }
                        }
                    }
                }
            }else{
                SectionInfo objSectionInfo = getSectionInfo(userLanguage, auditQuestion, false);
                if(!mapAuditAndAssuranceQuestions.containsKey(objSectionInfo.strSectionName)){
                    mapAuditAndAssuranceQuestions.put(objSectionInfo.strSectionName, new SectionStructure(objSectionInfo.strSectionName, objSectionInfo.helpText, new QuestionData(auditQuestion, objUser))); 
                    SectionStructure objSection = mapAuditAndAssuranceQuestions.get(objSectionInfo.strSectionName); 
                }
                else{
                    SectionStructure objSection = mapAuditAndAssuranceQuestions.get(objSectionInfo.strSectionName);       
                    
                    objSection.questions.add(new QuestionData(auditQuestion, objUser));                     
                    mapAuditAndAssuranceQuestions.put(objSectionInfo.strSectionName, objSection);  
                }
            }
        }
        return JSON.serialize(mapAuditAndAssuranceQuestions.values());
    }
    catch(Exception e) {
         throw new AuraHandledException('Something went wrong: '
            + e.getMessage());  
    }
    }

    private static SectionInfo getSectionInfo(String userLanguage, DEAL_AuditAndAssuranceQuestions__c auditQuestion, Boolean isInfoFromParent){
        SectionInfo objSectionInfo = new SectionInfo();
        if(userLanguage.equals(GCRM_Constants_Helper.DE_LANGUAGE_KEY)){
            if(isInfoFromParent){
                objSectionInfo.strSectionName = auditQuestion.DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionParent__r.DEAL_SectionName__c ;
                objSectionInfo.helpText = auditQuestion.DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionParent__r.DEAL_HelpText__c;
            }else{
                objSectionInfo.strSectionName = auditQuestion.DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionName__c ;
                objSectionInfo.helpText = auditQuestion.DEAL_AudiAndAssureanceSectionGerman__r.DEAL_HelpText__c;
            }
        }else{                
            if(isInfoFromParent){
                objSectionInfo.strSectionName = auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__r.DEAL_SectionName__c ;
                objSectionInfo.helpText = auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__r.DEAL_HelpText__c;
            }else{
                objSectionInfo.strSectionName = auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_SectionName__c ;
                objSectionInfo.helpText = auditQuestion.DEAL_AudiAndAssureanceSection__r.DEAL_HelpText__c;
            }
        }
        return objSectionInfo;
    }

    /**
     * @Name processQuery 
     * @purpose Get all the auditQuestion and assurance questions of the related record
     * @param  recordId Id of the Opportunity or Engament
     * @return List of DEAL_AuditAndAssuranceQuestions__c questions
     * @author Liliana Trejo
     */
     /*
    private static List<DEAL_AuditAndAssuranceQuestions__c> processQuery(Id recordId, String tabType){
        String strObjName = recordId.getSObjectType().getDescribe().getName();

        String strQuery = 'SELECT Id,DEAL_AudiAndAssureanceSection__r.DEAL_SectionOrderNumber__c, DEAL_DetailGerman__c, DEAL_InputValueGerman__c ,';
        strQuery += 'DEAL_QuestionOrderNumber__c, Name,DEAL_Engagement__c ,DEAL_AARequireForPartner__c,DEAL_AARequireForConflict__c,DEAL_RegEx_Validation__c,DEAL_Opportunity__c ,';
        strQuery += 'DEAL_Detail__c ,DEAL_InputType__c ,DEAL_InputValues__c ,DEAL_InputSelection__c,DEAL_ReadOnly__c, DEAL_AudiAndAssureanceSectionGerman__c ,';
        strQuery += 'DEAL_HelpText__c,DEAL_Product__c ,DEAL_AudiAndAssureanceSection__r.Name,DEAL_AudiAndAssureanceSection__c, DEAL_Type__c,DEAL_AudiAndAssureanceSectionGerman__r.Name, DEAL_ErrorMessageGerman__c, DEAL_ErrorMessage__c, DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__r.name,';
        strQuery += 'DEAL_AudiAndAssureanceSection__r.DEAL_HelpText__c,DEAL_AudiAndAssureanceSectionGerman__r.DEAL_HelpText__c,DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__c,DEAL_AudiAndAssureanceSection__r.DEAL_Subsection__c, ';
        strQuery += 'DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionParent__r.DEAL_HelpText__c,DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__r.DEAL_HelpText__c,DEAL_isRequired__c,DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionParent__r.DEAL_SectionName__c,DEAL_AudiAndAssureanceSectionGerman__r.DEAL_SectionName__c,DEAL_AudiAndAssureanceSection__r.DEAL_SectionParent__r.DEAL_SectionName__c,DEAL_AudiAndAssureanceSection__r.DEAL_SectionName__c';
        strQuery += ' FROM DEAL_AuditAndAssuranceQuestions__c WHERE ';
        strQuery += (strObjName == 'Opportunity') ? 'DEAL_Opportunity__c' : 'DEAL_Engagement__c';
        strQuery += '=:recordId AND DEAL_Type__c =: tabType ORDER BY DEAL_AudiAndAssureanceSection__r.DEAL_SectionOrderNumber__c,DEAL_QuestionOrderNumber__c ASC';
        //system.debug('***- strQuery Questions: '+strQuery);

        List<DEAL_AuditAndAssuranceQuestions__c> lstAuditQuestions = Database.query(String.escapesinglequotes(strQuery));
        return lstAuditQuestions;
    }

    
    /**
     * @Name saveQuestions 
     * @purpose Saves the questions sent from the component
     * @param  strQuestions Questions from the component sent as a JSON String
     * @author Liliana Trejo
     */
     /*
    @AuraEnabled
    public static Boolean saveQuestions(String strQuestions,Id recordId,String tabType){
        Integer countPartnerRequired=0;
        Integer countConflictRequired=0;
        Integer countPartnerRequiredResponse=0;
        Integer countConflictRequiredResponse=0;
        Integer intCountRiskAssesmentSection=0;
        Integer intCountManagementSection=0;
        Integer intCountRiskAssesmentAnsweredsection=0;
        Integer intCountManagementAnsweredsection=0;
        Integer intCountRiskAssesmentSubSection=0;
        Integer intCountManagementSubSection=0;
        Integer intCountRiskAssesmentAnsweredSubSection=0;
        Integer intCountManagementAnsweredSubSection=0;
        integer intTotalAssesment;
        integer intTotalManagement;
        Boolean flag=false;
        try
        {
        List<DEAL_AuditAndAssuranceQuestions__c> lstAuditAndAssuranceQuestions= new List<DEAL_AuditAndAssuranceQuestions__c>();
        List<SectionStructure> sectionStructureWrapper =(List<SectionStructure>) JSON.deserialize(strQuestions,List<SectionStructure>.class);
        String strObjName = recordId.getSObjectType().getDescribe().getName();
            for(SectionStructure section:sectionStructureWrapper){ 
                if(section.questions != null){
                    for(QuestionData questionData:section.questions ){
                        system.debug('@@@@questionData.question.DEAL_isRequired__c---'+questionData.question.DEAL_isRequired__c);
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionData.question.DEAL_isRequired__c == true){
                            intCountRiskAssesmentSection=intCountRiskAssesmentSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionData.question.DEAL_isRequired__c == true && questionData.question.DEAL_InputSelection__c!=''){
                                intCountRiskAssesmentAnsweredsection=intCountRiskAssesmentAnsweredsection+1;
                            }
                        }
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionData.question.DEAL_isRequired__c == true){
                            intCountManagementSection=intCountManagementSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionData.question.DEAL_isRequired__c == true && questionData.question.DEAL_InputSelection__c!=''){
                                intCountManagementAnsweredsection=intCountManagementAnsweredsection+1;
                            }
                        }
                        if((tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT || tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT) && questionData.question.DEAL_isRequired__c == true && (questionData.question.DEAL_InputSelection__c=='' || questionData.question.DEAL_InputSelection__c==null)){
                            flag=true;
                        }else{
                            flag=false;
                        }

                        if(questionData.question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_LOOKUP){
                            if(questionData.lookupData != null && questionData.lookupData.strObjectInfo != null){
                                questionData.question.DEAL_InputSelection__c = questionData.lookupData.strObjectInfo;
                            }
                        }
                        lstAuditAndAssuranceQuestions.add(questionData.question);
                        
                        if( questionData.question.DEAL_AARequireForPartner__c == true){
                            countPartnerRequired=countPartnerRequired+1;
                            if(questionData.question.DEAL_InputSelection__c !=''&& questionData.question.DEAL_AARequireForPartner__c == true){
                                countPartnerRequiredResponse=countPartnerRequiredResponse+1;
                            }   
                        }

                        if( questionData.question.DEAL_AARequireForConflict__c == true){
                            countConflictRequired=countConflictRequired+1;
                            if(questionData.question.DEAL_InputSelection__c !='' && questionData.question.DEAL_AARequireForConflict__c == true){
                                countConflictRequiredResponse=countConflictRequiredResponse+1;
                            }   
                        }
                    }
                }
                for(SectionStructure subSection :section.subSections){
                    for(QuestionData questionDatasub :subSection.questions ){
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionDatasub.question.DEAL_isRequired__c == true){
                            intCountRiskAssesmentSubSection=intCountRiskAssesmentSubSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionDatasub.question.DEAL_isRequired__c == true && questionDatasub.question.DEAL_InputSelection__c!='' ){
                                intCountRiskAssesmentAnsweredSubSection=intCountRiskAssesmentAnsweredSubSection+1;
                            }
                        }
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionDatasub.question.DEAL_isRequired__c == true){
                            intCountManagementSubSection=intCountManagementSubSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionDatasub.question.DEAL_isRequired__c == true && questionDatasub.question.DEAL_InputSelection__c!='' ){
                                intCountManagementAnsweredSubSection=intCountManagementAnsweredSubSection+1;
                            }
                        } 
                        if((tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT || tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT  ) && questionDatasub.question.DEAL_isRequired__c == true && (questionDatasub.question.DEAL_InputSelection__c=='' || questionDatasub.question.DEAL_InputSelection__c==null)){
                            flag=true;
                        }else{
                            flag=false;
                        }
                        lstAuditAndAssuranceQuestions.add(questionDatasub.question);
                    }                    
                }
            }
                
        if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){  
            Opportunity objOpportunity=[Select id,DEAL_RiskAssessmentComplete__c,DEAL_RiskManagementComplete__c from Opportunity where id=:recordId];   
            if(tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT)){
                if((intCountRiskAssesmentSection == intCountRiskAssesmentAnsweredsection) && (intCountRiskAssesmentSubSection== intCountRiskAssesmentAnsweredSubSection)){
                    objOpportunity.DEAL_RiskAssessmentComplete__c=true;
                    flag=false;
                }
                    
                if((intCountRiskAssesmentSection != intCountRiskAssesmentAnsweredsection) || (intCountRiskAssesmentSubSection != intCountRiskAssesmentAnsweredSubSection)){
                    objOpportunity.DEAL_RiskAssessmentComplete__c=false;
                    flag=true;
                } 
            }  
            if(tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT) ){
                if((intCountManagementSection == intCountManagementAnsweredsection ) && (intCountManagementSubSection == intCountManagementAnsweredSubSection)){
                    objOpportunity.DEAL_RiskManagementComplete__c=true;
                    flag=false;
                }
                
                if((intCountManagementSection != intCountManagementAnsweredsection) || (intCountManagementSubSection != intCountManagementAnsweredSubSection)){
                    objOpportunity.DEAL_RiskManagementComplete__c=false;
                    flag=true;
                }
            }       
            update objOpportunity;
        }else{
            if(tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT)){
                if((intCountRiskAssesmentSection == intCountRiskAssesmentAnsweredsection) && (intCountRiskAssesmentSubSection== intCountRiskAssesmentAnsweredSubSection)){
                    flag=false;
                }
                    
                if((intCountRiskAssesmentSection != intCountRiskAssesmentAnsweredsection) || (intCountRiskAssesmentSubSection != intCountRiskAssesmentAnsweredSubSection)){
                    flag=true;
                } 
            }  
            if(tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT) ){
                if((intCountManagementSection == intCountManagementAnsweredsection ) && (intCountManagementSubSection == intCountManagementAnsweredSubSection)){
                    flag=false;
                }
                
                if((intCountManagementSection != intCountManagementAnsweredsection) || (intCountManagementSubSection != intCountManagementAnsweredSubSection)){
                    flag=true;
                }
            }
        }
        updateConflictAndPartner(recordId,countPartnerRequired,countPartnerRequiredResponse,countConflictRequired,countConflictRequiredResponse); 
        update lstAuditAndAssuranceQuestions;
        return flag;
     }
     catch(Exception e) {
         throw new AuraHandledException('Something went wrong: '
            + e.getMessage());  
    }
    }

    public static Boolean verifyInformation(List<SectionStructure> sectionStructureWrapper,String tabType,Id recordId){
        Boolean flag;
        String strObjName = recordId.getSObjectType().getDescribe().getName();
        Integer intCountRiskAssesmentSection=0;
        Integer intCountManagementSection=0;
        Integer intCountRiskAssesmentAnsweredsection=0;
        Integer intCountManagementAnsweredsection=0;
        Integer intCountRiskAssesmentSubSection=0;
        Integer intCountManagementSubSection=0;
        Integer intCountRiskAssesmentAnsweredSubSection=0;
        Integer intCountManagementAnsweredSubSection=0;
        for(SectionStructure section:sectionStructureWrapper){ 
                for(QuestionData questionData:section.questions ){
                    //system.debug('questionData.question.DEAL_isRequired__c'+questionData.question.DEAL_isRequired__c);
                    if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){
                        
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionData.question.DEAL_isRequired__c == true){
                            intCountRiskAssesmentSection=intCountRiskAssesmentSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionData.question.DEAL_isRequired__c == true && questionData.question.DEAL_InputSelection__c!=''){
                            intCountRiskAssesmentAnsweredsection=intCountRiskAssesmentAnsweredsection+1;
                            }
                        }
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionData.question.DEAL_isRequired__c == true){
                            intCountManagementSection=intCountManagementSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionData.question.DEAL_isRequired__c == true && questionData.question.DEAL_InputSelection__c!=''){
                            intCountManagementAnsweredsection=intCountManagementAnsweredsection+1;
                            }
                        }
                    }
                    if((tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT || tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT  ) && questionData.question.DEAL_isRequired__c == true && (questionData.question.DEAL_InputSelection__c=='' || questionData.question.DEAL_InputSelection__c==null)){
                       flag=true;
                       //break;
                    }else{
                        flag=false;
                    }
                }
            

            for(SectionStructure subSection :section.subSections){
                for(QuestionData questionDatasub :subSection.questions ){
                    //system.debug('questionDatasub.question.DEAL_isRequired__c'+questionDatasub.question.DEAL_isRequired__c);
                    if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){
                        
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionDatasub.question.DEAL_isRequired__c == true){
                            intCountRiskAssesmentSubSection=intCountRiskAssesmentSubSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT && questionDatasub.question.DEAL_isRequired__c == true && questionDatasub.question.DEAL_InputSelection__c!='' ){
                            intCountRiskAssesmentAnsweredSubSection=intCountRiskAssesmentAnsweredSubSection+1;
                            }
                        }
                        if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionDatasub.question.DEAL_isRequired__c == true){
                            intCountManagementSubSection=intCountManagementSubSection+1;
                            if(tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT && questionDatasub.question.DEAL_isRequired__c == true && questionDatasub.question.DEAL_InputSelection__c!='' ){
                            intCountManagementAnsweredSubSection=intCountManagementAnsweredSubSection+1;
                            }
                        }                           
                            
                    }
                   // system.debug('questionDatasub.question.DEAL_InputSelection__c---'+questionDatasub.question.DEAL_InputSelection__c);
                    if((tabType== GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT || tabType== GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT) && questionDatasub.question.DEAL_isRequired__c == true && (questionDatasub.question.DEAL_InputSelection__c=='' || questionDatasub.question.DEAL_InputSelection__c==null)){
                       flag=true;
                       break;
                       }
                    
                    else{
                        flag=false;
                    }
                      system.debug('flag---'+flag);
                }                    
            }
        }
        if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){
            /*if(intCountRiskAssesmentSection>0){
                if(intCountRiskAssesmentSection==intCountRiskAssesmentAnsweredsection){
                system.debug('******** the checkbox in opportunity need update intCountRiskAssesment');
                }
            }
            if(intCountManagement>0){
                if(intCountRiskAssesmentSubSection==intCountRiskAssesmentAnsweredSubSection){
                system.debug('******** the checkbox in opportunity need update intCountManagementAnswered');
                }
            }
        }
        /*
         system.debug('********intCountRiskAssesmentSection--- '+intCountRiskAssesmentSection);
         system.debug('********intCountRiskAssesmentAnswered--- '+intCountRiskAssesmentAnsweredsection);
          system.debug('********intCountRiskAssesmentSubSection--- '+intCountRiskAssesmentSubSection);
         system.debug('********intCountRiskAssesmentAnsweredSubSection--- '+intCountRiskAssesmentAnsweredSubSection);
           system.debug('******** flag---'+flag);
        return true;
    }
    /**
     * @Name updateConflictAndPartner 
     * @purpose Updates the fields in the object when the fields required is fill
     * @param  recordId Id from the Object
     * @param  countPartnerRequired Number of the Partner required
     * @param  countPartnerRequiredResponse Number of the Partner required response
     * @param  countConflictRequired Number of the Conflict required
     * @param  countConflictRequiredResponse Number of the Conflict response
     * @author Liliana Trejo
     */
     /*
    public static  void updateConflictAndPartner(Id recordId,integer countPartnerRequired,integer countPartnerRequiredResponse,integer countConflictRequired,integer countConflictRequiredResponse){        
        String strObjName = recordId.getSObjectType().getDescribe().getName();

        if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){
            Opportunity objOpportunity=[Select id,DEAL_AAApprovalPartnerCompleted__c,DEAL_AAConflictCheckCompleted__c from Opportunity where id=:recordId];
            if(countPartnerRequired==countPartnerRequiredResponse ){
                if(countPartnerRequired>0){                    
                	objOpportunity.DEAL_AAApprovalPartnerCompleted__c=true;                    
                }
            }
            if(countConflictRequired==countConflictRequiredResponse){
                if(countConflictRequired>0){ 
                    objOpportunity.DEAL_AAConflictCheckCompleted__c=true;
                }
            }
            if(countPartnerRequired != countPartnerRequiredResponse ){
                objOpportunity.DEAL_AAApprovalPartnerCompleted__c=false;
            }
            if(countConflictRequired != countConflictRequiredResponse){
                objOpportunity.DEAL_AAConflictCheckCompleted__c=false;
            }

        update objOpportunity;
        }else{
            DEAL_Engagement__c objEngagement=[Select id,DEAL_AAApprovalPartnerCompleted__c,DEAL_AAConflictCheckCompleted__c from DEAL_Engagement__c where id=:recordId];
            if(countPartnerRequired==countPartnerRequiredResponse){
                if(countPartnerRequired>0){  
                	objEngagement.DEAL_AAApprovalPartnerCompleted__c=true;
                }
            }
            if(countConflictRequired==countConflictRequiredResponse){
                if(countConflictRequired>0){  
                    objEngagement.DEAL_AAConflictCheckCompleted__c=true; 
                }
            }
            if(countPartnerRequired != countPartnerRequiredResponse ){
                objEngagement.DEAL_AAApprovalPartnerCompleted__c=false;
            }
            if(countConflictRequired != countConflictRequiredResponse){
                objEngagement.DEAL_AAConflictCheckCompleted__c=false;
            }
        update objEngagement;
        }
    }

    public class SectionInfo{
        String strSectionName;
        String helpText;
    }
    
    public class SectionStructure{
        public String name;
        public String helpText;
        public List<QuestionData> questions;
        public List<SectionStructure> subSections;

        public SectionStructure(String name, String helpText, QuestionData question){
            this.name = name;
            this.helpText = helpText;
            this.questions = new List<QuestionData>{question};
            this.subSections = new List<SectionStructure>();
        }
        public SectionStructure(String name, String helpText, SectionStructure subSection){
            this.name = name;
            this.helpText = helpText;
            this.questions = new List<QuestionData>();
            this.subSections = new List<SectionStructure>{subSection};
        }
    }
    /** 
     * Wrapper Structure containing the question information, the values if it's picklist or multipicklist
     * and the answers for that last case
     */
     /*
    public class QuestionData{
        public DEAL_AuditAndAssuranceQuestions__c question;
        public String  questionTittle;

        public List<MultiPicklistValues> multiPicklistValues;
        public List<String> picklistValues;
        public List<String> answerValues;
        public String regExp;
        public String errorMessage;
        public LookupStructure lookupData;


        public QuestionData(DEAL_AuditAndAssuranceQuestions__c question, User objUser){
            this.question = question;
            //system.debug('******'+UserInfo.getUserId());
            //system.debug('******'+objUser);
            String userLanguage = UserInfo.getLanguage();
            if(userLanguage.equals(GCRM_Constants_Helper.DE_LANGUAGE_KEY)){  
            
                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_MULTI_PICKLIST && String.IsNotBlank(question.DEAL_InputValueGerman__c)){
                    this.multiPicklistValues = new List<MultiPicklistValues>();
                    for(String value :question.DEAL_InputValueGerman__c.split(';')){
                        this.multiPicklistValues.add(new MultiPicklistValues(value));
                    }
                }
                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_PICKLIST && String.IsNotBlank(question.DEAL_InputValueGerman__c)){
                    this.picklistValues = new List<String>();
                    this.picklistValues = question.DEAL_InputValueGerman__c.split(';');
                }
                this.questionTittle=question.DEAL_DetailGerman__c;
                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_TEXT && String.IsNotBlank(question.DEAL_ErrorMessageGerman__c)){
                    this.errorMessage = question.DEAL_ErrorMessageGerman__c;
                }
            }else{

                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_MULTI_PICKLIST && String.IsNotBlank(question.DEAL_InputValues__c)){
                    this.multiPicklistValues = new List<MultiPicklistValues>();
                    for(String value :question.DEAL_InputValues__c.split(';')){
                        this.multiPicklistValues.add(new MultiPicklistValues(value));
                    }
                }
                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_PICKLIST && String.IsNotBlank(question.DEAL_InputValues__c)){
                    this.picklistValues = new List<String>();
                    this.picklistValues = question.DEAL_InputValues__c.split(';');
                }
                this.questionTittle=question.DEAL_Detail__c;
                if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_TEXT && String.IsNotBlank(question.DEAL_ErrorMessage__c)){
                    this.errorMessage = question.DEAL_ErrorMessage__c;
                }
            }
            //QUESTION DATA HANDLING
            
            if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_LOOKUP && String.IsNotBlank(question.DEAL_InputValues__c)){                
                List<String> objectValues = question.DEAL_InputValues__c.split('::::');
                if(objectValues.size() > 4){
                    this.lookupData = new LookupStructure(objectValues, objUser);
                    if(String.IsNotBlank(question.DEAL_InputSelection__c)){            
                        this.lookupData.strObjectInfo = question.DEAL_InputSelection__c;
                    }
                }
            }
            
            //ANSWER DATA HANDLING
            if(question.DEAL_InputType__c == GCRM_Constants_Helper.TYPE_OF_QUESTION_MULTI_PICKLIST && String.IsNotBlank(question.DEAL_InputSelection__c)){
                this.answerValues = question.DEAL_InputSelection__c.split(';');
            }
        }
    }

    /** 
     * Wrapper Structure that prepares the piclist values as required for the dualList component
     */
     /*
    public class MultiPicklistValues{
        public String label;
        public String value;

        public MultiPicklistValues(String value){
            this.label = value;
            this.value = value;
        }
    }

    /** 
     * Wrapper Structure that prepares the data when the field is lookup
     */
     /*
    public class LookupStructure{
        //Fields for lookup types
        public String strObjectInfo;
        public List<FieldStructure> fieldsStructures;
        public String objectName;
        public List<String> fieldList;
        public List<String> whereFields;
        public String displayValue;
        public String conditions;

        public LookupStructure(List<String> objectValues, User objUser){
            if(objectValues.size() >= 0){
                this.objectName = objectValues.get(0);
            }
            if(objectValues.size() >= 1){
                this.fieldsStructures = new List<FieldStructure>();
                this.fieldList = new List<String>();
                for(String fieldProperties :objectValues.get(1).split(';')){
                    this.fieldsStructures.add(new FieldStructure(fieldProperties, fieldList, objUser));
                }
            }
            if(objectValues.size() >= 3){
                this.whereFields = objectValues.get(2).split(',');
            }
            if(objectValues.size() >= 4){
                this.displayValue = objectValues.get(3);
            }
            if(objectValues.size() >= 5){
                this.conditions = objectValues.get(4);
            }
        }
    }

    /** 
     * Wrapper Structure that prepares the data when the field data for lookups
     */
     /*
    public class FieldStructure{
        public String label;
        public String api;
        public String permissionType;

        public FieldStructure(String fieldProperties, List<String> fieldList, User objUser){
            List<String> lstProperties = fieldProperties.split('.-.');
            String userLanguage = UserInfo.getLanguage();
            if(lstProperties.size() > 0){
                List<String> lstLabels = lstProperties.get(0).split('##');
                if(userLanguage.equals('de')){
                    if(lstLabels.size() >= 2){
                        this.label = lstLabels.get(1);
                    }
                }else{
                    if(lstLabels.size() > 0){
                        this.label = lstLabels.get(0);
                    }
                }
            }
            if(lstProperties.size() >= 2){
                fieldList.add(lstProperties.get(1));
                this.api = lstProperties.get(1);
            }
            if(lstProperties.size() >= 3){
                this.permissionType = lstProperties.get(2);
            }
        }
    }

    /**
     * @Name updateQuestions 
     * @purpose Saves the questions sent from the component
     * @param  strQuestions Questions from the component sent as a JSON String
     * @author Carmen Botello
     */
     /*
    @AuraEnabled
    public static void  updateQuestions(String strQuestions,Id recordId,String tabType){
        Boolean isEmptyField;
        system.debug('****recordId'+recordId);
        try{
        List<DEAL_AuditAndAssuranceQuestions__c> lstAuditAndAssuranceQuestions= new List<DEAL_AuditAndAssuranceQuestions__c>();
        DEAL_AuditAndAssuranceQuestions__c QuestionDataStructureWrapper =(DEAL_AuditAndAssuranceQuestions__c) JSON.deserialize(strQuestions,DEAL_AuditAndAssuranceQuestions__c.class);
        String strObjName = recordId.getSObjectType().getDescribe().getName();
        system.debug('****strObjName'+strObjName);
            if(tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT) || tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT)){
                lstAuditAndAssuranceQuestions.add(QuestionDataStructureWrapper);
            }
            if(strObjName==GCRM_Constants_Helper.STR_OPPORTUNITY){
                Opportunity objOpportunity=[Select id,DEAL_RiskAssessmentComplete__c,DEAL_RiskManagementComplete__c from Opportunity where id=:recordId];
            
                if((QuestionDataStructureWrapper.DEAL_InputSelection__c=='' || QuestionDataStructureWrapper.DEAL_InputSelection__c==null)){
                    isEmptyField=true;
                }
                if( isEmptyField=true && tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_MANAGEMENT) ){
                    objOpportunity.DEAL_RiskManagementComplete__c=false;
                }
                if(isEmptyField=true && tabType.equals(GCRM_Constants_Helper.STR_DEAL_RISK_ASSESSMENT)){
                    objOpportunity.DEAL_RiskAssessmentComplete__c=false;
                }
                update objOpportunity;
            }

        update lstAuditAndAssuranceQuestions;
        }
        catch(Exception e) {
         throw new AuraHandledException('Something went wrong: '
            + e.getMessage());  
    }

    }
    */
}