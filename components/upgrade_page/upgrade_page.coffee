angular.module('loomioApp').controller 'UpgradePageController', (AbilityService, $rootScope) ->

  $rootScope.$broadcast('currentComponent', { page: 'upgradePage' })

  window.location = '/pricing' if AbilityService.isLoggedIn()

  return
