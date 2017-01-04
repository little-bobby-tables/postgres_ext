# frozen_string_literal: true
require 'postgres_ext/active_record/cte_proxy'

module ActiveRecord
  module Querying
    delegate :with, :ranked, to: :all

    def from_cte(name, expression)
      table = Arel::Table.new(name)

      cte_proxy = CTEProxy.new(name, self)
      relation = ActiveRecord::Relation.new cte_proxy, cte_proxy.arel_table, expression.predicate_builder
      relation.with name => expression
    end
  end
end
