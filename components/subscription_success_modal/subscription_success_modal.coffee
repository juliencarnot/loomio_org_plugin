{ contactUs } = require 'shared/helpers/user.coffee'

angular.module('loomioApp').factory 'SubscriptionSuccessModal', ->
  templateUrl: 'generated/components/subscription_success_modal/subscription_success_modal.html'
  size: 'subscription-success-modal'
  controller: ['$scope', ($scope) ->
    $scope.openIntercom = ->
      contactUs()

    $scope.dismiss = ->
      $scope.$close()
  ]
