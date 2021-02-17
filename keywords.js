async function getHrefAttributeValues(page, args) {
  const selector = args[0];
  return await page.$$eval(selector, (elements) =>
    elements.map((element) => element.href)
  );
}

async function getTextIfExists(page, args) {
  const selector = args[0];
  try {
    return await page.innerText(selector, { timeout: 100 });
  } catch (e) {
    return '';
  }
}

exports.__esModule = true;
exports.getHrefAttributeValues = getHrefAttributeValues;
exports.getTextIfExists = getTextIfExists;
