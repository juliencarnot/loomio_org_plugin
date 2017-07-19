angular.module('loomioApp').directive 'currentPlanButton', (ChoosePlanModal, SubscriptionSuccessModal, ModalService)->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/current_plan_button/current_plan_button.html'
  controller: ($scope) ->
    
    $scope.parentGroup = ->
      $scope.group.parentOrSelf()

    $scope.click = ->
      if $scope.parentGroup().subscriptionLevel == 'free'
        ModalService.open ChoosePlanModal, group: -> $scope.parentGroup()
      else
        ModalService.open SubscriptionSuccessModal, group: -> $scope.parentGroup()

    $scope.buttonText = ->
      if $scope.parentGroup().subscriptionLevel == 'free'
        'upgrade'
      else
        $scope.parentGroup().subscriptionLevel
