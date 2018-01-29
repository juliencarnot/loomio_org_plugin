page = require '../../../../../client/angular/test/protractor/helpers/page_helper.coffee'

describe 'Memberships page', ->
  it 'displays emails to coordinators of paid groups', ->
    page.loadPath 'setup_group_on_paid_plan'
    page.click '.members-card__manage-members'
    page.expectText '.memberships-panel', 'jennifer_grey@example.com'

  it 'does not display emails to coordinators of non-paid groups', ->
    page.loadPath 'setup_group_on_free_plan'
    page.click '.members-card__manage-members'
    page.expectNoText '.memberships-panel', 'jennifer_grey@example.com'
    page.click '.member-emails-button__submit'
    page.expectText '.md-dialog-container', 'Please upgrade'
