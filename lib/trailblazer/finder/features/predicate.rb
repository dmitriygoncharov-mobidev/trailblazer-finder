module Trailblazer
  class Finder
    module Features
      module Predicate
        def self.included(base)
          base.extend ClassMethods
          base.instance_eval do
            include Predicates
          end
        end

        module ClassMethods
          def do_filters(attribute, predicate)
            filter_by "#{attribute}_#{predicate}" do |entity_type, value|
              splitter = Utils::Splitter.new "#{attribute}_#{predicate}", value
              splitter.split_key predicate.to_sym
              send splitter.op, splitter.field, splitter.value, entity_type
            end
          end

          def predicates_for(*attributes)
            attributes.each do |attribute|
              do_filters(attribute, "eq")
              do_filters(attribute, "not_eq")
              do_filters(attribute, "blank")
              do_filters(attribute, "not_blank")
              do_filters(attribute, "gt")
              do_filters(attribute, "gte")
              do_filters(attribute, "lt")
              do_filters(attribute, "lte")
            end
          end
        end
      end
    end
  end
end