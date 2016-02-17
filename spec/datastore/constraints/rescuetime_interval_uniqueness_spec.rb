require 'spec_helper'

describe 'Enforcing uniqueness on rescuetime intervals' do
  let(:now) { Time.now }

  def add_record(overrides = {})
    DB[:rescuetime_interval] << {
      date: now,
      time_spent_in_seconds: 5,
      number_of_people: 9,
      activity: 'Programming',
      category: 'Work',
      productivity: 1
    }.merge(overrides)
  end

  it 'enforces uniqueness on all fields' do
    add_record

    expect do
      add_record
    end.to raise_error(Sequel::UniqueConstraintViolation)
  end

  it 'will not raise if one field is different' do
    add_record

    expect do
      add_record(productivity: 0)
    end.not_to raise_error
  end
end

