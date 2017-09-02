angular.module('loomioApp').directive 'memberEmailsButton', (ModalService, ChoosePlanModal) ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/member_emails_button/member_emails_button.html'
  controller: ($scope) ->
    $scope.showMemberEmails = ->
      ModalService.open ChoosePlanModal, group: -> $scope.group
