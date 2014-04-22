<ion-view title="Link">
  <ion-content class="has-header">
	<p class="padding">Tap an Issue to Link or Unlink to Case {{caseNumber}}</p>
    <ion-list>
      <ion-item ng-repeat="issue in issues" ng-click="toggleLink(issue.url)" class="no-arrow linked-{{issue.linked}}">
        <h2>{{issue.title}}</h2>
        <span class="issue-metadata">
          Opened by {{issue.user.login}} <span am-time-ago="issue.created_at"></span>.
          <div class="item-text-wrap">
            Currently <span class="issue-state-{{issue.state}}">{{issue.state}}</span>, with <ng-pluralize count="issue.comments"
                 when="{'0': 'no comments.', 'one': '1 comment.', 'other': '{} comments.'}"></ng-pluralize>
          </div>
        </span>
      </ion-item>
    </ion-list>
  </ion-content>
</ion-view>