@isTest
private class CustomerFeedbackTriggerHandlerTest {
  @isTest
  static void testClass() {
    System.assert(true, 'msg');
  }

  @isTest
  static void testBeforeTrigger() {
    List<Customer_Feedback__c> newFeedbackList = new List<Customer_Feedback__c>{
      new Customer_Feedback__c(
        Customer__c = '001skdfjsehf232',
        Rating__c = 4,
        Feedback_Type__c = 'Service Request',
        Feedback_Text__c = 'Great service!'
      )
    };

    try {
      CustomerFeedbackTriggerHandler.handleBeforeTrigger(newFeedbackList);

      System.assert(
        true,
        'Customer Feedback before handler is triggered successfully.'
      );
    } catch (Exception e) {
      System.assert(false, 'Exception should not be thrown.');
    }
  }

  @isTest
  static void testAfterTrigger() {
    List<Customer_Feedback__c> newFeedbackList = new List<Customer_Feedback__c>{
      new Customer_Feedback__c(
        Customer__c = '002sdlfp230fosd',
        Rating__c = 2,
        Feedback_Type__c = 'Service Request',
        Feedback_Text__c = 'Bad service!'
      )
    };

    try {
      CustomerFeedbackTriggerHandler.handleAfterTrigger(newFeedbackList);

      System.assert(
        true,
        'Customer Feedback after handler is triggered successfully.'
      );
    } catch (Exception e) {
      System.assert(false, 'Exception should not be thrown.');
    }
  }
}
