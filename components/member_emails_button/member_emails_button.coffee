ModalService = require 'shared/services/modal_service.coffee'

angular.module('loomioApp').directive 'memberEmailsButton', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/member_emails_button/member_emails_button.html'
  controller: ['$scope', ($scope) ->
    $scope.showMemberEmails = ->
      ModalService.open 'ChoosePlanModal', group: -> $scope.group
  ]
