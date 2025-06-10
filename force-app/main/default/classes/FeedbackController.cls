/**
 * FeedbackController.cls
 * @description Class to handle logic for the Feedback LWC components
 */
public with sharing class FeedbackController {
  public class FeedbackWrapper {
    @AuraEnabled public Id Id;
    @AuraEnabled public String CustomerName;
    @AuraEnabled public Decimal Rating;
    @AuraEnabled public String FeedbackType;
    @AuraEnabled public String FeedbackText;
    @AuraEnabled public String Sentiment;
  }

  /**
   * @description Fetches list of customer feedbacks for feedbackList LWC component
   * @return List<FeedbackWrapper> return
   */
  @AuraEnabled(cacheable=true)
  public static List<FeedbackWrapper> getFeedbackRecords() {
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

    List<FeedbackWrapper> wrappers = new List<FeedbackWrapper>();
    for (Customer_Feedback__c cf : [
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
    ]) {
      FeedbackWrapper wrapper = new FeedbackWrapper();
      wrapper.Id = cf.Id;
      wrapper.CustomerName = cf.Customer__r != null ? cf.Customer__r.Name : null;
      wrapper.Rating = cf.Rating__c;
      wrapper.FeedbackType = cf.Feedback_Type__c;
      wrapper.FeedbackText = cf.Feedback_Text__c;
      wrapper.Sentiment = cf.Sentiment__c;
      wrappers.add(wrapper);
    }
    return wrappers;
  }
}
