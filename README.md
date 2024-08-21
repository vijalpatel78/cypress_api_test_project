# Cypress Automation Setup and Test Execution Guide

## Prerequisite
Ensure that Node.js is installed on your system. You can download and install it from [Node.js Official Website](https://nodejs.org/en).

## Steps to Setup and Run Tests

1. **Clone or Download the Project:**
   - Clone the repository or download the project files to your local system.

2. **Navigate to the Project Directory:**
   - Open your terminal (or command prompt).
   - Change the directory to the project folder by running:
     ```sh
     cd /path/to/your/project
     ```

3. **Install Project Dependencies:**
   - Install the required dependencies using npm:
     ```sh
     npm install --legacy-peer-deps
     ```

4. **Run Automation Scripts with Cypress Dashboard:**
   - To execute automation scripts in different testing environments with the Cypress dashboard integrated, use one of the following commands:

     - For Production environment:
       ```sh
       npm run service-hub-production
       ```

     - For UAT01 environment:
       ```sh
       npm run service-hub-uat01
       ```

     - For DEV01 environment:
       ```sh
       npm run service-hub-dev01
       ```

5. **View Test Reports:**
   - After the tests have executed, you can view the test report by visiting the following link:
     [Cypress Dashboard Test Reports](https://cloud.cypress.io/projects/ewdgan/runs)

6. **Run Scripts Locally for Various Testing Environments:**
   - You can run the scripts locally for different environments using the following commands:

     - For Production environment:
       ```sh
       npx cypress open --env testingEnvironment="production",tags="@all and not @db"
       ```

     - For UAT01 environment:
       ```sh
       npx cypress open --env testingEnvironment="uat01",tags="@all"
       ```

     - For DEV01 environment:
       ```sh
       npx cypress open --env testingEnvironment="dev01",tags="@all"
       ```