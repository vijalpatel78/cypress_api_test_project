const { defineConfig } = require('cypress');
const preprocessor = require('@badeball/cypress-cucumber-preprocessor');
const browserify = require('@badeball/cypress-cucumber-preprocessor/browserify');
const sqlServer = require('cypress-sql-server');

async function setupNodeEvents(on, config) {
  const dbName = config.env.testingEnvironment.toLowerCase() === 'dev01' ? config.env.dev01DBName : config.env.uat01DBName;

  //sql db setup
  config.db = {
    userName: 'api01',
    password: '018slUR#l*aZrY',
    server: 'skwebdbdev101',
    options: {
      database: dbName,
      encrypt: false,
      rowCollectionOnRequestCompletion: true
    }
  }
  tasks = sqlServer.loadDBPlugin(config.db);
  on('task', tasks);

  //cucumber setup
  await preprocessor.addCucumberPreprocessorPlugin(on, config);
  on('file:preprocessor', browserify.default(config));

  return config;
}

//default configurations
module.exports = defineConfig({
  e2e: {
    setupNodeEvents,
    specPattern: ['cypress/api-tests/features/**/*.feature']
  },
  projectId: 'ewdgan',
  responseTimeout: 15000,
  retries: {
    runMode: 1
  },
  env: {
    testingEnvironment: 'UAT01',
    apiKey: 'NHQmOoPou5h7f7d2CE4XLdoYG7opRxKFM6c0RV6JQvCN3goVVJdzrRBZuQUu6XV01c',
    uat01BaseURL: 'https://uat01-api.visualcomfortco.com/',
    dev01BaseURL: 'https://dev01-api.visualcomfortco.com/',
    productionBaseURL: 'https://production-api.visualcomfortco.com/',
    uat01DBName: 'ServiceHub-UAT01',
    dev01DBName: 'ServiceHub-DEV01',
  }
});