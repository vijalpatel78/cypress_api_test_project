const { Given, When, Then } = require('@badeball/cypress-cucumber-preprocessor');
import CreditMemos from '../../../functions/trigger-credit-memo-apis';

const creditMemos = new CreditMemos();

let actualResponse, endpoint;

Given('the endpoint of Credit Memo Health v1 API is available', () => {
  endpoint = '';

  //get the endpoint of Credit Memo Health API from the fixtures folder
  cy.fixture('endpoints.json').then((data) => {
    endpoint = data.v1.creditMemos.creditMemoHealth;
  });
});

When('user triggers {string} Credit Memo Health {string} API', (testMethod, testAPIVersion) => {
  actualResponse = '';

  //trigger the Credit Memo Health API request 
  creditMemos.triggerCreditMemoHealthAPI(testMethod, testAPIVersion, endpoint, '').then((response) => {
    //store the response
    actualResponse = response;
  });
});

When('user triggers {string} Credit Memo Health {string} API with {string} API key', (testMethod, testAPIVersion, testAPIKey) => {
  actualResponse = '';

  //trigger the Credit Memo Health API request 
  creditMemos.triggerCreditMemoHealthAPI(testMethod, testAPIVersion, endpoint, testAPIKey).then((response) => {
    //store the response
    actualResponse = response;
  });
});

When('user triggers {string} Credit Memo Health {string} API with the following endpoint', (testMethod, testAPIVersion, dataTable) => {
  const endpoint = dataTable.rawTable[1].toString();
  actualResponse = '';

  //trigger the Credit Memo Health API request 
  creditMemos.triggerCreditMemoHealthAPI(testMethod, testAPIVersion, endpoint, '').then((response) => {
    //store the response
    actualResponse = response;
  });
});

Then('the Credit Memo Health API should return {int} status code within {int} seconds', (expectedStatus, expectedTime) => {
  //validate the API response status code
  expect(actualResponse.status).to.equal(expectedStatus);

  //validate the API response time
  expect(actualResponse.duration / 1000).to.be.lessThan(expectedTime);
});

Then('the Credit Memo Health API should give the following success message', (dataTable) => {
  const expectedSuccessMessage = dataTable.rawTable[1].toString();

  //validate the API response message
  expect(actualResponse.body).to.equal(expectedSuccessMessage);
});

Then('the Credit Memo Health API should give the following error message', (dataTable) => {
  const expectedErrorMessage = dataTable.rawTable[1].toString();

  //validate the API response message
  expect(actualResponse.body.Messages[0].Message).to.equal(expectedErrorMessage);
});

Then('the Credit Memo Health API should give the {string} as the content-type', (expectedContentType) => {
  const actualContentType = actualResponse.headers['content-type'];

  //validate the API should return the expected content type in the header
  expect(actualResponse).to.have.property('headers');
  expect(actualResponse.headers).to.have.property('content-type');
  expect(actualContentType).to.equal(expectedContentType);
});
