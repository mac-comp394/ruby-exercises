require "aasm"

class Door
  include AASM

  aasm do
    state :closed, initial: true
    state :open

    event :open do
      transitions to: :open, if: [:deadbolt_unlocked?, :knob_unlocked?]
    end

    event :close do
      transitions to: :closed, if: :deadbolt_unlocked?
    end
  end

  # I tried adding a method to do this to Class without success
  # But this works too
  ["deadbolt", "knob"].each do |name|
    aasm "#{name}_lock".to_sym, namespace: name.to_sym do
      state :unlocked, initial: true
      state :locked

      event "lock_#{name}".to_sym do
        transitions to: :locked
      end

      event "unlock_#{name}".to_sym do
        transitions to: :unlocked
      end
    end
  end

  # aasm :deadbolt_lock, namespace: :deadbolt do
  #   state :unlocked, initial: true
  #   state :locked
  #
  #   event :lock_deadbolt do
  #     transitions to: :locked
  #   end
  #
  #   event :unlock_deadbolt do
  #     transitions to: :unlocked
  #   end
  # end
  #
  # aasm :knob_lock, namespace: :knob do
  #   state :unlocked, initial: true
  #   state :locked
  #
  #   event :lock_knob do
  #     transitions to: :locked
  #   end
  #
  #   event :unlock_knob do
  #     transitions to: :unlocked
  #   end
  # end
end
