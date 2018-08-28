## salesforce-google-bigquery

Apex and Lightning based integration with Salesforce and Google BigQuery.

Read [this blog post](https://developer.salesforce.com/blogs/2018/08/integrate-google-bigquery-with-salesforce.html) to learn more about the demo.

## Table of Contents

-   Installation
    -   [Installing the demo using Salesforce DX](#installing-the-demo-using-salesforce-dx)
    -   [Installing the demo using an unlocked package](#installing-the-demo-using-an-unlocked-package)
-   [Configuration](#configuration)
-   [Code Highlights](#code-highlights)
-   [Additional Resources](#additional-resources)

## Installation

There are two ways to install Northern Trail Outfitters:

-   Using Salesforce DX
-   Using an unlocked package

### Installing the demo using Salesforce DX

This is the recommended installation option for developers who want to experience the example and the code.

1.  Authenticate with your hub org (if not already done):

    ```zsh
    sfdx force:auth:web:login -d -a myhuborg
    ```

1.  Clone this repository:

    ```zsh
    git clone https://github.com/muenzpraeger/salesforce-google-bigquery
    cd salesforce-google-bigquery
    ```

1.  Create a scratch org and provide it with an alias (bigquery):

    ```zsh
    sfdx force:org:create -s -f config/project-scratch-def.json -a bigquery
    ```

1.  Push the app to your scratch org:

    ```zsh
    sfdx force:source:push
    ```

1.  Assign the GoogleBigQuery permission set to the default user:

    ```zsh
    sfdx force:user:permset:assign -n GoogleBigQuery
    ```

1.  Open the scratch org:

    ```
    sfdx force:org:open
    ```

### Installing the demo using an unlocked package

This is the recommended option for non developers. Use this option if you want to experience the sample app but do not plan to modify the code.

1.  [Sign up](https://developer.salesforce.com/signup) for a developer edition.

1.  Enable My Domain. Follow the instructions to enable My Domain [here](https://trailhead.salesforce.com/projects/quickstart-lightning-components/steps/quickstart-lightning-components1).

1.  Click [this link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1I0000036sRFQAY) to install the BigQuery unlocked package into your developer edition org.

1.  Select **Install for All Users**. When prompted, make sure you grant access to the external sites (accounts.google.com and www.googleapis.com).

## Configuration

After the installation you've to add your Google Service Account credentials to the Salesforce org. For that custom metadata types are used.

From the JSON file of your service account credentials you'll need the *client_email* value as well as the *private_key* value. Remove *-----BEGIN PRIVATE KEY-----\n* and *\n-----END PRIVATE KEY-----\n* from the *private_key* value.

1. In **Setup**, type **Custom Metadata Types** in the Quick Find box and click **Custom Metadata Types**.
1. Click **Manage Records**.
1. Click **New**.
1. Fill in the fields as described:
    - Label: *Google BigQuery*
    - Google_OAuth2 Name: *Google_BigQuery*
    - Issuer: *client_email value from JSON file*
    - PKCS8: *private_key value from JSON file*
1. Save the record.
1. Select **BigQuery Demo** in the App Launcher.

The Apex classes [Futures](https://github.com/muenzpraeger/salesforce-google-bigquery/blob/master/force-app/main/default/classes/Futures.cls#L8) and [GoogleUiController](https://github.com/muenzpraeger/salesforce-google-bigquery/blob/master/force-app/main/default/classes/GoogleUiController.cls#L5) have to be updated with your specific BigQuery project ID.
