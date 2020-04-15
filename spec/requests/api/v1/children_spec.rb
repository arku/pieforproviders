# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'children API', type: :request do
  let!(:user_params) do
    {
      "email": 'fake_email@fake_email.com',
      "full_name": 'Oliver Twist',
      "greeting_name": 'Oliver',
      "language": 'English',
      "mobile": '912-444-5555',
      "phone": '912-444-5555',
      "service_agreement_accepted": 'true',
      "timezone": 'Central Time (US & Canada)'
    }
  end
  let!(:child_params) do
    {
      "ccms_id": '1234567890',
      "first_name": 'Parvati',
      "full_name": 'Parvati Patil',
      "last_name": 'Patil',
      "date_of_birth": '1981-04-09'
    }
  end

  path '/api/v1/users/{user_id}/children' do
    parameter name: :user_id, in: :path, type: :string
    let(:user_id) { User.create(user_params).id }
    get 'lists all children for a user' do
      tags 'children'
      produces 'application/json'
      parameter name: 'Accept', in: :header, type: :string, default: 'application/vnd.pieforproviders.v1+json'
      # parameter name: 'Authorization', in: :header, type: :string, default: 'Bearer <token>'
      # security [{ token: [] }]

      context 'on the right api version' do
        include_context 'correct api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '200', 'children found' do
          run_test! do
            expect(response).to match_response_schema('children')
          end
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '401', 'not authorized' do
        #     run_test!
        #   end
        # end
      end

      context 'on the wrong api version' do
        include_context 'incorrect api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '500', 'internal server error' do
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '500', 'internal server error' do
        #     run_test!
        #   end
        # end
      end
    end

    post 'creates a child' do
      tags 'children'
      consumes 'application/json', 'application/xml'
      parameter name: 'Accept', in: :header, type: :string, default: 'application/vnd.pieforproviders.v1+json'
      parameter name: :child, in: :body, schema: {
        '$ref' => '#/definitions/createChild'
      }

      context 'on the right api version' do
        include_context 'correct api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '201', 'child created' do
          let(:child) { { "child": child_params } }
          run_test! do
            expect(response).to match_response_schema('user_with_children')
          end
        end
        response '422', 'invalid request' do
          let(:child) { { "child": { "title": 'whatever' } } }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '201', 'child created' do
        #     let(:child) { { "child": child_params } }
        #     run_test! do
        #       expect(response).to match_response_schema('child')
        #     end
        #   end
        #   response '422', 'invalid request' do
        #     let(:child) { { "child": { "title": 'foo' } } }
        #     run_test!
        #   end
        # end
      end

      context 'on the wrong api version' do
        include_context 'incorrect api version header'
        # context 'when authenticated' do
        # include_context 'authenticated user'
        response '500', 'internal server error' do
          let(:child) { { "child": child_params } }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '500', 'internal server error' do
        #     let(:child) { { "child": child_params } }
        #     run_test!
        #   end
        # end
      end
    end
  end

  path '/api/v1/users/{user_id}/children/{child_id}' do
    parameter name: :user_id, in: :path, type: :string
    parameter name: :child_id, in: :path, type: :string
    let(:user_id) { User.create(user_params).id }
    let(:child_id) { User.find(user_id).children.create!(child_params).id }
    get 'retrieves a child' do
      tags 'children'
      produces 'application/json', 'application/xml'
      parameter name: 'Accept', in: :header, type: :string, default: 'application/vnd.pieforproviders.v1+json'
      # parameter name: 'Authorization', in: :header, type: :string, default: 'Bearer <token>'
      # security [{ token: [] }]

      context 'on the right api version' do
        include_context 'correct api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '200', 'child found' do
          run_test! do
            expect(response).to match_response_schema('child')
          end
        end

        response '404', 'child not found' do
          let(:child_id) { 'invalid' }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '401', 'not authorized' do
        #     run_test!
        #   end
        # end
      end

      context 'on the wrong api version' do
        include_context 'incorrect api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '500', 'internal server error' do
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '500', 'internal server error' do
        #     run_test!
        #   end
        # end
      end
    end
    put 'updates a child' do
      tags 'children'
      consumes 'application/json', 'application/xml'
      produces 'application/json', 'application/xml'
      parameter name: 'Accept', in: :header, type: :string, default: 'application/vnd.pieforproviders.v1+json'
      # parameter name: 'Authorization', in: :header, type: :string, default: 'Bearer <token>'
      parameter name: :child, in: :body, schema: {
        '$ref' => '#/definitions/updateChild'
      }
      # security [{ token: [] }]

      context 'on the right api version' do
        include_context 'correct api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '200', 'child updated' do
          let(:child) { { "child": child_params.merge("first_name": 'Padma') } }
          run_test! do
            expect(response).to match_response_schema('user_with_children')
            # expect(response.parsed_body['name']).to eq('Hogwarts School')
          end
        end

        response '422', 'child cannot be updated' do
          let(:child) { { "child": { "first_name": nil } } }
          run_test!
        end

        response '404', 'child not found' do
          let(:child_id) { 'invalid' }
          let(:child) { { "child": child_params } }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '401', 'not authorized' do
        #     run_test!
        #   end
        # end
      end

      context 'on the wrong api version' do
        include_context 'incorrect api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '500', 'internal server error' do
          let(:child) { { "child": child_params } }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '500', 'internal server error' do
        #     run_test!
        #   end
        # end
      end
    end
    delete 'deletes a child' do
      tags 'children'
      produces 'application/json', 'application/xml'
      parameter name: 'Accept', in: :header, type: :string, default: 'application/vnd.pieforproviders.v1+json'
      # parameter name: 'Authorization', in: :header, type: :string, default: 'Bearer <token>'
      # security [{ token: [] }]

      context 'on the right api version' do
        include_context 'correct api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '204', 'child deleted' do
          run_test!
        end

        response '404', 'child not found' do
          let(:child_id) { 'invalid' }
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '401', 'not authorized' do
        #     run_test!
        #   end
        # end
      end

      context 'on the wrong api version' do
        include_context 'incorrect api version header'
        # context 'when authenticated' do
        #   include_context 'authenticated user'
        response '500', 'internal server error' do
          run_test!
        end
        # end

        # context 'when not authenticated' do
        #   include_context 'unauthenticated user'
        #   response '500', 'internal server error' do
        #     run_test!
        #   end
        # end
      end
    end
  end
end
