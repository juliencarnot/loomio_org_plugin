module Plugins
  module LoomioOrg
    class Plugin < Plugins::Base
      setup! :loomio_org_plugin do |plugin|
        plugin.enabled = true

        LOOMIO_ORG_PAGES = %w(about
                              browser_not_supported
                              crowdfunding_celebration
                              index
                              pricing
                              wallets)
        LOOMIO_ORG_PAGES.each { |page| plugin.use_page page, "pages##{page}" }
        plugin.use_class 'controllers/pages_controller'

        plugin.use_page :help,             'http://help.loomio.org',                                                 redirect: true
        plugin.use_page :blog,             'http://blog.loomio.org',                                                 redirect: true
        plugin.use_page :press,            'http://blog.loomio.org/press-pack',                                      redirect: true
        plugin.use_page :"press-pack",     'http://blog.loomio.org/press-pack',                                      redirect: true
        plugin.use_page :roadmap,          'https://trello.com/b/tM6QGCLH/loomio-roadmap',                           redirect: true
        plugin.use_page :community,        'https://www.loomio.org/g/WmPCB3IR/loomio-community',                     redirect: true
        plugin.use_page :timeline,         'http://www.tiki-toki.com/timeline/entry/313361/Loomio',                  redirect: true
        plugin.use_page :privacy,          'https://loomio.gitbooks.io/manual/content/en/privacy_policy.html',       redirect: true
        plugin.use_page :terms_of_service, 'https://loomio.gitbooks.io/manual/content/en/terms_of_service.html',     redirect: true
        plugin.use_page :third_parties,    'https://loomio.gitbooks.io/manual/content/en/third_party_services.html', redirect: true
        plugin.use_page :newsletter,       'http://eepurl.com/b51x_b',                                               redirect: true
        plugin.use_page :translation,      'https://www.transifex.com/rdbartlett/loomio-1/',                         redirect: true

        plugin.extend_class ApplicationController do
          def hosted_by_loomio?
            true
          end
        end

        plugin.use_page('/', 'pages#index')

        plugin.use_client_route '/upgrade', :upgrade_page

        plugin.use_static_asset :assets, 'lance/index.scss', standalone: true
        plugin.use_static_asset :assets, 'lance/ahoy.coffee', standalone: true
        plugin.use_static_asset_directory :"assets/lance/images", standalone: true

        # bx stuff
        plugin.use_asset 'components/services/chargify_service.coffee'
        plugin.use_asset_directory 'components/decorators'

        plugin.use_component :current_plan_button, outlet: :group_theme_member_actions
        plugin.use_component :choose_plan_modal
        plugin.use_component :subscription_success_modal
        plugin.use_component :manage_group_subscription_link, outlet: :after_group_actions_manage_memberships
        plugin.use_component :export_group_data_link, outlet: :after_group_actions_manage_memberships_2
        plugin.use_component :member_emails_button, outlet: :after_memberships_panel
        plugin.use_component :member_email, outlet: :after_membership_user
        plugin.use_component :premium_feature, outlet: [:subgroup_card_footer, :tag_card_footer, :install_slack_card_footer, :after_memberships_panel]

        plugin.use_translations 'config/locales', :marketing

        plugin.use_class_directory 'app/models'
        plugin.use_class_directory 'app/admin'
        plugin.use_class_directory 'app/controllers'
        plugin.use_class_directory 'app/helpers'
        plugin.use_class_directory 'app/services'

        plugin.use_route :post, 'groups/:id/use_gift_subscription', 'groups#use_gift_subscription'
        plugin.extend_class API::GroupsController do
          load_resource only: [:use_gift_subscription], find_by: :key
          def use_gift_subscription
            if SubscriptionService.available?
              SubscriptionService.new(resource, current_user).start_gift!
              respond_with_resource
            else
              respond_with_standard_error ActionController::BadRequest, 400
            end
          end
        end

        plugin.extend_class API::MembershipsController do
          private

          def default_scope
            if action_name.to_sym == :index && @group.subscription.is_paid?
              super.merge emails: collection.map(&:user).map { |m| [m.id, m.email] }.to_h
            else
              super
            end
          end
        end

        plugin.extend_class GroupsController do
          before_action :ensure_paid_group, only: :export

          private

          def ensure_paid_group
            return if current_user.is_admin? ||
                      load_and_authorize(:group, :export).parent_or_self.subscription.is_paid?
            raise CanCan::AccessDenied.new
          end

        end

        plugin.extend_class FormalGroup do
          belongs_to :subscription, dependent: :destroy
          validates :subscription, absence: true, if: :is_subgroup?
        end

        plugin.extend_class UserSerializer do
          attribute :email

          def email
            scope.dig(:emails, object.id)
          end

          def include_email?
            email.present?
          end
        end

        plugin.extend_class GroupSerializer do
          attributes_for_formal :subscription_kind,
                                :subscription_plan,
                                :subscription_payment_method,
                                :subscription_expires_at,
                                :subscription_level

          def subscription_kind
            subscription.kind
          end

          def subscription_plan
            subscription.plan
          end

          def subscription_payment_method
            subscription.payment_method
          end

          def subscription_expires_at
            subscription.expires_at
          end

          def subscription
            @subscription ||= object.subscription || object.build_subscription
          end

          def subscription_level
            subscription.level
          end
        end

        plugin.use_events do |event_bus|
          event_bus.listen('group_create')  do |group, actor|
            SubscriptionService.new(group, actor).start_gift! if group.is_parent?
          end

          event_bus.listen('group_archive') do |group, actor|
            SubscriptionService.new(group, actor).end_subscription! if group.is_parent?
          end
        end

        plugin.use_factory :subscription do
          kind :gift
          expires_at 1.month.from_now
        end

        plugin.use_database_table :subscriptions do |t|
          t.string  :kind
          t.date    :expires_at
          t.date    :trial_ended_at
          t.date    :activated_at
          t.integer :chargify_subscription_id
          t.string  :plan
          t.string  :payment_method, default: :chargify, null: false
        end

        plugin.use_test_route :setup_group_on_free_plan do
          group = FormalGroup.new(name: 'Ghostbusters', is_visible_to_public: true)
          GroupService.create(group: group, actor: patrick)
          group.add_member! jennifer
          sign_in patrick
          redirect_to group_url(group)
        end

        plugin.use_test_route :setup_old_group_on_free_plan do
          create_group.experiences['bx_choose_plan'] = false
          create_group.save
          GroupService.create(group: create_group, actor: patrick)
          sign_in patrick
          Membership.find_by(user: patrick, group: create_group).update(created_at: 1.week.ago)
          redirect_to group_url(create_group)
        end

        plugin.use_test_route :setup_group_on_paid_plan  do
          GroupService.create(group: create_group, actor: patrick)
          subscription = create_group.subscription
          subscription.update_attribute :kind, 'paid'
          sign_in patrick
          redirect_to group_url(create_group)
        end

        plugin.use_test_route :setup_group_on_paid_plan_as_non_coordinator do
          GroupService.create(group: create_group, actor: patrick)
          subscription = create_group.subscription
          subscription.update_attribute :kind, 'paid'
          sign_in jennifer
          redirect_to group_url(create_group)
        end

        plugin.use_test_route :setup_group_after_chargify_success do
          create_group.save
          sign_in patrick
          redirect_to group_url create_group, chargify_success: true
        end
      end
    end
  end
end
