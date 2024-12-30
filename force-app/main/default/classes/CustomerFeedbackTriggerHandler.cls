/**
 * CustomerFeedbackTriggerHandler.cls
 * @description Class to handle logic for trigger, since writing logics in triggers are not recommended.
 */
public with sharing class CustomerFeedbackTriggerHandler {
  /**
   * @description handleTrigger handles the logic for the trigger
   * @param  newFeedbacks newFeedbacks After insert/update customer feedbacks
   * @param  oldFeedbacks oldFeedbacks Before insert/update customer feedbacks
   * @param  isBefore isBefore Boolean to check if trigger is before
   * @param  isAfter isAfter Boolean to check if trigger is after
   */
  public static void handleTrigger() {
    // Analyze Sentiment (Before Insert/Update)
    if (Trigger.isBefore) {
      handleBeforeTrigger(Trigger.new);
    }
    // Create Task for Low Ratings (After Update)
    if (Trigger.isAfter) {
      handleAfterTrigger(Trigger.new);
    }
  }

  public static void handleBeforeTrigger(
    List<Customer_Feedback__c> newFeedbacks
  ) {
    FeedbackHelper.setFeedbacksSentiment(newFeedbacks);
  }

  public static void handleAfterTrigger(
    List<Customer_Feedback__c> newFeedbacks
  ) {
    // Create Task for Low Ratings
    WorkflowManager.checkAndTriggerEscalation(newFeedbacks);
  }
}
