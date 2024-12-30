/**
 * FeedbackController.cls
 * @description Class to handle logic for the Feedback LWC components
 */
public with sharing class FeedbackController {
  /**
   * @description Fetches list of customer feedbacks for feedbackList LWC component
   * @return List<Customer_Feedback__c> return
   */
  @AuraEnabled(cacheable=true)
  public static List<Customer_Feedback__c> getFeedbackRecords() {
    // Make sure we can query customer feedbacks before even trying
    if (
      !Schema.sObjectType.Customer_Feedback__c.isAccessible() ||
      !Schema.sObjectType.Customer_Feedback__c.isQueryable() ||
      !Schema.sObjectType.Contact.isAccessible() ||
      !Schema.sObjectType.Contact.isQueryable()
    ) {
      throw new System.SecurityException(
        'Insufficient access rights to fetch Customer Feedback records.'
      );
    }

    return [
      SELECT
        Id,
        Customer__r.Name,
        Rating__c,
        Feedback_Type__c,
        Feedback_Text__c,
        Sentiment__c
      FROM Customer_Feedback__c
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
      LIMIT 100000
    ];
  }
}
