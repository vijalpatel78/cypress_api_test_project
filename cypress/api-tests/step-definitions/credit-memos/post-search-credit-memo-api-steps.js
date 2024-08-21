const { Given, When, Then } = require('@badeball/cypress-cucumber-preprocessor');
const Ajv = require('ajv');

import CreditMemos from '../../functions/trigger-credit-memo-apis';

const creditMemos = new CreditMemos();
const ajv = new Ajv();

let actualResponse, endpoint, queryParams;

Given('the endpoint of Search Credit Memos v1 API is available', () => {
  endpoint = '';

  //get the endpoint of Search Credit Memo API from the fixtures folder
  cy.fixture('endpoints.json').then((data) => {
    endpoint = data.v1.creditMemos.searchCreditMemo;
  });
});

When('user triggers {string} Search Credit Memos {string} API', (testMethod, testAPIVersion, dataTable) => {
  const validKeys = ['accounts', 'searchTerm', 'page', 'pageSize'];
  queryParams = {}, actualResponse = '';

  //collect the query parameters and their values
  dataTable.hashes().forEach((row) => {
    const key = row.key;

    switch (key) {
      case 'accounts':
        queryParams.accounts = row.value === "" ? [] : row.value.split(",");
        break;
      case 'searchTerm':
        queryParams.searchTerm = row.value;
        break;
      case 'page':
        if (row.value === "0") {
          queryParams.page = 0;
        } else if (row.value.toLowerCase() === "null") {
          queryParams.page = null;
        } else if (row.value.includes('-')) {
          queryParams.page = -1;
        } else {
          queryParams.page = row.value;
        }
        break;
      case 'pageSize':
        if (row.value === "0") {
          queryParams.pageSize = 0;
        } else if (row.value.toLowerCase() === "null") {
          queryParams.pageSize = null;
        } else if (row.value.includes('-')) {
          queryParams.pageSize = -1;
        } else {
          queryParams.pageSize = row.value;
        }
        break;
      default:
        throw new Error(`The provided '${key}' key is not valid. Valid options are ${validKeys.join(', ')}.`);
    }
  });

  //trigger the Search Credit Memo API request 
  creditMemos.triggerSearchCreditMemosAPI(testMethod, testAPIVersion, endpoint, queryParams, '').then((response) => {
    //store the response
    actualResponse = response;
  });
});

Then('the Search Credit Memos API should return {int} status code within {int} seconds', (expectedStatus, expectedTime) => {
  //validate the API response status code
  expect(actualResponse.status).to.equal(expectedStatus);

  //validate the API response time
  expect(actualResponse.duration / 1000).to.be.lessThan(expectedTime);
});

Then('the response of Search Credit Memos API should match the schema', () => {
  //get the schema of Search Credit Memo API from the fixtures folder
  cy.fixture('v1/credit-memos/get-search-credit-memo-schema.json').then((expectedSchema) => {

    //validate the API response body against the schema
    const validate = ajv.compile(expectedSchema);
    const isValid = validate(actualResponse.body);
    expect(isValid).to.be.true;
  });
});

Then('the Search Credit Memos API should give the {string} as the content-type', (expectedContentType) => {
  const actualContentType = actualResponse.headers['content-type'];

  //validate the API should return the expected content type in the header
  expect(actualResponse).to.have.property('headers');
  expect(actualResponse.headers).to.have.property('content-type');
  expect(actualContentType).to.contain(expectedContentType);
});

Then('the response of Search Credit Memos API should match the database', () => {
  let sqlQuery = "SELECT DISTINCT CM.CreditMemoId, CM.PurchaseOrder, CM.BillToId, CM.ShipToId, CM.CreditMemoDate, CM.Amount, CM.Division, CM.Status FROM customers.CreditMemo CM INNER JOIN customers.CreditMemoLine CML ON CM.CreditMemoId = CML.CreditMemoId  Where (CM.ShipToId = '" + queryParams.accounts + "' OR CM.BillToId = '" + queryParams.accounts + "') AND (CML.Sku LIKE '%" + queryParams.searchTerm + "%' OR CML.ProductName LIKE '%" + queryParams.searchTerm + "%' OR CM.PurchaseOrder LIKE '%" + queryParams.searchTerm + "%' OR CM.CreditMemoId LIKE '%" + queryParams.searchTerm + "%') order by CM.CreditMemoDate desc";

  //get the data from the database as per the provided account and search term
  cy.sqlServer(sqlQuery).then(function (dbResult) {

    //check number of records found in the API response
    if (actualResponse.body.totalRecords === 1) {
      //validate only one record should be found in the database
      expect(dbResult).to.have.length(8);

      //validate the API response data against the database
      expect(actualResponse.body.data[0].creditMemoId).to.equal(dbResult[0]);
      expect(actualResponse.body.data[0].purchaseOrder).to.equal(dbResult[1]);
      expect(actualResponse.body.data[0].billTo).to.equal(dbResult[2]);
      expect(actualResponse.body.data[0].shipTo).to.equal(dbResult[3]);
      expect(actualResponse.body.data[0].amount.value).to.equal((dbResult[5]).toFixed(2));
      expect(actualResponse.body.data[0].amount.currency).to.equal('USD');
      expect(actualResponse.body.data[0].division).to.equal(dbResult[6]);
      if (dbResult[7] === 1) {
        expect(actualResponse.body.data[0].status).to.equal('Open');
      } else if (dbResult[7] === 2) {
        expect(actualResponse.body.data[0].status).to.equal('Closed');
      }
      cy.formateDate(dbResult[4], '-').then((formateDBDate) => {
        expect(actualResponse.body.data[0].creditMemoDate).to.equal(formateDBDate);
      });
    } else {
      //validate the number of records found in the API response against the database
      expect(actualResponse.body.totalRecords).to.have.eql(dbResult.length);

      //validate the API response data against the database
      dbResult.forEach((dbData) => {
        actualResponse.body.data.forEach((apiData) => {
          if (dbData[0] === apiData.creditMemoId) {
            expect(apiData.creditMemoId).to.equal(dbData[0]);
            expect(apiData.purchaseOrder).to.equal(dbData[1]);
            expect(apiData.billTo).to.equal(dbData[2]);
            expect(apiData.shipTo).to.equal(dbData[3]);
            expect(apiData.amount.value).to.equal((dbData[5]).toFixed(2));
            expect(apiData.amount.currency).to.equal('USD');
            expect(apiData.division).to.equal(dbData[6]);
            if (dbData[7] === 1) {
              expect(apiData.status).to.equal('Open');
            } else if (dbData[7] === 2) {
              expect(apiData.status).to.equal('Closed');
            }
            cy.formateDate(dbData[4], '-').then((formateDBDate) => {
              expect(apiData.creditMemoDate).to.equal(formateDBDate);
            });
          }
        });
      });
    }
  });

  //validate the success should be true and error should be null
  expect(actualResponse.body.success).to.be.true;
  expect(actualResponse.body.errors).to.null;
});

When('user triggers {string} Search Credit Memos {string} API without any query params', (testMethod, testAPIVersion) => {
  actualResponse = '';

  //trigger the Search Credit Memo API request 
  creditMemos.triggerSearchCreditMemosAPI(testMethod, testAPIVersion, endpoint, {}, '').then((response) => {
    //store the response
    actualResponse = response;
  });
});

Then('the Search Credit Memos API should give the {string} error message', (expectedErrorMessage) => {
  let errorMessages = [];

  //get displayed error messages
  actualResponse.body.Messages.forEach((item) => {
    errorMessages.push(item.Message)
  });

  //validate the API response error message
  expect(errorMessages).to.contain(expectedErrorMessage);
});

Then('the Search Credit Memos API should give the {string} message', (expectedMessage) => {
  //validate the API response message
  expect(actualResponse.body.Messages[0].Message).to.contain(expectedMessage);
});


Then('the Search Credit Memos API should return {string} records of {string} page with the following message', (expectedNumberOfRecords, expectedCurrentPage, dataTable) => {
  const expectedSuccessMessage = dataTable.rawTable[1].toString();

  //validate the current page value of API response
  expect(actualResponse.body.currentPage).to.equal(Number(expectedCurrentPage));

  //validate the total page value of API response
  expect(actualResponse.body.totalPages).to.equal(Math.ceil(actualResponse.body.totalRecords / Number(expectedNumberOfRecords)));

  //validate the total number of records in API response
  expect(actualResponse.body.data).to.have.length(Number(expectedNumberOfRecords));

  //validate the API response message
  expect(actualResponse.body.message).to.equal(expectedSuccessMessage);
});

When('user triggers {string} Search Credit Memos {string} API with {string} endpoint', (testMethod, testAPIVersion, endpoint, dataTable) => {
  const validKeys = ['accounts', 'searchTerm', 'page', 'pageSize'];
  queryParams = {}, actualResponse = '';

  //collect the query parameters and their values
  dataTable.hashes().forEach((row) => {
    const key = row.key;

    switch (key) {
      case 'accounts':
        queryParams.accounts = row.value === "" ? [] : row.value.split(",");
        break;
      case 'searchTerm':
        queryParams.searchTerm = row.value;
        break;
      case 'page':
        queryParams.page = row.value;
        break;
      case 'pageSize':
        queryParams.pageSize = row.value;
        break;
      default:
        throw new Error(`The provided '${key}' key is not valid. Valid options are ${validKeys.join(', ')}.`);
    }
  });

  //trigger the Search Credit Memo API request 
  creditMemos.triggerSearchCreditMemosAPI(testMethod, testAPIVersion, endpoint, queryParams, '').then((response) => {
    //store the response
    actualResponse = response;
  });
});


When('user triggers {string} Search Credit Memos {string} API with {string} API key', (testMethod, testAPIVersion, testAPIKey, dataTable) => {
  const validKeys = ['accounts', 'searchTerm', 'page', 'pageSize'];
  queryParams = {}, actualResponse = '';

  //collect the query parameters and their values
  dataTable.hashes().forEach((row) => {
    const key = row.key;

    switch (key) {
      case 'accounts':
        queryParams.accounts = row.value === "" ? [] : row.value.split(",");
        break;
      case 'searchTerm':
        queryParams.searchTerm = row.value;
        break;
      case 'page':
        queryParams.page = row.value;
        break;
      case 'pageSize':
        queryParams.pageSize = row.value;
        break;
      default:
        throw new Error(`The provided '${key}' key is not valid. Valid options are ${validKeys.join(', ')}.`);
    }
  });

  //trigger the Search Credit Memo API request 
  creditMemos.triggerSearchCreditMemosAPI(testMethod, testAPIVersion, endpoint, queryParams, testAPIKey).then((response) => {
    //store the response
    actualResponse = response;
  });
});

Then('the response of Search Credit Memos API should include the requested accounts', () => {
  let actualAccounts = [];

  //collect ship to and bill to accounts
  actualResponse.body.data.forEach((account) => {
    actualAccounts.push(account.shipTo);
    actualAccounts.push(account.billTo);
  });

  //validate the API response should include the requested accounts
  queryParams.accounts.forEach((expectedAccount) => {
    expect(expectedAccount).to.oneOf(actualAccounts)
  });
});
