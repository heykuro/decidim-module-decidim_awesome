# frozen_string_literal: true

module Decidim
  module DecidimAwesome
    module Admin
      class CreateProposalCustomField < Rectify::Command
        # Public: Initializes the command.
        #
        def initialize(organization)
          @organization = organization
          @ident = rand(36**8).to_s(36)
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if we couldn't proceed.
        #
        # Returns nothing.
        def call
          fields = AwesomeConfig.find_or_initialize_by(var: :proposal_custom_fields, organization: @organization)
          fields.value = {} unless fields.value.is_a? Hash
          # TODO: prevent (unlikely) colisions with exisiting values
          fields.value[@ident] = default_definition
          fields.save!

          broadcast(:ok, @ident)
        rescue StandardError => e
          broadcast(:invalid, e.message)
        end

        private

        def default_definition
          "body:
  type: 'textarea'
  title: 'activemodel.attributes.proposal.body'
  required: true"
        end
      end
    end
  end
end
