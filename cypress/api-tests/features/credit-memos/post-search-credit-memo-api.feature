Feature: POST Search Credit Memos v1 API

  Background: Testing environment
    Given the testing environment details are available
    And the endpoint of Search Credit Memos v1 API is available

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_01
  Scenario Outline: Check response of Search Credit Memo v1 API against schema

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the response of Search Credit Memos API should match the schema

    Examples:
      | account_type | account_value | searchTerm_value |
      | VC           | 07793GA       | 220005           |
      | GL           | 271917        | 8580778          |
      | TL           | 212519        | 8641885          |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_02
  Scenario: The API response should return application/json as the content-type in the header

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value   |
      | accounts   | 10366TX |
      | searchTerm | 1       |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the Search Credit Memos API should give the 'application/json' as the content-type

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @db @testcase_PSCM_03
  Scenario: The API response should match the database

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the response of Search Credit Memos API should match the database

    Examples:
      | case                          | account_value | searchTerm_value                        |
      | search by credit memo ID      | 07793GA       | 219889                                  |
      | search by purchase order      | 07793GA       | 99PO00294814 / W714818                  |
      | search by sku                 | 07793GA       | S 5041AI                                |
      | search by product name        | 07793GA       | Choros Two-Tier Chandelier in Aged Iron |
      | search by partial search term | 07793GA       | 11101                                   |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_04
  Scenario: Check 400 status, response time, and response message when any query params are not provided

    When user triggers 'Post' Search Credit Memos 'v1' API without any query params
    Then the Search Credit Memos API should return 400 status code within 3 seconds
    And the Search Credit Memos API should give the 'No search term value was provided.' error message
    And the Search Credit Memos API should give the 'At least (1) customer account is required to perform your credit memo search request.' error message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_05
  Scenario Outline: Check 400 status, response time, and response message when the account or search term is empty

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memos API should return 400 status code within 3 seconds
    And the Search Credit Memos API should give the '<errorMessage>' error message

    Examples:
      | case              | account_value | searchTerm_value | errorMessage                                                                          |
      | search term empty | 07793GA       |                  | No search term value was provided.                                                    |
      | account empty     |               | 1                | At least (1) customer account is required to perform your credit memo search request. |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_06
  Scenario: Check 400 status, response time, and response message when both account and search term are empty

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value |
      | accounts   |       |
      | searchTerm |       |
    Then the Search Credit Memos API should return 400 status code within 3 seconds
    And the Search Credit Memos API should give the 'No search term value was provided.' error message
    And the Search Credit Memos API should give the 'At least (1) customer account is required to perform your credit memo search request.' error message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_07
  Scenario Outline: Check 404 status, response time, and response message when the account and/or search term are invalid

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memos API should return 404 status code within 3 seconds
    And the Search Credit Memos API should give the 'No credit memos found for the provided search term' message

    Examples:
      | case                                      | account_value     | searchTerm_value                           |
      | VC account with invalid search term       | 07793GA           | 0772323                                    |
      | GL account with invalid search term       | 271917            | CS45123702                                 |
      | TL account with invalid search term       | 212519            | 7772-PORMA7                                |
      | Invalid account with valid credit memo ID | 012373            | 8580778                                    |
      | Invalid account with valid purchase order | 01237GA           | 99PO00256920 / W540355                     |
      | Invalid account with valid sku            | 012373            | S 5041AI                                   |
      | Invalid account with valid product name   | 01237GA           | Choros Two-Tier Chandelier in Aged Iron    |
      | Invalid account and search term           | 0-CA,*Studio.Inc+ | 8*{&^<5,#.? / F`9} [~]:T;"1'!@$%(1-2_)+=12 |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_08
  Scenario Outline: Check 404 status and response time when the script is provided as search term or account number

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
    Then the Search Credit Memos API should return 404 status code within 3 seconds

    Examples:
      | case                     | account_value             | searchTerm_value          |
      | script as search term    | 10366TX                   | <script>alert();</script> |
      | script as account number | <script>alert();</script> | 219889                    |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_09
  Scenario Outline: The API should return records as per the provided page and page size

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value            |
      | accounts   | 10366TX          |
      | searchTerm | 1                |
      | page       | <page_value>     |
      | pageSize   | <pageSize_value> |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the Search Credit Memos API should return '<pageSize_value>' records of '<page_value>' page with the following message
      | message         |
      | <message_value> |

    Examples:
      | page_value | pageSize_value | message_value                         |
      | 2          | 20             | Successfully retrieved 20 CreditMemos |
      | 5          | 3              | Successfully retrieved 3 CreditMemos  |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_10
  Scenario: By default, the API should return 20 records of 1 page when page and page size are not provided

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the Search Credit Memos API should return '20' records of '1' page with the following message
      | message                               |
      | Successfully retrieved 20 CreditMemos |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_11
  Scenario Outline: By default, the API should return 20 records of 1 page when page and page size are empty or invalid

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value            |
      | accounts   | 07793GA          |
      | searchTerm | 1                |
      | page       | <page_value>     |
      | pageSize   | <pageSize_value> |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the Search Credit Memos API should return '20' records of '1' page with the following message
      | message                               |
      | Successfully retrieved 20 CreditMemos |

    Examples:
      | case    | page_value | pageSize_value |
      | Empty   | 0          | 0              |
      | Null    | null       | null           |
      | Invalid | -1         | -1             |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_12
  Scenario: By default, the API should return 50 records of 1 page on providing more than 50 value for the page size

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
      | pageSize   | 51      |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the Search Credit Memos API should return '50' records of '1' page with the following message
      | message                               |
      | Successfully retrieved 50 CreditMemos |

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_13
  Scenario: Check 404 status, response time, and response message on providing not existed page number

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
      | page       | 20000   |
      | pageSize   | 50      |
    Then the Search Credit Memos API should return 404 status code within 3 seconds
    And the Search Credit Memos API should give the 'No credit memos found for the provided search term' message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_14
  Scenario: Check 404 status and response time when the endpoint of API is incorrect

    When user triggers 'Post' Search Credit Memos 'v1' API with '/customers/credits/searchs' endpoint
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
    Then the Search Credit Memos API should return 404 status code within 3 seconds

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_15
  Scenario: Check 401 status, response time, and response message when the API key is incorrect

    When user triggers 'Post' Search Credit Memos 'v1' API with 'VHQmOoPou5h7f7d2CE4XLdoYG7opRxKFM6c0' API key
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
    Then the Search Credit Memos API should return 401 status code within 3 seconds
    And the Search Credit Memos API should give the 'You are not authorized or there was an issue with your authentication.' message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_16
  Scenario: Check 401 status, response time, and response message when the API key is empty

    When user triggers 'Post' Search Credit Memos 'v1' API with '  ' API key
      | key        | value   |
      | accounts   | 07793GA |
      | searchTerm | 1       |
    Then the Search Credit Memos API should return 401 status code within 3 seconds
    And the Search Credit Memos API should give the 'You are not authorized or there was an issue with your authentication.' message

  #--------------------------------------------------------------------------------------------------

  @all @v1 @creditMemos @POSTSearchCreditMemoAPI @testcase_PSCM_17
  Scenario Outline: The API should return the response of requested multiple accounts

    When user triggers 'Post' Search Credit Memos 'v1' API
      | key        | value              |
      | accounts   | <account_value>    |
      | searchTerm | <searchTerm_value> |
      | pageSize   | 50                 |
    Then the Search Credit Memos API should return 200 status code within 3 seconds
    And the response of Search Credit Memos API should include the requested accounts

    Examples:
      | account_type | account_value | searchTerm_value |
      | accounts     | 271917,212519 | 0                |
