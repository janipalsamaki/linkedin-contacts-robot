async function getHrefAttributeValues(page, args) {
  const selector = args[0];
  return await page.$$eval(selector, (elements) =>
    elements.map((element) => element.href)
  );
}

async function getTextIfExists(page, args) {
  try {
    return await page.innerText(args[0], { timeout: 1 });
  } catch (e) {
    return '';
  }
}

exports.__esModule = true;
exports.getHrefAttributeValues = getHrefAttributeValues;
exports.getTextIfExists = getTextIfExists;
