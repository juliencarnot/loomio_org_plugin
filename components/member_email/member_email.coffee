angular.module('loomioApp').directive 'memberEmail', (AbilityService) ->
  scope: {membership: '='}
  templateUrl: 'generated/components/member_email/member_email.html'
  controller: ($scope) ->
    $scope.canSeeEmail = ->
      AbilityService.canAdministerGroup($scope.membership.group()) and
      $scope.membership.group().parentOrSelf().subscriptionKind == 'paid'
