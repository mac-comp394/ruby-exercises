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

  for i in ["deadbolt", "knob"]
    aasm (i + "_lock").to_sym, namespace: i.to_sym do
      state :unlocked, initial: true
      state :locked

      event "lock_".concat(i).to_sym do
        transitions to: :locked
      end

      event "unlock_".concat(i).to_sym do
        transitions to: :unlocked
      end
    end
  end
end
