---
title: Load Impact
---

Load Impact is an online load testing service that lets you load test your website over the Internet. It is a true On Demand service, where you can start testing instantly. All you need is [a URL and the press of a button](#creating-tests-single-url) to get started.

Use advanced scripting, multiple user scenarios and one or more of our 12 geographic load zones in the same test to create realistic user traffic patterns:

* Ashburn, US
* Chicago, US
* Dallas, US
* Dublin, Ireland
* London, UK
* Palo Alto, US
* Portland, US
* São Paulo, Brazil
* Singapore, Singapore
* Sydney, Australia
* Tokyo, Japan

Analyze your test results using our powerful reporting UI. Install the [Load Impact Server Metrics Agent](http://blog.loadimpact.com/2013/01/22/server-metrics-tutorial/) to collect server metrics during tests to help you pinpoint server issues.

## <a id='managing'></a>Managing Services ##

[Managing services from the command line](../../../using/services/managing-services.html)

### Creating a Service Instance ###

Create an account for your space from the command line with the following command:

<pre class="terminal">
$ cf create-service loadimpact
</pre>
    
Load Impact is not a bindable service.

### <a id='managing-sso'></a>Login to Load Impact using Single Sign On ###

Log into the [run.pivotal.io Web Console](https://console.run.pivotal.io/). Find your Load Impact service instance on the Space page in which you created it. Click the Manage button to log into your Load Impact account via SSO.

## <a id='creating-tests'></a>Creating tests ##

You can keep it simple or simulate complex user behavior when creating tests. We will start with the simplest and progress towards the more advanced.

### Terminology ###

<table>
    <thead>
        <tr>
            <th style="width:20%">Term</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Data store</td>
            <td>Upload a CSV file and get access to the data in the user scenario load script. Great for usernames/passwords, product IDs, URLs or anything really that you do not want to keep inline in your load script.</td>
        </tr>
        <tr>
            <td>Load script</td>
            <td>The part of the user scenario describing what this particular kind of user should be doing. Browsing, searching, placing items in a shopping cart or talking to a SOAP or REST API are examples of activities that you can simulate. Load scripts are written in the Lua programming language using Load Impact’s load script API.</td>
        </tr>
        <tr>
            <td>Load zone</td>
            <td>A geographic location from where Load Impact can generate user traffic.</td>
        </tr>
        <tr>
            <td>SBU</td>
            <td>A Simulated Browser User is a more advanced emulation, than the VU, of how a browser user behaves.</td>
        </tr>
        <tr>
            <td>Test configuration</td>
            <td>A specification for a load test; what user scenarios to include, from which load zones to run those user scenarios, how to ramp-up/down user traffic.</td>
        </tr>
        <tr>
            <td>Test result</td>
            <td>The results of running a test based on a test configuration.</td>
        </tr>
        <tr>
            <td>User scenario</td>
            <td>A load script and optionally an attached data store.</td>
        </tr>
        <tr>
            <td>VU</td>
            <td>A Virtual User is a simple emulation of a browser user with only one connection open at the time, no HTTP request parallelism.</td>
        </tr>
    </tbody>
</table>

### <a id='creating-tests-single-url'></a>Single URL and click Run ###

Once logged into you Load Impact account you end up on the "My tests" page. From there you can immediately get started with your testing:

1. Press the "Start a new test" button  

   ![Press button to show URL field](https://s3.amazonaws.com/loadimpact_cloudfoundry/my_tests_page.png "Press button to show URL field")  

2. Enter the URL of the page you want to test in the input field and press the "Start test" button  
     
   ![Enter URL and press start test button](https://s3.amazonaws.com/loadimpact_cloudfoundry/my_tests_page_expanded.png "Enter URL and press start test button")

### <a id='creating-tests-simple-config'></a>Simple configuration with no scripting ###

If you want some more control click on the "Advanced configuration" link in the form on "My tests" page or alternatively visit the "Test configurations" page and press the "Create test configuration" button:

![Press create test configuration button](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_configs_create_button.png "Press create test configuration button")

Once on the test configuration page you can change as much or little as you feel like. There is only one mandatory field, the "Target URL" field. Only filling in this field will result in a test configuration with the same settings as the one used to create the test from the "My tests" page.

![Test configuration page](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_config_create_page.png "Test configuration page")

Expand the "Load test execution plan" section if you wish to alter the number of users simulated during the test and how this traffic should ramp up and down.

![Expand load test execution plan section](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_config_create_page_load_plan.png "Expand load test execution plan section")

### <a id='creating-tests-full-config'></a>Full configuration with scripting ###

If you want more control of what your simulated users are doing during the load test you need to look into the different possible ways of generating a load script:

* **Auto-generation based on page analysis**  
  Basically what we have been doing up until now. The Load Impact Page Analyzer will analyze how a web browser would load the page and generate a load script for you.
* **Using the Load Impact Session Recorder**  
  A HTTP proxy based solution, can be used to record traffic from desktop as well as mobile devices. The recorded traffic is automatically converted to a load script.
* **Writing Lua code**  
  Not as scary as it may sound. Lua is a small, easy to use yet powerful programming language. Check out our quick start guide if you need more help.

Now, expand the “User scenarios” section:

![Expand user scenarios section](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_config_create_page_user_scenarios.png "Expand user scenarios section")

You may create up to 10 different user scenarios (we suggest you keep the user actions short and sweet!) and allocate varying load level percentages for each test. In the example below, we have allocated 70% of the users to simulate "Site Browsing" and 30% of the users to simulate "Login and Purchase" actions.

![Expand user scenarios section](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_config_create_page_user_scenarios_2x.png "Expand user scenarios section")

Pressing the "New user scenario" button shows you the User Scenario Editor. In the User Scenario Editor you get access to the Page Analyzer and Session Recorder mentioned above as well as our powerful load script editor:

![User scenario editor](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_config_user_scenario_editor.png "User scenario editor")

## <a id='test-results'></a>Test results ##

Test results are streamed in real-time from the load zones involved in the test to provide you with an up to the second view of what is happening during the test. The test result page is divided into sections with detailed data allowing you to drill down and find performance issues.

### <a id='test-results-overview'></a>Overview ###

The top of the result page gives you a quick overview of how your test is progressing current values for common metrics such as active users, bandwidth and requests/second.

![Test result overview](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_view_general.png "Test result overview")

### <a id='test-results-graphs'></a>Graphs ###

All metrics collected during a test are graphable. You choose what you want to graph, we have added active users and user load time by default. Using our load script API you can also collect [custom metrics](https://loadimpact.com/learning-center/load-script-api#result.custom_metric). These custom metrics could be anything from information available to you from the load script API like SSL handshake time to some metric that you extracted out of transaction responses from your web app's API.

![Test result graphs](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_view_graphs.png "Test result graphs")

### <a id='test-results-transactions'></a>Transactions ###

A table with all HTTP/HTTPS transactions performed during a test. Expand a row to see detailed transaction information.

![Test result HTTP transactions](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_view_transactions.png "Test result HTTP transactions")

### <a id='test-results-resource-types'></a>Resource types ###

Below the table listing all HTTP transactions you will find pie charts breaking down the URLs by content type.

![Test result URL content types](https://s3.amazonaws.com/loadimpact_cloudfoundry/test_view_pie.png "Test result URL resource types")

## <a id='support'></a>Support ##

Load Impact provides [extensive documentation](http://support.loadimpact.com/) to help you troubleshoot your tests and understand our service better. [Our blog](http://blog.loadimpact.com/) also provides case studies, comparison tests and mini tutorials to help you improve your load testing skills.

Should you have any questions please [contact us through our support center](http://support.loadimpact.com/), and make sure you have read the instructions at [Contacting Service Providers for Support](../contacting-service-providers-for-support.html) on what information to include in your support inquiry.

### <a id='support-faq'></a>FAQ ###

**Q**: Can I simulate users clicking through a series of pages?  
**A**: Absolutely! Our free Session Recorder will assist in creating a user scenario that simulates a user visiting several pages on a site. 

**Q**: Can browsing on sites with i.e. Javascript be simulated?  
**A**: Yes, our Session Recorder records all the requests sent when browsing sites using JavaScript and Flash, allowing us to emulate the execution of the script through the mimicking of the resulting requests. For all scripts, you can manually input dynamic parameters such as user logins or view states. 

**Q**: Can I test sites that require logins?  
**A**: Load Impact supports both HTTP authentication (basic, digest and NTLM) and HTTP POST operations, as well as HTTPS.  Simulating random or unique user logins is also possible.

**Q**: What is the difference between Simulated Browser Users (SBUs) and Virtual Users (VUs)?  
**A**: A Virtual User will only use a single network connection when loading resources from a target host. Resources can be loaded from multiple hosts in the same test, however, that will then result in one connection per target host, per VU. Simulated Browser Users, on the other hand, can use multiple concurrent network connections when loading resources from a single target host.

**Q**: I have Google Analytics - How many SBUs should I be load testing at?  
**A**: Google Analytics is a very popular means of keeping track of website traffic, but the stats are usually only reported as the number of visits per month. Capturing the peak traffic per hour and dividing that with the time spent on the site allows you to translate monthly visits to actual concurrent users (SBUs). 

**Q**: Do Server Metrics agents collect private server information?  
**A**: Absolutely not, our agents only collect performance metrics for the specific tests they are selected to run with. 

## <a id='external-links'></a>External Links ##
* [Knowledgebase](http://support.loadimpact.com/)
* [Load Script API Documentation](http://loadimpact.com/learning-center/load-script-api)
* [Load Impact Continuous Delivery API](http://developers.loadimpact.com/)
* [Load Impact Server Metrics Agent](http://blog.loadimpact.com/2013/01/22/server-metrics-tutorial/)
* [Load Impact Session Recorder](http://support.loadimpact.com/knowledgebase/articles/175462-what-is-the-session-recorder-and-how-does-it-work)
