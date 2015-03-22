//Controller should always run with sharing
global with sharing class CheckInViewerCtrl{

    //Plugin custom objects
    public CheckIn__c checkin{get;set;}

    //Almond assignment and learning objects
    public almond__Learning_Assignment__c assignment{get;private set;} //User assignment
    public almond__Learning_Version__c learningVersion{get;set;} //Learning version details
    public almond__Learning__c learning{get;set;} //Global learning header details

    //Read the setting in almond that indicates if your viewer should show the SF header
    public Boolean showSFHeader{get{return almond.LMSSettings.getShowSalesforceHeader();}private set;}

    //Flag that tells us if this is just a preview based on url parameters
    private Boolean isPreviewMode{get;set;}{isPreviewMode = false;}

    //Global exception used by the CheckIn extension
    global class CheckInException extends Exception{}

    global CheckInViewerCtrl(){
        init();
    }

    private void init(){

        //Retrieve assignment id
        String aid = Apexpages.currentPage().getParameters().get('aid');

        //Set preview mode flag, we can also get this from the Is_Test_Assignment__c field in the assignment record
        if(!String.isBlank(Apexpages.currentPage().getParameters().get('pMode'))){
            isPreviewMode = true;
        }

        try{

            //Get the assignment details from the parameter and user context details
            List<almond__Learning_Assignment__c> assignments = getLearningAssignmentDetails(aid,UserInfo.getUserId());
            assignment = assignments.get(0);

            //Get learning and learning version details. NOTE: These queries MUST run without sharing
            CheckInViewerCtrl.WithoutSharingOps wsops = new CheckInViewerCtrl.WithoutSharingOps();
            learningVersion = wsops.getLearningVersionDetails(assignment.almond__Learning_Version__c);
            learning = wsops.getLearningDetails(assignment.almond__Learning__c);

        }catch(Exception e){
            ApexPages.addMessages(e);
        }

    }

    @RemoteAction
    public static String doCheckIn(String assignmentId,Double latitude, Double longitude){

        Boolean isPreviewAssignment = false;

        //Re-construct the assignment detail information (Remote Action doesn't pass data in the viewstate)
        List<almond__Learning_Assignment__c> assignments = getLearningAssignmentDetails(assignmentId,UserInfo.getUserId());

        //Update the assignment progress
        if(assignments.size()>0){

            almond__Learning_Assignment__c assignment = assignments.get(0);
            isPreviewAssignment = assignment.almond__Is_Test_Assignment__c;

            //Get learning and learning version details. NOTE: These queries MUST run without sharing
            CheckInViewerCtrl.WithoutSharingOps wsops = new CheckInViewerCtrl.WithoutSharingOps();
            almond__Learning_Version__c learningVersion = wsops.getLearningVersionDetails(assignment.almond__Learning_Version__c);

            List<CheckIn__c> nearbyLocations = Database.query('SELECT ID FROM CheckIn__c where id = \''+learningVersion.CheckIn__c+'\' and DISTANCE(Checkin_Location__c,GEOLOCATION('+latitude+','+longitude+' ),\'mi\') < '+learningVersion.Checkin__r.Mile_Radius__c);

            if(nearbyLocations.size()>0){
                assignment.almond__Progress__c = 'Completed';
                assignment.almond__Progress_Percentage__c = 100.0;
                update assignments.get(0);
            }else{
                throw new CheckInException('Outside of valid radius');
            }

        }else{
            return null;
        }

        //Redirect back to the training plan detail page, we leave the navigation to javascript in the page to use the S1 navigation API
        PageReference retURL = null;
        if(isPreviewAssignment){
            retURL = new PageReference('/'+assignments.get(0).almond__Learning__c);
        }else{
            retURL = Page.almond__TrainingPlanDetail;
            retURL.getParameters().put('id',assignments.get(0).almond__Training_Plan__c);
        }

        return retURL.getUrl();
    }

    @RemoteAction
    public static String doCancel(String assignmentId){

        Boolean isPreviewAssignment = false;

        //Re-construct the assignment detail information (Remote Action doesn't pass data in the viewstate)
        List<almond__Learning_Assignment__c> assignments = getLearningAssignmentDetails(assignmentId,UserInfo.getUserId());

        if(assignments.size()>0){

            almond__Learning_Assignment__c assignment = assignments.get(0);
            isPreviewAssignment = assignment.almond__Is_Test_Assignment__c;

            //Redirect back to the training plan detail page, we leave the navigation to javascript in the page to use the S1 navigation API
            PageReference retURL = null;
            if(isPreviewAssignment){
                retURL = new PageReference('/'+assignments.get(0).almond__Learning__c);
            }else{
                retURL = Page.almond__TrainingPlanDetail;
                retURL.getParameters().put('id',assignments.get(0).almond__Training_Plan__c);
            }
            return retURL.getUrl();

        }else{
            return null;
        }
    }


    //Fetch assignment information for the specified assignment + user id
    public static List<almond__Learning_Assignment__c> getLearningAssignmentDetails(String assignmentId, Id userId){

        List<almond__Learning_Assignment__c> assignments = [select id
                                                                  ,Name
                                                                  ,almond__User__c
                                                                  ,almond__Contact__c
                                                                  ,almond__Learning__c
                                                                  ,almond__Learning_Version__c
                                                                  ,almond__Progress__c
                                                                  ,almond__Progress_Percentage__c
                                                                  ,almond__Evaluation_Result__c
                                                                  ,almond__Evaluation_Score__c
                                                                  ,almond__Evaluation_Times_Taken__c
                                                                  ,almond__Training_Plan__c
                                                                  ,almond__Training_Plan_Section__c
                                                                  ,almond__Shared_Learning_Assignment__c
                                                                  ,almond__Approver_Notes__c
                                                                  ,almond__User_Notes__c
                                                                  ,almond__Is_Test_Assignment__c
                                                                  from almond__Learning_Assignment__c
                                                                  where id = :assignmentId
                                                                  and almond__User__c = :userId];
          return assignments;
    }

    //Some operations need to run without sharing as some records are never shared with end-users
    private without sharing class WithoutSharingOps{

        //Returns details for the Learning Version associated to the current assignment
        public almond__Learning_Version__c getLearningVersionDetails(Id learningVersionId){

            //Add additional custom object fields here as needed
            almond__Learning_Version__c learningVersion = [select id
                                                                ,CheckIn__c
                                                                ,CheckIn__r.Id
                                                                ,CheckIn__r.Name
                                                                ,Checkin__r.Checkin_Location__latitude__s
                                                                ,Checkin__r.Checkin_Location__longitude__s
                                                                ,Checkin__r.Mile_Radius__c
                                                                from almond__Learning_Version__c
                                                                where id = :learningVersionId
                                                                limit 1];
            return learningVersion;

        }

        //Returns details for the Learning assocaited to the current assignment
        public almond__Learning__c getLearningDetails(Id learningId){

            //Add additional learning attributes that here as needed
            almond__Learning__c learning = [select id
                                                        ,Name
                                                        ,almond__Description__c
                                                        from almond__Learning__c
                                                        where id = :learningId];
            return learning;

        }

    }


}
