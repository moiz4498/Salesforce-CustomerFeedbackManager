import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FeedbackForm extends LightningElement {
    handleSuccess() {
        const toastEvent = new ShowToastEvent({
            title: "Feedback Submitted",
            message: "Customer feedback has been successfully submitted!",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}