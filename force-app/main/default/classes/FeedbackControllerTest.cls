/**
 * FeedbackControllerTest.cls
 * @description FeedbackControllerTest Unit tests for FeedbackController class
 */
@isTest
private class FeedbackControllerTest {
  /**
   * @description setupData Setup test/mockup data to run tests
   */
  @testSetup
  static void setupData() {
    // Insert sample Customer Feedback data
    List<Customer_Feedback__c> feedbacks = new List<Customer_Feedback__c>();
    Contact contact = new Contact(
      FirstName = 'John',
      LastName = 'Smith',
      Department = 'Test Dept.'
    );
    insert contact;

    for (Integer i = 0; i < 5; i++) {
      Customer_Feedback__c fb = new Customer_Feedback__c();
      fb.Customer__c = contact.Id;
      fb.Rating__c = i + 1;
      fb.Feedback_Text__c = 'This service was excellent!';
      fb.Feedback_Type__c = 'Purchase';

      feedbacks.add(fb);
    }
    insert feedbacks;
  }

  /**
   * @description testGetFeedbackRecords Test customer feedbacks fetching.
   */
  @isTest
  static void testGetFeedbackRecords() {
    // Create a test user with read-only access to Customer_Feedback__c records
    User readOnlyUser = createMinimumAccessUser(true);

    // Switch to the test user context
    System.runAs(readOnlyUser) {
      try {
        // Call the Apex method
        List<Customer_Feedback__c> results = FeedbackController.getFeedbackRecords();
        System.assertEquals(
          5,
          results.size(),
          'Should return 5 feedback records'
        );
      } catch (Exception e) {
        System.assert(false, 'Exception message was "' + e.getMessage() + '"');
      }
    }
  }

  /**
   * @description testGetFeedbackRecordsWithInsufficientAccessException Test customer feedbacks fetching without access.
   */
  @isTest
  static void testGetFeedbackRecordsWithInsufficientAccessException() {
    // Create a test user with read-only access to Customer_Feedback__c records
    User readOnlyUser = createMinimumAccessUser(false);
    // new User(Id = UserInfo.getUserId())

    // Switch to the test user context
    System.runAs(readOnlyUser) {
      try {
        FeedbackController.getFeedbackRecords();
        // If no exception is thrown, fail the test
        System.assert(false, 'Expected exception was not thrown');
      } catch (System.SecurityException e) {
        // Expected exception, assert the exception message
        System.assertEquals(
          'Insufficient access rights to fetch Customer Feedback records.',
          e.getMessage(),
          'Exception message was "' +
            e.getMessage() +
            '", expected "' +
            'Insufficient access rights to fetch Customer Feedback records.' +
            '"'
        );
      }
    }
  }

  /**
   * @description createMinimumAccessUser Creates a test user with minimum access to Customer_Feedback__c records
   * @return   return description
   */
  private static User createMinimumAccessUser(Boolean grantReadOnlyPermission) {
    // Check if the 'Minimum Access' profile exists, if not, create it
    List<Profile> profiles = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Minimum Access - Salesforce'
    ];
    Profile readOnlyProfile;

    if (profiles.isEmpty()) {
      throw new SecurityException(
        'No `Minimum Access - Salesforce` profile found'
      );
    } else {
      readOnlyProfile = profiles[0];
    }

    // Create a test user with the 'Minimum Access' profile
    User readOnlyUser = new User(
      Alias = 'eadonly',
      Email = 'eadonly@myorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Minimum Access',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = readOnlyProfile.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'eadonly@myorg.com'
    );
    insert readOnlyUser;

    if (grantReadOnlyPermission) {
      createPermissionSet(readOnlyUser);
    }

    return readOnlyUser;
  }

  /**
   * @description createPermissionSet Create required permissions for minimum access user.
   * @param  readOnlyUser readOnlyUser description
   */
  private static void createPermissionSet(User readOnlyUser) {
    if (
      !Schema.sObjectType.PermissionSet.isCreateable() ||
      !Schema.sObjectType.ObjectPermissions.isCreateable()
    ) {
      throw new SecurityException(
        'Insufficient access rights to create PermissionSet and ObjectPermissions records.'
      );
    }

    // Create a new permission set
    PermissionSet ps = new PermissionSet(
      Name = 'MinimumAccessPermission',
      Label = 'Minimum Access - Salesforce Permission'
    );
    insert ps;

    // Grant read-only access to the Customer_Feedback__c object
    insert new ObjectPermissions(
      ParentId = ps.Id,
      SobjectType = 'Customer_Feedback__c',
      PermissionsRead = true
    );

    // Grant read-only access to the Contact object
    insert new ObjectPermissions(
      ParentId = ps.Id,
      SobjectType = 'Contact',
      PermissionsRead = true
    );

    // Grant field-level permissions for Customer_Feedback__c
    createFieldLevelPermissions(readOnlyUser, ps.Id);

    // Assign user to the permission set
    insert new PermissionSetAssignment(
      AssigneeId = readOnlyUser.Id,
      PermissionSetId = ps.Id
    );
  }

  /**
   * @description createFieldLevelPermissions Creates field level permissions for minimum access user.
   * @param  readOnlyUser readOnlyUser User with minimum access
   * @param  psId         psId Permission set ID to assign to field permissions
   */
  private static void createFieldLevelPermissions(User readOnlyUser, Id psId) {
    if (!Schema.sObjectType.FieldPermissions.isCreateable()) {
      throw new SecurityException(
        'Insufficient access rights to create FieldPermissions records.'
      );
    }

    List<FieldPermissions> fieldPermissions = new List<FieldPermissions>();

    System.runAs(readOnlyUser) {
      if (
        !Schema.sObjectType.Customer_Feedback__c.fields.Feedback_Text__c.isAccessible()
      ) {
        fieldPermissions.add(
          new FieldPermissions(
            ParentId = psId,
            SObjectType = 'Customer_Feedback__c',
            Field = 'Customer_Feedback__c.Feedback_Text__c',
            PermissionsRead = true
          )
        );
      }
      if (
        !Schema.sObjectType.Customer_Feedback__c.fields.Sentiment__c.isAccessible()
      ) {
        fieldPermissions.add(
          new FieldPermissions(
            ParentId = psId,
            SObjectType = 'Customer_Feedback__c',
            Field = 'Customer_Feedback__c.Sentiment__c',
            PermissionsRead = true
          )
        );
      }
    }

    insert fieldPermissions;
  }
}
