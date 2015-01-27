module Wordset
  module V1
    class Proposals < Grape::API
      include Wordset::V1::Defaults

      resource :proposals do
        params do
          optional :limit, default: 100
          optional :offset, default: 0
        end
        get '/', each_serializer: ProposalSerializer do
          Proposal.limit(params[:limit]).sort({created_at: -1}).to_a
        end


        get '/:id', each_serializer: ProposalSerializer do
          Proposal.find(params[:id])
        end

        params do
          requires :proposal, type: Hash do
            requires :delta, type: Hash
            requires :action, type: String
            requires :target_id
            requires :target_type
          end
        end
        post '/' do
          authorize!
          d = params[:proposal]
          s = Proposal.new
          s.delta = d[:delta]
          s.action = d[:action]
          s.user = current_user
          s.target_id = d[:target_id]
          s.target_type = d[:target_type].camelcase
          if !s.target.class.editable?
            throw "BAD TARGET"
          end
          if s.target.is_a? Word
            s.word = s.target
          elsif s.target.is_a? Meaning
            s.word = s.target.entry.word
          end
          s.save!
          s
        end
      end
    end
  end
end
