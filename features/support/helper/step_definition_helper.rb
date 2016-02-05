module Helpers
  def get_table_data table, column_name
    data = table.transpose.raw.inject({}) do |hash, column|
      column.reject!(&:empty?)
      hash[column.shift] = column
      hash
    end

    confirmation_text = data[column_name]
    return confirmation_text
  end
end