angular.module('loomioApp').config ($provide) ->
  $provide.decorator 'ModalService', ($delegate, Session, ChoosePlanModal) ->
    paidPlanModals = [
      'InstallSlackModal',
      'TagModal',
      'GroupModal'
    ]

    open = $delegate.open
    $delegate.open = (modal, resolve = {}) ->
      if requirePaidPlan(modal, resolve) and
         Session.currentGroup and
         Session.currentGroup.parentOrSelf().subscriptionLevel == 'free'
        open ChoosePlanModal, group: -> Session.currentGroup.parentOrSelf()
      else
        open modal, resolve

    requirePaidPlan = (modal, resolve) ->
      _.any paidPlanModals, (modalName) ->
        matchesTemplate = modal.templateUrl.match(_.snakeCase(modalName))
        if modalName == 'GroupModal'
          matchesTemplate and resolve.group().isSubgroup()
        else
          matchesTemplate

    $delegate
