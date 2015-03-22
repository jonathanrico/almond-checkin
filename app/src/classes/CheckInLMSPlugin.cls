//The name of the Plugin Class must be your Custom Learning Record Type Developer Name + LMS Plugin
global with sharing class CheckInLMSPlugin implements almond.LMSPLugins.Learning{

    //Init method must return the configuration parameters that will be used by the almond publisher, previewer and launcher
    global almond.LMSPlugins.LearningConfig init(){

        almond.LMSPlugins.LearningConfig config = new almond.LMSPlugins.LearningConfig();

        //Name of your Custom Learning object, namespace is not required
        config.objectName = 'CheckIn__c';

        //Name of the M-D relationship field in the Learning Version object that points to your Custom Learning Object
        config.learningVersionLookupField = 'CheckIn__c';

        //Path to the page that will render the learning to end users
        //NOTE: Relative paths starting with /apex/ will be detected by almond
        //and namespaces in the redirect URL will be handled automatically
        //Non-relative URLs won't be modified by almond
        config.launchURL = '/apex/CheckInViewer';


        return config;

    }

}
