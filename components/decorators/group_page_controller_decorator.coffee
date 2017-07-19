angular.module('loomioApp').config ($provide) ->
  $provide.decorator '$controller', ($delegate, $location, AppConfig, Session, AbilityService, ChoosePlanModal, SubscriptionSuccessModal) ->
    ->
      ctrl = $delegate arguments...
      if _.get(arguments, '[1].$router.name') == 'groupPage'

        ctrl.addLauncher(=>
          ctrl.group.subscriptionLevel = 'gold'
          ctrl.group.subscriptionKind = 'paid'
          $location.search 'chargify_success', null
          ctrl.openModal SubscriptionSuccessModal
          true
        , ->
          AbilityService.isLoggedIn() and
          $location.search().chargify_success?
        , priority: 1)

      ctrl
