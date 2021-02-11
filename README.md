# A robot for storing LinkedIn contacts into a CSV file

## Configuration

You need to provide your LinkedIn credentials so that the robot can log in.

### Create a `vault.json` file for the credentials

Create a new file: `/Users/<username>/vault.json`

```json
{
  "linkedin": {
    "username": "YOUR-LINKEDIN-USERNAME",
    "password": "YOUR-LINKEDIN-PASSWORD"
  }
}
```

### Point `devdata/env.json` to your `vault.json` file

```json
{
  "RPA_SECRET_MANAGER": "RPA.Robocloud.Secrets.FileSecrets",
  "RPA_SECRET_FILE": "/Users/<username>/vault.json"
}
```

## Example `contacts.csv` output

```csv
0,1,2,3
John,Smith,john.smith@accenture.com,4/13/2007
Mindy,Notreal,mindy.notreal@gmail.com,2/3/2007
...
```

## Notes

The robot uses the [Playwright](https://playwright.dev/)-based [Robot Framework Browser library](https://robotframework-browser.org/) in the default headless mode (you will not see the browser GUI when the robot is working).

The robot can not be run from Robocorp Cloud as LinkedIn will detect a "suspicious login attempt" (location-based check) and sends a verification code to your email.
