Feature: GET Credit Memo Health v1 API

  Background: Testing environment
    Given the testing environment details are available
    And the endpoint of Credit Memo Health v1 API is available

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETCreditMemoHealthAPI @testcase_GCMH_01
  Scenario: Check 200 status, response time, and response message of Credit Memo Health v1 API

    When user triggers 'Get' Credit Memo Health 'v1' API
    Then the Credit Memo Health API should return 200 status code within 3 seconds
    And the Credit Memo Health API should give the following success message
      | message                    |
      | CreditMemos API is healthy |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETCreditMemoHealthAPI @testcase_GCMH_02
  Scenario: The API response should return application/json as the content-type in the header

    When user triggers 'Get' Credit Memo Health 'v1' API
    Then the Credit Memo Health API should return 200 status code within 3 seconds
    And the Credit Memo Health API should give the 'application/json' as the content-type

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETCreditMemoHealthAPI @testcase_GCMH_03
  Scenario: Check 404 status and response time when the endpoint of API is incorrect

    When user triggers 'Get' Credit Memo Health 'v1' API with the following endpoint
      | endpoint                       |
      | /customers/credits/health/test |
    Then the Credit Memo Health API should return 404 status code within 3 seconds

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETCreditMemoHealthAPI @testcase_GCMH_04
  Scenario: Check 401 status, response time, and response message when the API key is incorrect

    When user triggers 'Get' Credit Memo Health 'v1' API with 'VHQmOoPou5h7f7d2CE4XLdoYG7opRxKFM6c0' API key
    Then the Credit Memo Health API should return 401 status code within 3 seconds
    And the Credit Memo Health API should give the following error message
      | message                                                                |
      | You are not authorized or there was an issue with your authentication. |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETCreditMemoHealthAPI @testcase_GCMH_05
  Scenario: Check 401 status, response time, and response message when the API key is empty

    When user triggers 'Get' Credit Memo Health 'v1' API with '  ' API key
    Then the Credit Memo Health API should return 401 status code within 3 seconds
    And the Credit Memo Health API should give the following error message
      | message                                                                |
      | You are not authorized or there was an issue with your authentication. |
