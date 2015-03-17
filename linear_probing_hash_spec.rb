require "./linear_probing_hash"
require "pry"

RSpec.describe LinearProbingHash do
  it "sets and retrieves some simple keys and values" do
    expect(subject["foo"]).to be_nil

    subject["foo"] = 3
    expect(subject["foo"]).to eq(3)

    subject[:bar] = {bop: {}}
    expect(subject[:bar]).to eq({bop: {}})
    expect(subject["foo"]).to eq(3)

    subject[3] = "three"
    expect(subject[:bar]).to eq({bop: {}})
    expect(subject["foo"]).to eq(3)
    expect(subject[3]).to eq("three")
  end

  it "overwrites a previous value" do
    expect(subject["foo"]).to be_nil

    subject["foo"] = 3
    expect(subject["foo"]).to eq(3)

    subject["foo"] = :stewie
    expect(subject["foo"]).to eq(:stewie)
  end

  it "handles collisions" do
    expect(subject).to receive(:hash).with(3).and_return(5).at_least(:once)
    expect(subject).to receive(:hash).with(13).and_return(5).at_least(:once)

    subject[3] = "three"
    expect(subject[3]).to eq("three")

    subject[13] = "thirteen"
    expect(subject[3]).to eq("three")
    expect(subject[13]).to eq("thirteen")
  end

  it "resizes automatically when it runs out of space" do
    expect(subject.instance_variable_get("@size")).to eq(10)

    11.times do |i|
      subject[i] = i.to_s
    end

    11.times do |i|
      expect(subject[i]).to eq(i.to_s)
    end

    expect(subject.instance_variable_get("@size")).to eq(20)
  end
end
