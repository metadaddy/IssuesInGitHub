<!--
  This template loads for the 'issue-detail' state (app.js)
  'issue' is a $scope variable created in the IssuesCtrl controller (github_controllers_js)
  The IssuesCtrl pulls data from the Issues service (github_services_js)
  The Issues service returns an array of issue data
-->
<ion-view title="Issue">
  <ion-content has-header="true" padding="true">
    <ion-list>
      <ion-item class="item-text-wrap">
        <h2>{{issue.title}}</h2>
        Opened by {{issue.user.login}} <span am-time-ago="issue.created_at"></span>
      </ion-item>
      <ion-item class="item-text-wrap">
        <h2>Status</h2>
        <span class="issue-state-{{issue.state}}">{{issue.state}}</span>
      </ion-item>
      <ion-item class="item-text-wrap">
        {{issue.body}}
      </ion-item>
      <h4 ng-if="cases">Linked to cases</h4>
      <ion-item ng-if="linkToCases" ng-repeat="case in cases" href="javascript:navigateToSObject('{{case.Id}}')">
        {{case.CaseNumber}}
      </ion-item>
      <ion-item ng-if="! linkToCases" ng-repeat="case in cases">
        {{case.CaseNumber}}
      </ion-item>
      <h4 ng-if="issue.comments">Comments</h4>
      <ion-item ng-repeat="comment in comments" class="item-text-wrap">
        <span class="issue-login">{{issue.user.login}}</span> commented <span am-time-ago="comment.created_at"></span>
        <div class="issue-comment item-text-wrap">
          {{comment.body}}
        </div>
      </ion-item>
    </ion-list>
  </ion-content>
</ion-view>
