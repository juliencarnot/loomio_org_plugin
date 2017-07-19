angular.module('loomioApp').config ($provide) ->
  $provide.decorator 'tagCardDirective', ($delegate, ModalService, ChoosePlanModal) ->
    controller = $delegate[0].controller
    $delegate[0].controller = ($scope) ->
      controller($scope)
      openTagForm = $scope.openTagForm
      $scope.openTagForm = ->
        if $scope.group.parentOrSelf().subscriptionLevel != 'free'
          openTagForm()
        else
          ModalService.open ChoosePlanModal, group: -> $scope.group.parentOrSelf()

    $delegate
