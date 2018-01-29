AbilityService = require 'shared/services/ability_service.coffee'
ModalService   = require 'shared/services/modal_service.coffee'

angular.module('loomioApp').directive 'manageGroupSubscriptionLink', ->
  scope: {group: '='}
  templateUrl: 'generated/components/manage_group_subscription_link/manage_group_subscription_link.html'
  controller: ['$scope', '$window', 'ChargifyService', ($scope, $window, ChargifyService) ->

    $scope.canManageGroupSubscription = ->
      AbilityService.canManageGroupSubscription($scope.group)

    $scope.manageSubscriptions = ->
      $window.open "https://www.billingportal.com/s/#{ChargifyService.chargify().appName}/login/magic", '_blank'
      true

    $scope.choosePlan = ->
      ModalService.open 'ChoosePlanModal', group: -> $scope.group
  ]
