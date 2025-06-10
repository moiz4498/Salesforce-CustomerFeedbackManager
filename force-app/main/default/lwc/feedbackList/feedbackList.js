import { LightningElement, wire } from 'lwc';
import getFeedbackRecords from '@salesforce/apex/FeedbackController.getFeedbackRecords';

const columns = [
    { label: 'Customer', fieldName: 'CustomerName' },
    { label: 'Rating', fieldName: 'Rating', type: 'number' },
    { label: 'Feedback', fieldName: 'FeedbackText' },
    { label: 'Sentiment', fieldName: 'Sentiment' },
];

export default class FeedbackList extends LightningElement {
    columns = columns;
    feedbacks = [];
    error = null;

    @wire(getFeedbackRecords)
    wiredFeedbacks({ error, data }) {
        if (data) {
            this.feedbacks = data;
        } else if (error) {
            this.error = error;
            console.error('Error fetching feedbacks:', error);
        }
    }
}
