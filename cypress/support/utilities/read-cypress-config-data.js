//return the API testing environment
Cypress.Commands.add('getAPITestingEnvironment', () => {
  const testingEnvironment = Cypress.env('testingEnvironment');
  const validEnvironments = ['uat02', 'dev02', 'production'];

  if (validEnvironments.includes(testingEnvironment.toLowerCase())) {
    return testingEnvironment.toLowerCase();
  } else {
    throw new Error(`The provided '${testingEnvironment}' testing environment is not valid. Valid options are ${validEnvironments.join(', ')}.`);
  }
});

//return the API base url
Cypress.Commands.add('getAPIBaseUrl', () => {
  cy.getAPITestingEnvironment().then((testingEnvironment) => {

    switch (testingEnvironment) {
      case 'uat02':
        return Cypress.env('uat02BaseURL');
      case 'dev02':
        return Cypress.env('dev02BaseURL');
      case 'production':
        return Cypress.env('productionBaseURL');
    }
  });
});

//return the API key
Cypress.Commands.add('getAPIKey', () => {
  return Cypress.env('apiKey');
});