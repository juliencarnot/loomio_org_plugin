Session      = require 'shared/services/session.coffee'
ModalService = require 'shared/services/modal_service.coffee'

_ = require 'lodash'

paidPlanModals =
  InstallSlackModal:    -> true
  TagModal:             -> true
  GroupModal: (resolve) -> resolve.group().isSubgroup()

isOnFreeGroup = (group) ->
  group and group.parentOrSelf().subscriptionLevel == 'free'

requirePaidPlan = (modal, resolve) ->
  return false unless checkResolve = paidPlanModals[modal]
  checkResolve(resolve)

ModalService.setOpenMethod = (fn) ->
  @open = (modal, resolve) ->
    if isOnFreeGroup(Session.currentGroup) and requirePaidPlan(modal, resolve)
      modal   = 'ChoosePlanModal'
      resolve = group: -> Session.currentGroup.parentOrSelf()
    fn(modal, resolve)
