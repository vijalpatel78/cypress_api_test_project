import { testEnv } from '../step-definitions/common-steps';

class CreditMemos {

  //trigger the Get Credit Memo Health API request 
  triggerCreditMemoHealthAPI(testMethod, testAPIVersion, endpoint, testAPIKey = '') {
    const APIKey = testAPIKey === '' ? testEnv.APIKey : testAPIKey;

    return cy.request({
      method: testMethod.toUpperCase(),
      url: testEnv.baseURL + testAPIVersion.toLowerCase() + endpoint,
      failOnStatusCode: false,
      headers: {
        "x-api-key": APIKey
      }
    });
  }

  //trigger the Get Search Credit Memo API request 
  triggerSearchCreditMemoAPI(testMethod, testAPIVersion, endpoint, queryParams, testAPIKey = '') {
    const APIKey = testAPIKey === '' ? testEnv.APIKey : testAPIKey;

    if (queryParams) {
      Object.keys(queryParams).forEach((key, index) => {
        endpoint += (index === 0 ? '?' : '&');
        endpoint += `${key}=${queryParams[key]}`;
      });
    }

    return cy.request({
      method: testMethod.toUpperCase(),
      url: testEnv.baseURL + testAPIVersion.toLowerCase() + endpoint,
      failOnStatusCode: false,
      headers: {
        "x-api-key": APIKey
      }
    });
  }

  //trigger the Post Search Credit Memo API request 
  triggerSearchCreditMemosAPI(testMethod, testAPIVersion, endpoint, queryParams, testAPIKey = '') {
    const APIKey = testAPIKey === '' ? testEnv.APIKey : testAPIKey;

    return cy.request({
      method: testMethod.toUpperCase(),
      url: testEnv.baseURL + testAPIVersion.toLowerCase() + endpoint,
      failOnStatusCode: false,
      headers: {
        "x-api-key": APIKey
      },
      body: queryParams
    });
  }

} export default CreditMemos