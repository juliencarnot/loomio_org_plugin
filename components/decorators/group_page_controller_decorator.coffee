AppConfig      = require 'shared/services/app_config.coffee'
Session        = require 'shared/services/session.coffee'
AbilityService = require 'shared/services/ability_service.coffee'
ModalService   = require 'shared/services/modal_service.coffee'
LmoUrlService  = require 'shared/services/lmo_url_service.coffee'

_ = require 'lodash'

angular.module('loomioApp').config ['$provide', ($provide) ->
  $provide.decorator '$controller', ['$delegate', ($delegate) ->
    ->
      ctrl = $delegate arguments...
      if _.get(arguments, '[1].$router.name') == 'groupPage'

        ctrl.addLauncher(=>
          ctrl.group.subscriptionLevel = 'gold'
          ctrl.group.subscriptionKind = 'paid'
          LmoUrlService.params 'chargify_success', null
          ModalService.open 'SubscriptionSuccessModal'
          true
        , ->
          AbilityService.isLoggedIn() and
          LmoUrlService.params().chargify_success?
        , priority: 1)

      ctrl
  ]
]
