/**
 * WorkflowManager.cls
 * @description Class to handle task escalations based on feedbacks
 */
public with sharing class WorkflowManager {
  /**
   * @description checkAndTriggerEscalation checks if the feedbacks have a rating of less than 3 and if so, triggers the escalation
   * @param  feedbacks feedbacks List of Customer_Feedback__c
   */
  public static void checkAndTriggerEscalation(
    List<Customer_Feedback__c> feedbacks
  ) {
    List<Task> tasksToInsert = new List<Task>();
    
    for (Customer_Feedback__c feedback : feedbacks) {
      Task escalationTask = createEscalationTask(feedback);
      if (escalationTask != null) {
        tasksToInsert.add(escalationTask);
      }
    }
    
    if (!tasksToInsert.isEmpty()) {
      // Make sure we can create the tasks before even trying
      if (!Schema.sObjectType.Task.isCreateable()) {
        throw new System.SecurityException(
          'Insufficient access rights to create task.'
        );
      }
      insert tasksToInsert;
    }
  }

  /**
   * @description createEscalationTask creates a task for escalation if needed
   * @param  feedback feedback Customer_Feedback__c
   * @return Task The created task or null if no escalation needed
   */
  private static Task createEscalationTask(Customer_Feedback__c feedback) {
    // If the feedback has rating greater than 3, do nothing
    if ((feedback.Rating__c != null && feedback.Rating__c > 2) ||
      (feedback.Sentiment__c != null && feedback.Sentiment__c != 'Negative')) {
      return null;
    }
    
    // Create task for Low Ratings
    return new Task(
      Subject = 'Follow up on customer feedback',
      WhoId = feedback.Customer__c,
      Priority = 'High',
      WhatId = feedback.Id,
      Status = 'Not Started',
      Description = 'Please reach out to customer and escalate the issue'
    );
  }
}
