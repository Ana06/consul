module Abilities
  class Administrator
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Moderation.new(user)
      self.merge Abilities::Valuator.new(user)

      can :restore, Comment
      cannot :restore, Comment, hidden_at: nil

      can :restore, Debate
      cannot :restore, Debate, hidden_at: nil

      can :restore, Proposal
      cannot :restore, Proposal, hidden_at: nil

      can :restore, User
      cannot :restore, User, hidden_at: nil

      can :confirm_hide, Comment
      cannot :confirm_hide, Comment, hidden_at: nil

      can :confirm_hide, Debate
      cannot :confirm_hide, Debate, hidden_at: nil

      can :confirm_hide, Proposal
      cannot :confirm_hide, Proposal, hidden_at: nil

      can :confirm_hide, User
      cannot :confirm_hide, User, hidden_at: nil

      can :mark_featured, Debate
      can :unmark_featured, Debate

      can :comment_as_administrator, [Debate, Comment, Proposal]

      can [:search, :create, :index, :destroy], ::Moderator
      can [:search, :create, :index, :summary], ::Valuator
      can [:search, :create, :index, :destroy], ::Manager

      can :manage, Annotation

      can [:read, :update, :destroy, :summary], SpendingProposal
    end
  end
end
