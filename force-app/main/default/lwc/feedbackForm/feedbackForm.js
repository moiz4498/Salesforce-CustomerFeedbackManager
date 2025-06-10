import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CUSTOMER_FEEDBACK_OBJECT from '@salesforce/schema/Customer_Feedback__c';
import CUSTOMER_FIELD from '@salesforce/schema/Customer_Feedback__c.Customer__c';
import FEEDBACK_TYPE_FIELD from '@salesforce/schema/Customer_Feedback__c.Feedback_Type__c';
import RATING_FIELD from '@salesforce/schema/Customer_Feedback__c.Rating__c';
import FEEDBACK_TEXT_FIELD from '@salesforce/schema/Customer_Feedback__c.Feedback_Text__c';

export default class FeedbackForm extends LightningElement {
    objectApiName = CUSTOMER_FEEDBACK_OBJECT;
    customerField = CUSTOMER_FIELD;
    feedbackTypeField = FEEDBACK_TYPE_FIELD;
    ratingField = RATING_FIELD;
    feedbackTextField = FEEDBACK_TEXT_FIELD;

    handleSuccess() {
        // Show success toast
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Feedback submitted successfully',
            variant: 'success',
        });
        this.dispatchEvent(evt);

        // Reset form fields
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        inputFields.forEach(field => {
            field.reset();
        });

        // Notify parent component
        this.dispatchEvent(new CustomEvent('feedbacksubmitted'));
    }
}