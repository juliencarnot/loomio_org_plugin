page = require '../../../../angular/test/protractor/helpers/page_helper.coffee'

describe 'Memberships page', ->
  it 'displays emails to coordinators of paid groups', ->
    page.loadPath('setup_group_on_paid_plan')
    page.click '.members-card__manage-members'
    page.expectText '.memberships-panel', 'jennifergrey@example.com'

  it 'does not display emails to coordinators of non-paid groups', ->
    page.loadPath('setup_group_on_free_plan')
    page.click '.members-card__manage-members'
    page.expectNoText 'jennifergrey@example.com'
    page.click '.show-member-emails__submit'
    page.expectText '.md-dialog-container', 'Please upgrade'
