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