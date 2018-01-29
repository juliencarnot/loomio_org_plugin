page = require '../../../../../client/angular/test/protractor/helpers/page_helper.coffee'

describe 'Subscription flow', ->
  describe 'setup group on free plan', ->
    it 'allows members to modify their plan', ->
      page.loadPath('setup_group_on_free_plan')
      page.click '.current-plan-button'
      page.expectText '.pricing-table__modal', 'Please upgrade for premium features'

  describe 'group after subscription success', ->
    it 'shows the subscription success modal', ->
      page.loadPath('setup_group_after_chargify_success')
      page.expectElement '.subscription-success-modal', 'You\'re all set!'
