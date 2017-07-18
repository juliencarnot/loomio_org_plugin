angular.module('loomioApp').directive 'currentPlanButton', (ChoosePlanModal, SubscriptionSuccessModal, ModalService)->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/current_plan_button/current_plan_button.html'
  controller: ($scope) ->
    $scope.click = ->
      if $scope.group.subscriptionLevel == 'free'
        ModalService.open ChoosePlanModal, group: -> $scope.group
      else
        ModalService.open SubscriptionSuccessModal, group: -> $scope.group

    $scope.buttonText = ->
      if $scope.group.subscriptionLevel == 'free'
        'upgrade'
      else
        $scope.group.subscriptionLevel
