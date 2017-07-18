class Subscription < ActiveRecord::Base
  has_one :group
  validates :kind, presence: true
  validates :group, presence: true

  GOLD_NAMES =      %w(standard-loomio-plan standard-plan-yearly)
  PRO_NAMES =       %w(pro-loomio-plan pro-plan-yearly)
  PLUS_NAMES =      %w(plus-plan plus-plan-yearly)
  PLAN_NAMES =      GOLD_NAMES + PRO_NAMES + PLUS_NAMES
  PAYMENT_METHODS = ['chargify', 'manual', 'paypal', 'barter']
  KINDS =           ['gift', 'paid']

  # gift means free
  validates_inclusion_of :kind, in: KINDS
  validates_inclusion_of :payment_method, in: PAYMENT_METHODS, allow_nil: true

  # plan is a text field to detail the subscription type further
  # plan could be manual
  #
  # current it indicates standard or plus plan

  delegate :id, to: :group, prefix: true, allow_nil: true

  def group_id=(id)
    self.group = Group.find(id)
  end

  def is_paid?
    self.kind.to_s == 'paid'
  end

  def level
    if kind == 'paid'
      if PRO_NAMES.include?(plan)
        'pro'
      elsif PLUS_NAMES.include?(plan)
        'plus'
      else
        'gold'
      end
    else
      'free'
    end
  end
end
