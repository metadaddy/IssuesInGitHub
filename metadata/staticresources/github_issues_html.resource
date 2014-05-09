<ion-view title="Issues">
  <ion-content class="has-header">
    <ion-list>
      <ion-item ng-repeat="issue in issues" href="#/issue?issueId={{issue.url | encodeURIComponent}}">
        <h2>{{issue.title}}</h2>
        <span class="issue-metadata">
          Opened by {{issue.user.login}} <span am-time-ago="issue.created_at"></span>.
          <div class="item-text-wrap">
            Currently <span class="issue-state-{{issue.state}}">{{issue.state}}</span>, with <ng-pluralize count="issue.comments"
                 when="{'0': 'no comments.', 'one': '1 comment.', 'other': '{} comments.'}"></ng-pluralize>
          </div>
          <div class="item-text-wrap">
            <ng-pluralize count="issue.cases.length"
                 when="{'0': 'No linked cases', 'one': '1 linked case', 'other': '{} linked cases'}"></ng-pluralize>
          </div>
        </span>
      </ion-item>
    </ion-list>
  </ion-content>
</ion-view>