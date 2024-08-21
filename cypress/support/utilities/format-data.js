//return the formatted MM-DD-YYYY date 
Cypress.Commands.add('formateDate', (date, symbol) => {
  const providedDate = new Date(date);

  //extract the year, month, and day components of the date
  const year = providedDate.getFullYear();
  const month = String(providedDate.getMonth() + 1).padStart(2, '0');
  const day = String(providedDate.getDate()).padStart(2, '0');

  //return the formatted MM DD YYYY date 
  return `${month}${symbol}${day}${symbol}${year}`;
});