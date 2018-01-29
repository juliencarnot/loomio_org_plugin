{ contactUs } = require 'shared/helpers/user.coffee'

angular.module('loomioApp').factory 'ChoosePlanModal', ->
  templateUrl: 'generated/components/choose_plan_modal/choose_plan_modal.html'
  size: 'choose-plan-modal'
  controller: ['$scope', '$window', 'group', 'ChargifyService', ($scope, $window, group, ChargifyService) ->
    $scope.group = group

    $scope.choosePaidPlan = (kind) ->
      $window.open ChargifyService.chargifyUrlFor($scope.group, kind)
      true

    $scope.openIntercom = ->
      contactUs()
      true
  ]
