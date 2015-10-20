require 'spec_helper'

describe Zosimos do
  it 'has a version number' do
    expect(Zosimos::VERSION).not_to be nil
  end

  it 'runs a dataset through sentiment analysis' do
    input = File.read('spec/data/input.csv')

    CSV.parse(input, headers: true) do |row|
      expect(AlchemyAPI).to receive(:search)
        .with(:sentiment_analysis, text: row['text'], language: 'english')
        .and_return({"score" => "-0.5", "type" => "negative"})
    end

    output = Zosimos.process(CSV.parse(input), method: :sentiment_analysis)

    expect(output.count).to eq(4)
    expect(output[1].join(',')).to eq('1,1,I really hate this. All of it sucks.,negative,-0.5')
  end
end
