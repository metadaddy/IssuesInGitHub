# IssuesInGitHub

Link GitHub issues to Cases in Salesforce1

[Install the Unmanaged Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tE00000001YsN) - read the installation instructions below!

Imagine you're working on a product that has some or all of its code in a GitHub repository. This app integrates GitHub Issues with Cases in Salesforce. As a user, I can browse open issues assigned to me, link them to cases, and see the link on the Case record. The app does OAuth against GitHub, obtaining an access token to call the GitHub REST API and retrieve issues and comments.

## Preparation

You will need a GitHub account. If you do not already have one, you can sign up [here](https://github.com). You will also need to create a repository on GitHub. If you already have a repository with issues, then great - use that; otherwise, [create a new repository](https://github.com/new). Create some issues in the new repository and assign them to yourself (select them in the issues screen for your repository, click 'assignee' and select yourself).

You will also need to create a GitHub app specific to your org. [Register a new application on GitHub](https://github.com/settings/applications/new), and enter:

* **Application Name:** Issues in Github
* **Homepage URL:** `https://github.com/metadaddy-sfdc/IssuesInGitHub`
* **Application description:** Link GitHub issues to Cases in Salesforce1
* **Authorization callback URL:** `https://instance.salesforce.com/apex/github_callback_html`

**IMPORTANT:** Replace `instance` as appropriate for your DE org - e.g. na15.

Keep the GitHub app window around - you'll need to copy Client ID and Client Secret.

To install the app into a DE org, click the 'Install Unmanaged Packed' at the top of this README.

You will need to add the app's tab to the left nav menu - go to **Setup | Mobile Administration | Mobile Navigation**, move 'Issues in GitHub' to the 'Selected' list, click 'Up' to move it just after 'Groups', and click 'Save'.

Now add the GitHub link and publisher action to the Case Page Layout. Go to **Setup | Customize | Cases | Case Layouts**, and click 'Edit' next to 'Case Layout'. Drag the 'GitHub Link' field and drop it under 'Case Number' in the 'Case Information' section. Click 'Actions' in the palette, drag 'Link to GitHub Issue' and drop it in the 'Publisher Actions' between 'Post' and 'Log a Call'. 

Save the page layout.

You will also need to create a Custom Setting record with the app's Github credentials. Go to **Setup | Develop | Custom Settings**, click 'Manage' next to 'GitHub App Settings' and create a new record with:

* **Name:** Github App
* **Client Id:** copy from GitHub app window
* **Client Secret:** copy from GitHub app window

In your DE org, pin 'Cases' to the top of the Search results - in the regular browser interface to your DE org, search for any text you like, hover over the 'Cases' entry in the 'Records' list on the left, and click the pin that appears. Cases will move to the top of the Records list. This just makes it easier to find cases during the demo.

The app writes a GitHub access token to your user record. Between demos, you will need to delete the access token to be able to show authorization with GitHub. Go to your User record in your DE org (**Setup | Manage Users | Users |** click your user's name), click 'Edit', then scroll down to the 'Additional Information' section and delete the GitHubAccessToken value. Hit 'Save'.

Show the app on a real phone if you can (using [AirServer](http://www.airserver.com/) or [Reflector](http://www.airsquirrels.com/reflector/) to show your phone's screen on your laptop). Next best is to use the iOS simulator. If you have to use your laptop browser, use Chrome and [enable mobile emulation](https://developers.google.com/chrome-developer-tools/docs/mobile-emulation) - this will correctly generate the touch events that Salesforce1 is expecting.

Run through the demo at least a couple of times, and leave some issues linked to cases.

## Running through the app

In the Salesforce1 Mobile App, open the left nav menu, and select 'Issues in GitHub'. If you deleted your GitHub access token (see 'Preparation', above), you should see a login page with the GitHub logo.

![Login to GitHub](http://metadaddy-sfdc.github.io/IssuesInGitHub/LoginToGithub.PNG)

Touch the logo, and you will be prompted to log in to GitHub, and authorize the app to access your data. 

![Authorize App](http://metadaddy-sfdc.github.io/IssuesInGitHub/AuthorizeApp.PNG)

Don't worry if it skips the login page and goes straight to authorization - if you've been round this loop, the browser has your GitHub cookie - it's not important for the demo flow. Also, if you don't see the GitHub authorization screen within a few seconds, just close the window and touch the GitHub logo again - occasionally this page seems to glitch.

Once you've authorized the app, you should see a list of issues from GitHub. 

![Issue List](http://metadaddy-sfdc.github.io/IssuesInGitHub/IssueList.PNG)

This JavaScript single-page app, running on a Visualforce page in Salesforce1, is retrieving this data directly from GitHub, without hitting the Apex controller.

Note that it will only show open issues assigned to you, so if you see an empty list of issues, go create some in GitHub and assign them to yourself (see 'Preparation', above). You can touch an issue to drill down and see more detail, including any comments posted to the issue, and any cases that the issue is linked to. 

![Issue Detail](http://metadaddy-sfdc.github.io/IssuesInGitHub/IssueDetail.PNG)

You can touch a linked case to go to its record detail page - seamless integration between the app and Salesforce1.

![Case](http://metadaddy-sfdc.github.io/IssuesInGitHub/Case.PNG)

Now let's link an issue to a case. Open the left nav menu, and select 'Cases' (it should be visible at the top of the 'Recent' sub menu - if not, you'll need to pin it in the Search results - see 'Preparation', above). Select a Case, and open the publisher (plus sign on bottom right of screen). 

![Publisher Actions](http://metadaddy-sfdc.github.io/IssuesInGitHub/PublisherActions.PNG)

Select 'Link to GitHub Issue' and you should see a list of issues. 

![Link Issue](http://metadaddy-sfdc.github.io/IssuesInGitHub/LinkIssue.PNG)

This time, touching an issue will select it for linking to the case. A link icon indicates the selected issue. You can play around in this screen a little - the icon will move to the last touched issue, and touching the linked issue will deselect it.

When you've selected an issue, touch 'Submit' at the top of the screen. You'll be taken back to the Case record, which will refresh. Swipe left to see the Case detail, and scroll down to the 'GitHub Link' field. 

![Case Detail](http://metadaddy-sfdc.github.io/IssuesInGitHub/CaseDetail.PNG)

Touch 'View GitHub Issue' and the detail page for the linked issue should appear. 

![Linked Issue](http://metadaddy-sfdc.github.io/IssuesInGitHub/LinkedIssue.PNG)

Notice that the linked case is listed on the issue detail. Note that, currently, the 'spinner' stays active, even though the detail page has loaded. I'm investigating why this is the case - it might be fixed by the time you run through this.

## Exploring the code

I'll highlight the important integration points, examine the code if you want to to dig deeper.

Start on the [github_app_html](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/pages/github_app_html.page) Visualforce Page. Check out the `<apex:page>` attributes - we're using `showHeader="false"`, `sidebar="false"`, `standardStylesheets="false"` and `applyHtmlTag="false"` to get complete control over the page.

The app uses [AngularJS](https://angularjs.org/) and [Ionic](http://ionicframework.com/) - the CSS and JavaScript for this is loaded from static resources. AngularJS is a client-side MVC framework - it allows you to divide up your JavaScript app into modules. You can see the includes for the modules in github_app_html under the `"<!-- the app's js -->"` comment. You can also see where the app gets the GitHub API access token from the Visualforce Page's Apex controller, in the `{!accessToken}` merge field.

Open that Apex controller - the [GithubController](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/classes/GithubController.cls) class. The Apex controller reads the access token from the User record in its constructor. Notice in the 'onLoad' action method, if there is no access token, the onLoad method returns a redirect to the login page. The Visualforce Page runs this action method before it renders the page - this is what activates the GitHub OAuth login. We won't go down the OAuth rabbit hole here, but the code is all there if anyone wants to take a look.

Back on the github_app_html Visualforce Page, scroll down to the bottom - the `<ion-nav-view>` element is where the app content will be rendered. This app comprises a number of views that can be dynamically loaded from templates.

Open the [github_app_js](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/staticresources/github_app_js.resource) static resource - this is where the app is configured. Scroll down and you'll see a set of 'states' that associate a url with a template and controller, all broken down into their own static resource files. You can see the states for the issue list, issue detail, and link views.

Open the [github_issues_html](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/staticresources/github_issues_html.resource) static resource. Notice the `<ion-list>`, containing an `<ion-item>`, with an `ng-repeat` attribute. This is very similar to a Visualforce `<apex:repeat>` - we're iterating through a list of issues, showing some fields from each one. Notice the link - it has a # prefix - we don't want to go to a different page to see issue detail; we want to show a different view, and the # is followed by a path, containing an encoded issue url. When the user touches the list item, that link will be followed, loading the issue detail view.

Open the [github_controllers_js](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/staticresources/github_controllers_js.resource) static resource. The first controller, IssuesCtrl, simply loads all issues from the Issues service. In AngularJS, controllers simply marshall data into the template - services retrieve data.

Open the [github_services_js](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/staticresources/github_services_js.resource) static resource. The 'all' function retrieves a list of issues from GitHub. Skip past the error handling to see where it caches the issue list, and builds a map so that issues are easily accessible to the app from their URL without going back to the GitHub API. This function uses [promises](https://docs.angularjs.org/api/ng/service/$q) to simplify asynchronous programming. The function returns a promise that the caller can use to get the data later, without building a stack of callbacks.

Open the [github_link_html](https://github.com/metadaddy-sfdc/IssuesInGitHub/blob/master/metadata/pages/github_link_html.page) Visualforce Page. This is the publisher action for linking an issue to a case. Since it runs in the context of a Case record, it uses the Case standard controller, but we define GithubController as an extension. Scroll down and you'll see that the HTML is almost identical to github_app_html, except that we pull data from the Apex controller (the `{!case.Id}`, `{!case.CaseNumber}` and `{!case.GitHub_Issue__c}` merge fields) and add it to the AngularJS root scope so that it is accessible to the AngularJS controllers.

A little lower down, you can see the integration with Salesforce1. We use the publisher library, activating the 'Submit' button in the `publisher.showPanel` handler, and, when the user hits submit, we call the attachIssue method on GithubController to attach that issue to the case. Go to the GithubController class and scroll down to the attachIssue method - it's really very simple.

Now look at the 'Buttons, Links & Actions' page for Case. You'll see the publisher action there. Click its 'Edit' link and you'll see the Visualforce page there. Now go to the Case 'Page Layout' and point out the action in the list of publisher actions.

There are quite a few moving parts here, but the end result is a very seamless user experience. With this app in Salesforce1, the user can move between issues from GitHub and Cases from Salesforce in a very natural way.