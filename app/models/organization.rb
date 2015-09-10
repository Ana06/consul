class Organization < ActiveRecord::Base
  belongs_to :user, touch: true

  validates :name, presence: true
  validates :name, uniqueness: true
  validate :validate_name_length

  delegate :email, :phone_number, to: :user

  scope :pending, -> { where('organizations.verified_at is null and rejected_at is null') }
  scope :verified, -> { where("organizations.verified_at is not null and (rejected_at is null or rejected_at < organizations.verified_at)") }
  scope :rejected, -> { where("rejected_at is not null and (organizations.verified_at is null or organizations.verified_at < rejected_at)") }

  def verify
    update(verified_at: Time.now)
  end

  def reject
    update(rejected_at: Time.now)
  end

  def verified?
    verified_at.present? &&
      (rejected_at.blank? || rejected_at < verified_at)
  end

  def rejected?
    rejected_at.present? &&
      (verified_at.blank? || verified_at < rejected_at)
  end

  def self.search(text)
    text.present? ? joins(:user).where("users.email = ? OR users.phone_number = ? OR organizations.name ILIKE ?", text, text, "%#{text}%") : none
  end

  def self.name_max_length
    @@name_max_length ||= self.columns.find { |c| c.name == 'name' }.limit
  end

  private

    def validate_name_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :name,
        maximum: Organization.name_max_length)
      validator.validate(self)
    end

end
