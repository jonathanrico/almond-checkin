@isTest
public class TestCheckInLMSPlugin{

    static testmethod void testPluginInit(){
        Test.startTest();

        CheckInLMSPlugin plugin = new CheckInLMSPlugin();
        almondbeta.LMSPlugins.LearningConfig config = plugin.init();
        System.assert(config != null);

        Test.stopTest();
    }

}
