/*  This support/e2e.js file is processed and loaded automatically before all test files.
*/

import sqlServer from 'cypress-sql-server';
import './utilities/read-cypress-config-data';
import './utilities/format-data';
import './test-hooks/before-test-hook';

sqlServer.loadDBCommands();