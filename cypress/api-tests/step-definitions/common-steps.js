const { Given } = require('@badeball/cypress-cucumber-preprocessor');

let testEnv;

Given('the testing environment details are available', () => {
  testEnv = {};

  //get the base url and API key details
  cy.getAPIBaseUrl().then((testingBaseURL) => {
    cy.getAPIKey().then((testingAPIKey) => {
      testEnv.baseURL = testingBaseURL;
      testEnv.APIKey = testingAPIKey;
    });
  });
}); export { testEnv }