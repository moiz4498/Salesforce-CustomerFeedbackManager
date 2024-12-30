/**
 * FeedbackHelper.cls
 * @description Class to handle Sentiment analysis logic for feedbacks
 */
public class FeedbackHelper {
  private static final String POSITIVE_SENTIMENT = 'Positive';
  private static final String NEGATIVE_SENTIMENT = 'Negative';
  private static final String NEUTRAL_SENTIMENT = 'Neutral';

  private static final Set<String> POSITIVE_WORDS = new Set<String>{
    'satisfied',
    'love',
    'delight',
    'blissful',
    'thrilling',
    'spectacular',
    'warm',
    'zesty',
    'marvelous',
    'delightful',
    'jubilant',
    'cheerful',
    'lovely',
    'uplifting',
    'ideal',
    'amazing',
    'radiant',
    'brilliant',
    'joyful',
    'positive',
    'pristine',
    'graceful',
    'magnificent',
    'good',
    'kind',
    'outstanding',
    'great',
    'harmonious',
    'zealous',
    'happy',
    'wonderful',
    'fabulous',
    'luminous',
    'awesome',
    'fantastic',
    'vivid',
    'terrific',
    'optimistic',
    'refreshing',
    'euphoric',
    'excellent',
    'remarkable',
    'satisfying',
    'success',
    'pleasing',
    'charming',
    'serene'
  };
  private static final Set<String> NEGATIVE_WORDS = new Set<String>{
    'angry',
    'hate',
    'disappointed',
    'worst',
    'pessimistic',
    'miserable',
    'foul',
    'unhappy',
    'wicked',
    'gloomy',
    'vicious',
    'disappointing',
    'zapped',
    'unpleasant',
    'repulsive',
    'awful',
    'lifeless',
    'gruesome',
    'vile',
    'sad',
    'tragic',
    'painful',
    'abrasive',
    'depressing',
    'terrible',
    'cold',
    'negative',
    'bad',
    'dreadful',
    'disturbing',
    'hateful',
    'harsh',
    'toxic',
    'inadequate',
    'poor',
    'horrific',
    'ugly',
    'unbearable',
    'ominous',
    'dismal',
    'worthless',
    'horrible',
    'quarrelsome',
    'spiteful',
    'pathetic',
    'jealous',
    'nasty',
    'yucky',
    'hopeless'
  };
  private static final Set<String> NEUTRAL_WORDS = new Set<String>{
    'acceptable',
    'fine',
    'impartial',
    'usual',
    'nonchalant',
    'plain',
    'tolerable',
    'steady',
    'regular',
    'so-so',
    'standard',
    'everyday',
    'calm',
    'detached',
    'unremarkable',
    'static',
    'even',
    'adequate',
    'conventional',
    'ordinary',
    'reserved',
    'reasonable',
    'stable',
    'mediocre',
    'routine',
    'composed',
    'sufficient',
    'average',
    'indifferent',
    'middling',
    'modest',
    'balanced',
    'neutral',
    'moderate',
    'expected',
    'passable',
    'okay',
    'simple',
    'typical',
    'fair',
    'unbiased',
    'normal',
    'placid',
    'unchanged',
    'toneless',
    'general'
  };

  /**
   * @description Set the feedback sentiment based on the feedback text
   * @param  feedbacks feedbacks List of Customer_Feedback__c
   */
  public static void setFeedbacksSentiment(
    List<Customer_Feedback__c> feedbacks
  ) {
    for (Customer_Feedback__c feedback : feedbacks) {
      feedback.Sentiment__c = analyzeSentiment(feedback.Feedback_Text__c);
    }
  }

  /**
   * @description analyzeSentiment Analyzes sentiment of feedback
   * @param  feedbackText feedbackText Customer feedback text
   * @return              return String
   */
  public static String analyzeSentiment(String feedbackText) {
    feedbackText = feedbackText.toLowerCase().trim();
    if (String.isBlank(feedbackText)) {
      return NEUTRAL_SENTIMENT; // Default for blank or null text
    }

    Integer positiveCount = 0;
    Integer negativeCount = 0;
    Integer neutralCount = 0;
    List<String> words = feedbackText.split('\\W+'); // Split by non-word characters

    for (String word : words) {
      if (POSITIVE_WORDS.contains(word)) {
        positiveCount++;
      } else if (NEGATIVE_WORDS.contains(word)) {
        negativeCount++;
      } else if (NEUTRAL_WORDS.contains(word)) {
        neutralCount++;
      }
    }

    return getSentimentBasedOnScore(positiveCount, negativeCount, neutralCount);
  }

  /**
   * @description getSentimentBasedOnScore Analyze the sentiment based on the score
   * @param  positiveCount positiveCount Positive words count
   * @param  negativeCount negativeCount Negative words count
   * @param  neutralCount  neutralCount Neutral words count
   * @return               return Sentiment word i.e. Positive, Negative or Neutral
   */
  private static String getSentimentBasedOnScore(
    Integer positiveCount,
    Integer negativeCount,
    Integer neutralCount
  ) {
    // Determine sentiment based on counts
    if (positiveCount > negativeCount && positiveCount > neutralCount) {
      return POSITIVE_SENTIMENT;
    }
    if (negativeCount > positiveCount && negativeCount > neutralCount) {
      return NEGATIVE_SENTIMENT;
    }
    if (neutralCount > positiveCount && neutralCount > negativeCount) {
      return NEUTRAL_SENTIMENT;
    }

    // Handle ties or no matches
    if (positiveCount == negativeCount && positiveCount > 0) {
      return NEUTRAL_SENTIMENT; // Balance between positive and negative
    }

    return NEUTRAL_SENTIMENT; // Default when unclear
  }
}
