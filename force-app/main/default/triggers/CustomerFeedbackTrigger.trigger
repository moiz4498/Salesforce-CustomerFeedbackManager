trigger CustomerFeedbackTrigger on Customer_Feedback__c(
  before insert,
  before update,
  after insert,
  after update
) {
  CustomerFeedbackTriggerHandler.handleTrigger();
}
