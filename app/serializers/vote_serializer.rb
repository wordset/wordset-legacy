class VoteSerializer < BaseSerializer
  attributes :id, :proposal_id, :yae, :value
  has_one :user, embed_key: :to_param


  def user_id
    object.user.username
  end

end
