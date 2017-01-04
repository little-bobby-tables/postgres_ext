module PostgresExt::ArrayHandlerExtension
  def call(attribute, value)
    table = attribute.try(:relation)
    table = table.left if table.is_a? Arel::Nodes::TableAlias
    return super if table.nil?

    cache = ActiveRecord::Base.connection.schema_cache
    column = if cache.data_source_exists?(table.name)
      cache.columns(table.name).detect { |col| col.name.to_s == attribute.name.to_s }
    end

    if column && column.respond_to?(:array) && column.array
      attribute.eq(value)
    else
      super
    end
  end
end

ActiveRecord::PredicateBuilder::ArrayHandler.prepend PostgresExt::ArrayHandlerExtension
