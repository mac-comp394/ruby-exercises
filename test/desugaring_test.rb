require_relative "test_helper"

describe DesugaringExercises do
  let :sample_emails do
    [
      "sally@foo.com",
      "fred@bar.com",
    ]
  end

  let :sample_users do
    sample_emails.map do |email|
      UserStub.new(email: email)
    end
  end

  let :sample_event do
    EventStub.new(title: "a Syntactic Sugar Party", date: "March 12")
  end

  let :sample_message do
    "Syntactic sugar: mind-exapanding or addictive? Let’s find out!"
  end

  DesugaringExercises.instance_methods.each do |variant|
    it "works the same with #{variant.to_s.gsub('_', ' ')}" do
      exercise = MockMailer.new(variant) do
        warn "  #{warning_emoji}  TODO #{warning_emoji}  implement #{variant}"
        skip
      end
      exercise.run(sample_users, sample_event, sample_message)

      assert_equal(
        1,
        exercise.mail_calls.size,
        "Each desugaring exercise should only call mail method once")

      assert_equal(
        [
          sample_message,
          {
            to: sample_emails,
            subject: "You’re invited to a Syntactic Sugar Party on March 12"
          }
        ],
        exercise.mail_calls.first,
        "Wrong arguments passed to mail method on variant #{variant}")
    end
  end

  let :warning_emoji do
    "\u26A0\uFE0F"
  end
end

# Runs a specific desugaring exercises, provides mail and implement_me methods for it to call,
# and records the arguments passed to mail.
#
class MockMailer
  include DesugaringExercises

  def initialize(variant_to_test, &todo_callback)
    @variant_to_test = variant_to_test
    @todo_callback = todo_callback
    @mail_calls = []
  end

  attr_reader :mail_calls

  def run(*args)
    send(@variant_to_test, *args)
  end

  def mail(*args)
    @mail_calls << args
  end

  def implement_me!
    @todo_callback.call
  end
end

# Fake user and event objects for the desugaring examples to use.
#
class Stub
  def initialize(ivars)
    ivars.each do |var, value|
      instance_variable_set("@#{var}", value)
    end
  end
end

class UserStub < Stub
  attr_reader :email
end

class EventStub < Stub
  attr_reader :title, :date
end
