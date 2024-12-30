import { LightningElement, wire } from 'lwc';
import getFeedbackRecords from '@salesforce/apex/FeedbackController.getFeedbackRecords';

const columns = [
    { label: 'Customer', fieldName: 'CustomerName' },
    { label: 'Rating', fieldName: 'Rating__c', type: 'number' },
    { label: 'Feedback', fieldName: 'Feedback_Text__c' },
    { label: 'Sentiment', fieldName: 'Sentiment__c' },
];

export default class FeedbackList extends LightningElement {
    columns = columns;
    feedbacks = [];
    error = null;

    @wire(getFeedbackRecords)
    wiredFeedbacks({ error, data }) {
        if (data) {
            this.feedbacks = data.map(record => ({
                ...record,
                CustomerName: record.Customer__r ? record.Customer__r.Name : 'N/A'
            }));
        } else if (error) {
            this.error = error;
            console.error('Error fetching feedbacks:', error);
        }
    }
}
