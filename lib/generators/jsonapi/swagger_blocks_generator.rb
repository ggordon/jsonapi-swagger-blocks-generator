# frozen_string_literal: true

module Jsonapi
  module Generators
    class SwaggerBlocksGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      argument :model, type: :string, banner: "resource", desc: "Resource file generated by JSONAPI::Resources gem"
      argument :namespace, type: :string, default: "", desc: "namespace where the Resource files are located"

      def generate_documentation
        model_name = model.to_s.split("::").last || model
        Object.const_get("#{namespace}::#{model_name.camelcase}Resource").is_a?(Class)
        generate_model_template
        generate_controller_template
      rescue Exception => e
        p e.message
      end

      private

        def generate_model_template
          template "model_template.template", "app/docs/#{model.underscore}.rb"
        end

        def generate_controller_template
          template "controller_template.template", "app/docs/#{model.underscore.pluralize}_controller.rb"
        end
    end
  end
end
