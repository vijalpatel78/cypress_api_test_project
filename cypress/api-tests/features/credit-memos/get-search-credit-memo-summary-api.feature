Feature: GET Search Credit Memo Summary v1 API

  Background: Testing environment
    Given the testing environment details are available
    And the endpoint of Search Credit Memo Summary v1 API is available

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_01
  Scenario Outline: Check response of Search Credit Memo Summary v1 API against schema

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value              |
      | account    | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the response of Search Credit Memo Summary API should match the schema

    Examples:
      | account_type | account_value | searchTerm_value |
      | VC           | 10366TX       | 219570           |
      | GL           | 45046         | ST37805          |
      | TL           | 232798        | 4236214-1        |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_02
  Scenario: The API response should return application/json as the content-type in the header

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'application/json' as the content-type

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @db @testcase_GSCMS_03
  Scenario: The API response should match the database

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value              |
      | account    | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the response of Search Credit Memo Summary API should match the database

    Examples:
      | case                          | account_value | searchTerm_value                                             |
      | search by credit memo ID      | 10366TX       | 212354                                                       |
      | search by purchase order      | 10366TX       | S2286261                                                     |
      | search by sku                 | 10366TX       | JN 2075ABL-L                                                 |
      | search by product name        | 10366TX       | Iberia Single Sconce in Antique Bronze Leaf with Linen Shade |
      | search by partial search term | 10366TX       | 101                                                          |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_04
  Scenario: Check 400 status, response time, and response message when any query params are not provided

    When user triggers 'Get' Search Credit Memo Summary 'v1' API without any query params
    Then the Search Credit Memo Summary API should return 400 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'No search term value was provided.' error message
    And the Search Credit Memo Summary API should give the 'Customer account is required to perform your credit memo summary search request.' error message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_05
  Scenario Outline: Check 400 status, response time, and response message when the account or search term is empty

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value              |
      | account    | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memo Summary API should return 400 status code within 3 seconds
    And the Search Credit Memo Summary API should give the '<errorMessage>' error message

    Examples:
      | case              | account_value | searchTerm_value | errorMessage                                                                     |
      | search term empty | 10366TX       |                  | No search term value was provided.                                               |
      | account empty     |               | 1                | Customer account is required to perform your credit memo summary search request. |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_06
  Scenario: Check 400 status, response time, and response message when both account and search term are empty

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value |
      | account    |       |
      | searchTerm |       |
    Then the Search Credit Memo Summary API should return 400 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'No search term value was provided.' error message
    And the Search Credit Memo Summary API should give the 'Customer account is required to perform your credit memo summary search request.' error message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_07
  Scenario Outline: Check 404 status, response time, and response message when the account and/or search term are invalid

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value              |
      | account    | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memo Summary API should return 404 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'No records found for the provided search term' message

    Examples:
      | case                                      | account_value     | searchTerm_value                                             |
      | VC account with invalid search term       | 10366TX           | 0772323                                                      |
      | GL account with invalid search term       | 45046             | CS45123702                                                   |
      | TL account with invalid search term       | 232798            | 7772-PORMA7                                                  |
      | Invalid account with valid credit memo ID | 012373            | 8580778                                                      |
      | Invalid account with valid purchase order | 01237GA           | 99PO00256920 / W540355                                       |
      | Invalid account with valid sku            | 01237GA           | JN 2075ABL-L                                                 |
      | Invalid account with valid product name   | 01237GA           | Iberia Single Sconce in Antique Bronze Leaf with Linen Shade |
      | Invalid account and search term           | 0-CA,*Studio.Inc+ | 8*{&^<5,#.? / F`9} [~]:T;"1'!@$%(1-2_)+=12                   |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_08
  Scenario Outline: Check 404 status and response time when the script is provided as search term or account number

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value              |
      | account    | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memo Summary API should return 404 status code within 3 seconds

    Examples:
      | case                     | account_value             | searchTerm_value          |
      | script as search term    | 10366TX                   | <script>alert();</script> |
      | script as account number | <script>alert();</script> | 219889                    |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_09
  Scenario Outline: The API should return records as per the provided page and page size

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value            |
      | account    | 10366TX          |
      | searchTerm | 1                |
      | page       | <page_value>     |
      | pageSize   | <pageSize_value> |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the Search Credit Memo Summary API should return '<pageSize_value>' records of '<page_value>' page with the following message
      | message         |
      | <message_value> |

    Examples:
      | page_value | pageSize_value | message_value                         |
      | 2          | 20             | Successfully retrieved 20 CreditMemos |
      | 5          | 3              | Successfully retrieved 3 CreditMemos  |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_10
  Scenario: By default, the API should return 4 records of 1 page when page and page size are not provided

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the Search Credit Memo Summary API should return '4' records of '1' page with the following message
      | message                              |
      | Successfully retrieved 4 CreditMemos |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_11
  Scenario Outline: By default, the API should return 4 records of 1 page when page and page size are empty or invalid

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value            |
      | account    | 10366TX          |
      | searchTerm | 1                |
      | page       | <page_value>     |
      | pageSize   | <pageSize_value> |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the Search Credit Memo Summary API should return '4' records of '1' page with the following message
      | message                              |
      | Successfully retrieved 4 CreditMemos |

    Examples:
      | case    | page_value | pageSize_value |
      | Empty   |            |                |
      | Null    | null       | null           |
      | Invalid | -1         |                |
      | Invalid | 2.3        | 40.23          |
      | Invalid | 0          | 0              |
      | Invalid | 5_H=9+$0   | 3(0)-JK?7      |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_12
  Scenario: By default, the API should return 50 records of 1 page on providing more than 50 value for the page size

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value   |
      | account    | 07793GA |
      | searchTerm | 1       |
      | pageSize   | 51      |
    Then the Search Credit Memo Summary API should return 200 status code within 3 seconds
    And the Search Credit Memo Summary API should return '50' records of '1' page with the following message
      | message                               |
      | Successfully retrieved 50 CreditMemos |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_13
  Scenario: Check 404 status, response time, and response message on providing not existed page number

    When user triggers 'Get' Search Credit Memo Summary 'v1' API
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
      | page       | 20000   |
      | pageSize   | 50      |
    Then the Search Credit Memo Summary API should return 404 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'No records found for the provided search term' message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_14
  Scenario: Check 404 status and response time when the endpoint of API is incorrect

    When user triggers 'Get' Search Credit Memo Summary 'v1' API with '/customers/credits/summary/searchs' endpoint
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memo Summary API should return 404 status code within 3 seconds

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_15
  Scenario: Check 401 status, response time, and response message when the API key is incorrect

    When user triggers 'Get' Search Credit Memo Summary 'v1' API with 'VHQmOoPou5h7f7d2CE4XLdoYG7opRxKFM6c0' API key
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memo Summary API should return 401 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'You are not authorized or there was an issue with your authentication.' message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @GETSearchCreditMemoSummaryAPI @testcase_GSCMS_16
  Scenario: Check 401 status, response time, and response message when the API key is empty

    When user triggers 'Get' Search Credit Memo Summary 'v1' API with '  ' API key
      | key        | value   |
      | account    | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memo Summary API should return 401 status code within 3 seconds
    And the Search Credit Memo Summary API should give the 'You are not authorized or there was an issue with your authentication.' message
