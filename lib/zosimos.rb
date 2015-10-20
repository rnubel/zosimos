require 'zosimos/version'
require 'csv'
require 'alchemy_api'

module Zosimos
  extend self

  def process(input, method: :sentiment_analysis)
    output = []
    headers = input.first

    output << headers.dup + [ 'sentiment', 'score' ]

    input.drop(1).each do |row|
      output_row = row.dup
      result = alchemy_call(method, text: row.last, language: default_language)

      output_row << result['type']
      output_row << result['score']

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
