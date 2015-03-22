@isTest
private class TestCheckInViewerCtrl{


    static testmethod void testCheckInViewer(){
        List<almondbeta__Learning__c> learnings = createTestLearning(1,'CheckIn',false);
        List<CheckIn__c> checkins = createTestCheckIn(learnings);
        List<almondbeta__Learning_Version__c> learningVersions = createTestLearningVersions(checkins);
        List<almondbeta__Learning_Assignment__c> assignments = createPreviewAssignments(learningVersions);


        PageReference pageRef = Page.CheckInViewer;
        pageRef.getParameters().put('aid',assignments.get(0).Id);
        pageRef.getParameters().put('pMode','true');
        Test.setCurrentPage(pageRef);

        Test.startTest();

            CheckInViewerCtrl ctrl = new CheckInViewerCtrl();
            System.assert(ctrl.assignment != null, 'Assignment not initialized');
            System.assert(ctrl.learning != null, 'Learning not initialized');
            System.assert(ctrl.learningVersion != null, 'Learning Version not initialized');

            //Verify cancel redirection
            try{
                String resultCancel = CheckInViewerCtrl.doCancel((String)assignments.get(0).Id);
                System.assert(resultCancel != null,'Invalid cancel url');
            }catch(Exception e){
                System.assert(false, 'Exception thrown in cancel');
            }

            //Check-In outside location
            try{
                String resultCheckIn1 = CheckInViewerCtrl.doCheckIn((String)assignments.get(0).Id,(25.6725514).doubleValue(),(-100.3422354).doubleValue());
                System.assert(false,'Should throw exception outside of check-in range');
            }catch(Exception e){
                System.assert(true);
            }

            //Check-In within location range
            try{
                String resultCheckIn2 = CheckInViewerCtrl.doCheckIn((String)assignments.get(0).Id,(37.792).doubleValue(),(-122.393).doubleValue());
                List<almondbeta__Learning_Assignment__c> updatedAssignment = [select id,almondbeta__Progress__c from almondbeta__Learning_Assignment__c where Id = :assignments.get(0).Id];
                System.assert(updatedAssignment.size()>0,'Invalid size for assignments');
                System.assert(updatedAssignment.get(0).almondbeta__Progress__c == 'Completed','Assignment status was not updated');
            }catch(Exception e){
                System.assert(false, 'Exception thrown within valid location');
            }

        Test.stopTest();
    }

    private static List<almondbeta__Learning__c> createTestLearning(Integer iNum, String recordType, Boolean bSyncProgress){
        List<almondbeta__Learning__c> lResult = new List<almondbeta__Learning__c>();
        List<RecordType> learningRT = [select Id, Name, DeveloperName from RecordType where SobjectType = 'almondbeta__Learning__c' and DeveloperName =: recordType];

        for(Integer i = 0; i < iNum; i++){
            almondbeta__Learning__c olearning = new almondbeta__Learning__c();
            olearning.almondbeta__Description__c = 'test description';
            olearning.almondbeta__Duration__c = 10;
            olearning.almondbeta__Sync_progress__c = bSyncProgress;
            olearning.RecordTypeId = learningRT.get(0).Id;

            lResult.add(olearning);
        }

        insert lResult;
        return lResult;
    }

    private static List<CheckIn__c> createTestCheckIn(List<almondbeta__Learning__c> learnings){
        List<CheckIn__c> lResult = new List<CheckIn__c>();

        for(almondbeta__Learning__c olearn : learnings){
            CheckIn__c checkin = new CheckIn__c();
            checkin.Learning__c = olearn.Id;
            checkin.Checkin_Location__latitude__s = 37.792;
            checkin.Checkin_Location__longitude__s = -122.393;
            checkin.Mile_Radius__c = 0.1;
            lResult.add(checkin);
        }

        insert lResult;
        return lResult;
    }

    private static List<almondbeta__Learning_Version__c> createTestLearningVersions(List<CheckIn__c> checkins){
        List<almondbeta__Learning_Version__c> versions = new List<almondbeta__Learning_Version__c>();

        for(CheckIn__c checkin : checkins){
            almondbeta__Learning_Version__c v = new almondbeta__Learning_Version__c();
            v.almondbeta__Learning__c = checkin.Learning__c;
            v.CheckIn__c  = checkin.Id;
            v.almondbeta__Version__c = 0;
            v.almondbeta__Type__c = 'Preview';
            versions.add(v);
        }

        insert versions;
        return versions;
    }

    private static List<almondbeta__Learning_Assignment__c> createPreviewAssignments(List<almondbeta__Learning_Version__c> versions){
        List<almondbeta__Learning_Assignment__c> assignments = new List<almondbeta__Learning_Assignment__c>();

        for(almondbeta__Learning_Version__c version : versions){

            almondbeta__Learning_Assignment__c a = new almondbeta__Learning_Assignment__c();
            a.almondbeta__Learning__c = version.almondbeta__Learning__c;
            a.almondbeta__Learning_Version__c = version.Id;
            a.almondbeta__Is_Test_Assignment__c = true;
            a.almondbeta__User__c = UserInfo.getUserId();
            assignments.add(a);
        }

        insert assignments;
        return assignments;

    }

}
