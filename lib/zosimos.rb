require 'zosimos/version'
require 'csv'
require 'alchemy_api'

module Zosimos
  extend self

  def process(input, method: :sentiment_analysis, text_column: nil)
    output = []
    headers = input.first

    column_to_process = headers.index(text_column) || (headers.size - 1)

    output << headers.dup + [ 'sentiment', 'score' ]

    input.drop(1).each do |row|
      output_row = row.dup
      text = row[column_to_process]
      result = alchemy_call(method, text: text, language: default_language)

      if result
        output_row << result['type']
        output_row << result['score']
      end

      output << output_row
    end

    output
  end

  private

  def alchemy_call(*args)
    AlchemyAPI.search(*args)
  end

  def default_language
    'english'
  end
end
