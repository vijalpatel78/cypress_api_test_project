//run before all test cases
before(() => {
  //handle uncaught exceptions to make execution smooth
  Cypress.on('uncaught:exception', (err, runnable) => {
    //returning false here prevents Cypress from failing the test
    return false;
  });
});